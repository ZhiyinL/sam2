#!/usr/bin/env bash

# Activate the sam2 conda environment
conda activate sam2

# Base directories
data_root="/home/zhiyin/tml-fencing/data_0427"
sam2_repo_dir="/home/zhiyin/tml-fencing/third_party/sam2_repo/sam2"

# List of bout subdirectories
bouts=(
  "24seoulgpms_l32_yagodka_saron_red"
  "24seoulgpws_l64_kong_choi_red"
  "24seoulgpms_l16_yagodka_patrice_red"
  "24seoulgpms_l32_hansol_patrice_red"
  "24seoulgpws_l64_kane_eunhye_red"
)

# Loop through each bout
for bout in "${bouts[@]}"; do
  bout_dir="$data_root/$bout/clips"
  echo "\n=== Processing $bout ==="
  if [ -d "$bout_dir" ]; then
    cd "$sam2_repo_dir" || { echo "Failed to cd to $sam2_repo_dir"; exit 1; }
    python distance_v2.py --bout_dir "$bout_dir"
  else
    echo "Directory $bout_dir not found, skipping."
  fi
done
