#!/usr/bin/env bash
set -uo pipefail

usage() {
  cat <<'EOF'
Usage: untar.sh [FILE_OR_DIR ...]

EOF
}

to_msys_path() {
  local path="$1"

  if command -v cygpath >/dev/null 2>&1; then
    if [[ "$path" =~ ^[A-Za-z]:[\\/] || "$path" == \\\\* ]]; then
      cygpath -u -- "$path"
      return
    fi
  fi

  printf '%s\n' "$path"
}

add_archives_from_dir() {
  local source_directory="$1"
  local archive

  while IFS= read -r -d '' archive; do
    archives+=("$archive")
  done < <(find "$source_directory" -type f -name "*.tar" -print0)
}

extract_archive() {
  local tar_file="$1"
  local archive_name dir_name dest_dir

  archive_name="$(basename -- "$tar_file")"
  if [[ "$archive_name" != *.tar ]]; then
    echo "Skipping non-.tar file: $tar_file" >&2
    return 1
  fi

  if [ ! -s "$tar_file" ]; then
    echo "Skipping empty archive: $tar_file" >&2
    return 1
  fi

  dir_name="${archive_name%.tar}"
  dest_dir="$(dirname -- "$tar_file")/$dir_name"

  mkdir -p "$dest_dir"

  if tar "${tar_force_local[@]}" -x -f "$tar_file" -C "$dest_dir"; then
    echo "Extracted $tar_file to $dest_dir"
    rm -- "$tar_file"
    echo "Deleted $tar_file"
    return 0
  fi

  echo "Failed to extract $tar_file" >&2
  echo "Kept archive. The file may be incomplete or corrupt; partial output may exist in $dest_dir" >&2
  return 1
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if ! command -v tar >/dev/null 2>&1; then
  echo "tar was not found in PATH" >&2
  exit 127
fi

tar_force_local=()
if tar --help 2>/dev/null | grep -q -- "--force-local"; then
  tar_force_local=(--force-local)
fi

archives=()
missing=0

if [ "$#" -eq 0 ]; then
  add_archives_from_dir "$(pwd -P)"
else
  for input in "$@"; do
    path="$(to_msys_path "$input")"

    if [ -d "$path" ]; then
      add_archives_from_dir "$path"
    elif [ -f "$path" ]; then
      archives+=("$path")
    else
      echo "Skipping missing path: $input" >&2
      missing=$((missing + 1))
    fi
  done
fi

if [ "${#archives[@]}" -eq 0 ]; then
  echo "No .tar files found."
  exit "$missing"
fi

success=0
failed="$missing"

for tar_file in "${archives[@]}"; do
  if extract_archive "$tar_file"; then
    success=$((success + 1))
  else
    failed=$((failed + 1))
  fi
done

echo "Done. Extracted: $success Failed: $failed"

if [ "$failed" -gt 0 ]; then
  exit 1
fi
