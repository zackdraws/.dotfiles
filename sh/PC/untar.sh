#!/usr/bin/env bash
set -euo pipefail

source_directory=$(pwd -P)

find "$source_directory" -type f -name "*.tar" -print0 | while IFS= read -r -d '' tar_file; do
  dir_name=$(basename "$tar_file" .tar)
  dest_dir="$(dirname "$tar_file")/$dir_name"

  mkdir -p "$dest_dir"
  tar -xf "$tar_file" -C "$dest_dir"
  echo "Extracted $tar_file to $dest_dir"

  rm -- "$tar_file"
  echo "Deleted $tar_file"
done
