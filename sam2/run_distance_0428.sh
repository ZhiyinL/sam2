#!/usr/bin/env bash

# Activate the sam2 conda environment
conda activate sam2

# Base directories
data_root="/home/zhiyin/tml-fencing/data_0428"
sam2_repo_dir="/home/zhiyin/tml-fencing/third_party/sam2_repo/sam2"

# List of bout subdirectories
bouts=(
  # "24seoulgpms_l16_pakdaman_bahgat_yellow"
  # "24seoulgpms_l32_gallo_gu_blue"
  # "24seoulgpms_l32_do_bahgat_yellow"
  # "24seoulgpms_l32_jeong_bazadze_blue"

  # "24seoulgpms_l32_pakdaman_yildirim_yellow"
  # "24seoulgpms_l8_moataz_heathcock_yellow"
  # "24seoulgpws_l16_apithybrunet_battiston_yellow"
  # "24seoulgpws_l16_navarro_kharlan_yellow"
  # "24seoulgpws_l32_battiston_rioux_yellow"
  # "24seoulgpws_l32_dayibekova_navarro_yellow"
  # "24seoulgpws_l32_kim_kharlan_yellow"
  # "24seoulgpws_l8_apithybrunet_navarro_yellow"
  
  # "24seoulgpms_l32_streets_oh_green"
  # "24seoulgpms_l32_kokubo_pianfetti_green"
  # "24seoulgpws_l32_chamberlain_yang_green"
  # "24seoulgpws_l16_noutcha_takahashi_green"
  # "24seoulgpws_l32_marton_takahashi_green"
  # "24seoulgpws_l32_noutcha_nazlymov_green"

  "24seoulgpws_l32_lusinier_emura_blue"
  "24seoulgpws_l8_martinportugues_berder_blue"
  "24seoulgpms_l16_szabo_apithy_blue"
  "24seoulgpms_l32_arfa_apithy_blue"
  "24seoulgpws_l32_berder_queroli_blue"
  "24seoulgpws_l16_berder_emura_blue"
  "24seoulgpws_l16_martinportugues_katona_blue"
  "24seoulgpms_l32_szabo_repetti_blue"
  "24seoulgpms_l8_apithy_bazadze_blue"
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
