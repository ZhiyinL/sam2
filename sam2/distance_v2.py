import os
import sys
import numpy as np
import pandas as pd
import argparse

from sympy import uppergamma

sys.path.append("/home/zhiyin/tml-fencing")

from src.distance import Sam2FencerTracker, load_prompt_points, choose_warning_hsv

def main(bout_dir: str):
    # --- Settings ---
    sam2_checkpoint = "../checkpoints/sam2.1_hiera_large.pt"
    sam2_config = "./configs/sam2.1/sam2.1_hiera_l.yaml"

    color = bout_dir.split("/")[-2].split("_")[-1]
    try:
        lower_warning_hsv, upper_warning_hsv = choose_warning_hsv(color)
    except ValueError as e:
        print(e)
        return

    tracker_settings = dict(
        sam2_checkpoint=sam2_checkpoint,
        sam2_config=sam2_config,
        short_line_tol=0.01,
        slope_border_max=0.4,
        min_sep_px=100,
        min_line_length=100,
        max_line_length=450,
        max_ext_line_length=500,
        min_tilt_deg=10,
        window_thresh=5,
        std_thresh=2.0,
        verbose=False,
        lower_warning_hsv=lower_warning_hsv,
        upper_warning_hsv=upper_warning_hsv,
    )

    # --- Process clips ---
    clip_dirs = sorted([
        d for d in os.listdir(bout_dir)
        if d.startswith("clip_") and d.endswith(".mp4") and os.path.isdir(os.path.join(bout_dir, d.replace(".mp4", "")))
    ])

    print(f"Found {len(clip_dirs)} clips under {bout_dir}: {clip_dirs}")

    for clip_dir in clip_dirs:
        clip_idx = int(clip_dir.replace("clip_", "").replace(".mp4", ""))
        video_dir = os.path.join(bout_dir, f"clip_{clip_idx}")   # the folder
        video_path = os.path.join(bout_dir, f"clip_{clip_idx}.mp4")   # the mp4 inside
        print(f"\n=== Processing clip {clip_idx} ===")

        if not os.path.exists(video_path):
            print(f"🔥 Error: video file {video_path} does not exist. Skipping.")
            continue

        prompt_path = os.path.join(video_dir, "prompt_points.json")
        if not os.path.exists(prompt_path):
            print(f"🔥 Error: prompt points {prompt_path} not found. Skipping clip {clip_idx}.")
            continue

        prompt_points = load_prompt_points(prompt_path)
        print(f"Loaded prompts for clip {clip_idx}.")

        try:
            tracker = Sam2FencerTracker(**tracker_settings)

            df = tracker.track_video(
                video_path=video_path,
                video_dir=video_dir,
                prompt_points=prompt_points,
            )
            # if output path does not exist, create it
            output_dir = video_dir.replace('data', 'output_wham')
            if not os.path.exists(output_dir):
                os.makedirs(output_dir, exist_ok=True)
            # save the dataframe to a csv file
            output_csv = os.path.join(output_dir, "fencer_distances.csv")
            df.to_csv(output_csv, index=False)
            print(f"Saved results to {output_csv}.")

        except Exception as e:
            print(f"🔥🔥🔥 Error processing clip {clip_idx}: {e}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Batch process fencing clips in a bout directory."
    )
    parser.add_argument(
        '--bout_dir',
        type=str,
        default="/home/zhiyin/tml-fencing/data_0427/24seoulgpms_l32_yagodka_saron_red/clips", 
        help='Path to the bout directory containing clip_*.mp4 and clip_* folders'
    )
    args = parser.parse_args()
    main(args.bout_dir)