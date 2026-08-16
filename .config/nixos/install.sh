#!/usr/bin/env bash
set -euo pipefail
target_root="/mnt"
host="ok"
run_install=0

usage() {
}

while (($#)); do
  case "$1" in
    --target)
      target_root="${2:?--target needs a path}"
      shift 2
      ;;
    --host)
      host="${2:?--host needs a NixOS configuration name}"
      shift 2
      ;;
    --install)
      run_install=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown argument: %s\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ $EUID -ne 0 ]]; then
  printf 'Run script as sudo).\n' >&2
  exit 1
fi

for command in findmnt nixos-generate-config cp; do
  command -v "$command" >/dev/null || {
    printf 'Required command is unavailable: %s\n' "$command" >&2
    exit 1
  }
done

if ! findmnt --target "$target_root" >/dev/null; then
  printf 'No filesystem is mounted at %s. Mount the NixOS target first.\n' "$target_root" >&2
  exit 1
fi

source_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
source_nixos="$source_root/nixos"
target_repo="$target_root/home/ok/.dotfiles"
target_nixos="$target_repo/nixos"

[[ -f "$source_nixos/flake.nix" ]] || {
  printf 'Could not find nixos/flake.nix next to this script.\n' >&2
  exit 1
}

if [[ "$source_root" != "$target_repo" ]]; then
  if [[ -e "$target_repo" ]]; then
    printf 'Refusing to overwrite existing checkout: %s\n' "$target_repo" >&2
    printf 'Remove or move it yourself, then run this script again.\n' >&2
    exit 1
  fi

  install -d -m 0755 "$target_root/home/ok"
  cp -a "$source_root" "$target_repo"
fi

# Generate this only after the real target filesystems are mounted. The result
# replaces the intentionally failing template committed to the repository.
nixos-generate-config --root "$target_root"
cp -f "$target_root/etc/nixos/hardware-configuration.nix" \
  "$target_nixos/hosts/$host/hardware-configuration.nix"

printf '\nPrepared NixOS configuration:\n  %s#%s\n' "$target_nixos" "$host"
printf 'Hardware configuration: %s\n' "$target_nixos/hosts/$host/hardware-configuration.nix"

if (( ! run_install )); then
  cat <<EOF

Review the generated hardware configuration, then install with:
  sudo bash $target_nixos/install.sh --target $target_root --host $host --install
EOF
  exit 0
fi

command -v nixos-install >/dev/null || {
  printf 'nixos-install is unavailable; run this from the NixOS installer environment.\n' >&2
  exit 1
}

printf '\nInstalling to the already-mounted target at %s...\n' "$target_root"
nixos-install --root "$target_root" --flake "$target_nixos#$host"

cat <<'EOF'

Installation complete. Reboot, log in as ok, then make the checkout writable:
  sudo chown -R "$USER":users ~/.dotfiles
EOF
