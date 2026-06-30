#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
dotfiles_root="$(cd -- "$script_dir/../.." && pwd)"
config_file="$script_dir/dotfiles-script-links.conf"

if [ -f "$config_file" ]; then
  # shellcheck source=dotfiles-script-links.conf
  source "$config_file"
fi

if ! declare -p DOTFILES_SCRIPT_ROOTS >/dev/null 2>&1; then
  DOTFILES_SCRIPT_ROOTS=(sh/convert sh/copy sh/delete sh/export sh/file sh/format sh/launch sh/make sh/maketiny sh/move sh/plan sh/psd sh/rename sh/run sh/shell_files sh/web)
fi
if ! declare -p DOTFILES_MAINTENANCE_SCRIPT_ROOTS >/dev/null 2>&1; then
  DOTFILES_MAINTENANCE_SCRIPT_ROOTS=(sh/fix sh/install sh/setup)
fi
if ! declare -p DOTFILES_SKIP_PATHS >/dev/null 2>&1; then
  DOTFILES_SKIP_PATHS=(sh/trash sh/ps1 sh/fix/debloat-pc sh/fix/fix.sh sh/fix/list.sh)
fi
if ! declare -p DOTFILES_WINDOWS_SKIP_PATHS >/dev/null 2>&1; then
  DOTFILES_WINDOWS_SKIP_PATHS=()
fi
if ! declare -p DOTFILES_COMMAND_ALIASES >/dev/null 2>&1; then
  DOTFILES_COMMAND_ALIASES=()
fi
if ! declare -p DOTFILES_WINDOWS_REPLACEMENTS >/dev/null 2>&1; then
  DOTFILES_WINDOWS_REPLACEMENTS=()
fi

usage() {
  cat <<'EOF'
Usage: bash sh/setup/link-sh-scripts.sh [options]

Links runnable scripts from this dotfiles repo into the right command folder.

Options:
  --target DIR              Override target bin directory.
  --platform NAME           Override detected platform: linux, windows-msys, macos.
  --include-maintenance     Also include sh/fix, sh/install, and sh/setup.
  --dry-run                 Print what would change.
  --force                   Replace existing non-symlink targets.
  --sudo                    Use sudo for target changes.
  --no-sudo                 Do not use sudo.
  --print-manifest          Print command/source/interpreter rows and exit.
  -h, --help                Show this help.

Defaults:
  Linux/Arch:   /usr/local/bin with sudo.
  MSYS2/Windows: ~/.local/bin without sudo.
EOF
}

detect_platform() {
  case "$(uname -s 2>/dev/null || echo unknown)" in
    MSYS_NT*|MINGW*_NT*|CYGWIN*) echo "windows-msys" ;;
    Darwin*) echo "macos" ;;
    Linux*) echo "linux" ;;
    *) echo "unix" ;;
  esac
}

target_dir=""
platform=""
include_maintenance=0
dry_run=0
force=0
sudo_mode="auto"
print_manifest=0

while [ "$#" -gt 0 ]; do
  case "$1" in
    --target)
      target_dir="${2:-}"
      [ -n "$target_dir" ] || { echo "--target needs a directory" >&2; exit 2; }
      shift 2
      ;;
    --platform)
      platform="${2:-}"
      [ -n "$platform" ] || { echo "--platform needs a value" >&2; exit 2; }
      shift 2
      ;;
    --include-maintenance)
      include_maintenance=1
      shift
      ;;
    --dry-run)
      dry_run=1
      shift
      ;;
    --force)
      force=1
      shift
      ;;
    --sudo)
      sudo_mode="yes"
      shift
      ;;
    --no-sudo)
      sudo_mode="no"
      shift
      ;;
    --print-manifest)
      print_manifest=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

platform="${platform:-$(detect_platform)}"

if [ -z "$target_dir" ]; then
  if [ "$platform" = "windows-msys" ]; then
    target_dir="${DOTFILES_MSYS_BIN_DIR:-$HOME/.local/bin}"
  else
    target_dir="${DOTFILES_LINUX_BIN_DIR:-/usr/local/bin}"
  fi
fi

need_sudo=0
case "$sudo_mode" in
  yes) need_sudo=1 ;;
  no) need_sudo=0 ;;
  auto)
    if [ "$platform" != "windows-msys" ]; then
      case "$target_dir" in
        /usr/*|/bin|/bin/*|/sbin|/sbin/*|/opt/*) need_sudo=1 ;;
      esac
    fi
    ;;
esac

path_is_under() {
  local path="$1"
  local prefix
  shift
  for prefix in "$@"; do
    prefix="${prefix%/}"
    if [[ "$path" == "$prefix" || "$path" == "$prefix/"* ]]; then
      return 0
    fi
  done
  return 1
}

first_line() {
  local path="$1"
  IFS= read -r line < "$path" || true
  printf '%s' "${line:-}"
}

has_shebang() {
  [[ "$(first_line "$1")" == '#!'* ]]
}

is_candidate_script() {
  local abs="$1"
  local base="${abs##*/}"

  case "$base" in
    .*|*~|\#*\#) return 1 ;;
  esac

  case "$base" in
    *.sh|*.bash|*.fish) return 0 ;;
    *.py) has_shebang "$abs" ;;
    *.*) return 1 ;;
    *) return 0 ;;
  esac
}

command_alias_for() {
  local rel="$1"
  local item source command
  for item in "${DOTFILES_COMMAND_ALIASES[@]}"; do
    source="${item%%|*}"
    command="${item#*|}"
    if [ "$source" = "$rel" ]; then
      printf '%s' "$command"
      return
    fi
  done
  basename "$rel"
}

interpreter_for() {
  local abs="$1"
  local base="${abs##*/}"
  if has_shebang "$abs"; then
    printf 'direct'
    return
  fi

  case "$base" in
    *.fish) printf 'fish' ;;
    *.py) printf 'python3' ;;
    *) printf 'bash' ;;
  esac
}

declare -A command_to_source=()
commands=()
sources=()

add_entry() {
  local rel="$1"
  local command="${2:-}"
  local abs="$dotfiles_root/$rel"

  [ -f "$abs" ] || return 0
  is_candidate_script "$abs" || return 0
  path_is_under "$rel" "${DOTFILES_SKIP_PATHS[@]}" && return 0

  if [ "$platform" = "windows-msys" ] && path_is_under "$rel" "${DOTFILES_WINDOWS_SKIP_PATHS[@]}"; then
    return 0
  fi

  command="${command:-$(command_alias_for "$rel")}"
  if [ -n "${command_to_source[$command]:-}" ]; then
    echo "Skipping duplicate command '$command': $rel already maps to ${command_to_source[$command]}" >&2
    return 0
  fi

  command_to_source["$command"]="$rel"
  commands+=("$command")
  sources+=("$rel")
}

remove_entry_by_source() {
  local rel="$1"
  local i command
  for i in "${!sources[@]}"; do
    [ "${sources[$i]+set}" = "set" ] || continue
    if [ "${sources[$i]}" = "$rel" ]; then
      command="${commands[$i]}"
      unset "command_to_source[$command]"
      unset "commands[$i]"
      unset "sources[$i]"
    fi
  done
}

discover_root() {
  local root_rel="$1"
  local root_abs="$dotfiles_root/$root_rel"
  local file rel
  [ -d "$root_abs" ] || return 0

  while IFS= read -r -d '' file; do
    rel="${file#$dotfiles_root/}"
    add_entry "$rel"
  done < <(find "$root_abs" -type f -print0 | sort -z)
}

for root in "${DOTFILES_SCRIPT_ROOTS[@]}"; do
  discover_root "$root"
done

if [ "$include_maintenance" -eq 1 ]; then
  for root in "${DOTFILES_MAINTENANCE_SCRIPT_ROOTS[@]}"; do
    discover_root "$root"
  done
fi

if [ "$platform" = "windows-msys" ]; then
  for replacement in "${DOTFILES_WINDOWS_REPLACEMENTS[@]}"; do
    old_source="${replacement%%|*}"
    rest="${replacement#*|}"
    new_source="${rest%%|*}"
    command="${rest#*|}"
    remove_entry_by_source "$old_source"
    add_entry "$new_source" "$command"
  done
fi

if [ "$print_manifest" -eq 1 ]; then
  for i in "${!sources[@]}"; do
    [ "${sources[$i]+set}" = "set" ] || continue
    abs="$dotfiles_root/${sources[$i]}"
    printf '%s\t%s\t%s\n' "${commands[$i]}" "${sources[$i]}" "$(interpreter_for "$abs")"
  done
  exit 0
fi

run_mkdir() {
  if [ "$dry_run" -eq 1 ]; then
    echo "mkdir -p $target_dir"
  elif [ "$need_sudo" -eq 1 ]; then
    sudo mkdir -p "$target_dir"
  else
    mkdir -p "$target_dir"
  fi
}

target_exists_non_link() {
  local target="$1"
  [ -e "$target" ] && [ ! -L "$target" ]
}

install_link() {
  local source="$1"
  local target="$2"

  if target_exists_non_link "$target" && [ "$force" -ne 1 ]; then
    echo "Skipping existing non-symlink: $target" >&2
    return 0
  fi

  if [ "$dry_run" -eq 1 ]; then
    echo "ln -sfn $source $target"
  elif [ "$need_sudo" -eq 1 ]; then
    sudo ln -sfn "$source" "$target"
  else
    ln -sfn "$source" "$target"
  fi
}

install_wrapper() {
  local source="$1"
  local target="$2"
  local interpreter="$3"
  local tmp

  if target_exists_non_link "$target" && [ "$force" -ne 1 ]; then
    echo "Skipping existing non-symlink: $target" >&2
    return 0
  fi

  if [ "$dry_run" -eq 1 ]; then
    echo "install wrapper: $target -> $interpreter $source"
    return 0
  fi

  tmp="$(mktemp)"
  {
    printf '#!/usr/bin/env bash\n'
    printf 'set -euo pipefail\n'
    printf 'exec %s %q "$@"\n' "$interpreter" "$source"
  } > "$tmp"

  if [ "$need_sudo" -eq 1 ]; then
    sudo install -m 755 "$tmp" "$target"
  else
    install -m 755 "$tmp" "$target"
  fi
  rm -f "$tmp"
}

run_mkdir

linked=0
wrapped=0
for i in "${!sources[@]}"; do
  [ "${sources[$i]+set}" = "set" ] || continue
  source_abs="$dotfiles_root/${sources[$i]}"
  target_abs="$target_dir/${commands[$i]}"
  chmod +x "$source_abs" 2>/dev/null || true

  interpreter="$(interpreter_for "$source_abs")"
  if [ "$interpreter" = "direct" ]; then
    install_link "$source_abs" "$target_abs"
    linked=$((linked + 1))
  else
    install_wrapper "$source_abs" "$target_abs" "$interpreter"
    wrapped=$((wrapped + 1))
  fi
done

echo "Done. Target: $target_dir"
echo "Linked: $linked"
echo "Wrapped no-shebang scripts: $wrapped"

if [ "$platform" = "windows-msys" ]; then
  echo "For native PowerShell/cmd commands, also run:"
  echo "  powershell.exe -ExecutionPolicy Bypass -File sh/setup/link-windows-scripts.ps1 -AddToUserPath"
fi
