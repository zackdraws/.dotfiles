#!/usr/bin/env bash
set -euo pipefail

SERVICE_NAME="${SERVICE_NAME:-msys2_sshd}"
SERVICE_DISPLAY="${SERVICE_DISPLAY:-MSYS2 OpenSSH Server}"
SERVICE_DESC="${SERVICE_DESC:-MSYS2 OpenSSH server with UCRT64 environment}"
FIREWALL_RULE="${FIREWALL_RULE:-MSYS2 OpenSSH Server (sshd)}"
OPEN_FIREWALL="${OPEN_FIREWALL:-1}"
REINSTALL="${REINSTALL:-0}"

die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

info() {
  printf '%s\n' "$*"
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "missing required command: $1"
}

is_windows_admin() {
  powershell.exe -NoProfile -ExecutionPolicy Bypass -Command \
    '([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)' \
    2>/dev/null | tr -d '\r' | grep -qi '^true$'
}

case "$(uname -s)" in
  MSYS_NT*|MINGW*_NT*) ;;
  *) die "this script is intended for MSYS2 on Windows" ;;
esac

if [[ "${MSYSTEM:-}" != "UCRT64" ]]; then
  die "open an MSYS2 UCRT64 shell first; current MSYSTEM is '${MSYSTEM:-unset}'"
fi

require_cmd powershell.exe

if ! is_windows_admin; then
  die "run this from an elevated UCRT64 shell so Windows services can be configured"
fi

require_cmd pacman
require_cmd cygpath

info "Installing OpenSSH and the MSYS2 service wrapper..."
pacman -S --needed --noconfirm openssh cygrunsrv

require_cmd ssh-keygen
require_cmd sshd
require_cmd cygrunsrv

info "Generating missing server host keys..."
ssh-keygen -A >/dev/null

info "Validating sshd config..."
sshd -t -f /etc/ssh/sshd_config

service_exists() {
  cygrunsrv -Q "$SERVICE_NAME" >/dev/null 2>&1
}

if service_exists && [[ "$REINSTALL" == "1" ]]; then
  info "Reinstalling existing service: $SERVICE_NAME"
  cygrunsrv -E "$SERVICE_NAME" >/dev/null 2>&1 || true
  cygrunsrv -R "$SERVICE_NAME"
fi

if ! service_exists; then
  info "Installing automatic Windows service: $SERVICE_NAME"
  cygrunsrv \
    -I "$SERVICE_NAME" \
    -d "$SERVICE_DISPLAY" \
    -f "$SERVICE_DESC" \
    -p /usr/bin/sshd \
    -a "-D -e" \
    -c / \
    -t auto \
    -y tcpip \
    -e MSYSTEM=UCRT64 \
    -e CHERE_INVOKING=1 \
    -e MSYS2_PATH_TYPE=inherit
else
  info "Service already exists: $SERVICE_NAME"
  if ! cygrunsrv -VQ "$SERVICE_NAME" | grep -q 'MSYSTEM="UCRT64"'; then
    info "Existing service does not show MSYSTEM=UCRT64; rerun with REINSTALL=1 to recreate it."
  fi
fi

info "Ensuring service starts automatically..."
sc.exe config "$SERVICE_NAME" start= auto >/dev/null

info "Starting service..."
cygrunsrv -S "$SERVICE_NAME" >/dev/null 2>&1 || true
if ! cygrunsrv -Q "$SERVICE_NAME" | grep -q 'Current State[[:space:]]*: Running'; then
  die "service did not start: $SERVICE_NAME"
fi

if [[ "$OPEN_FIREWALL" == "1" ]]; then
  info "Ensuring firewall allows TCP 22 on Domain and Private profiles..."
  SSHD_WIN_PATH="$(cygpath -w /usr/bin/sshd.exe)"
  FIREWALL_RULE="$FIREWALL_RULE" SSHD_WIN_PATH="$SSHD_WIN_PATH" \
    powershell.exe -NoProfile -ExecutionPolicy Bypass -Command '
    $ErrorActionPreference = "Stop"
    $ruleName = $env:FIREWALL_RULE
    $program = $env:SSHD_WIN_PATH
    $existing = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue
    if ($null -eq $existing) {
      New-NetFirewallRule -DisplayName $ruleName -Direction Inbound -Action Allow -Protocol TCP -LocalPort 22 -Program $program -Profile Domain,Private | Out-Null
    } else {
      Set-NetFirewallRule -DisplayName $ruleName -Enabled True -Direction Inbound -Action Allow -Profile Domain,Private
    }
  '
fi

info "OpenSSH service status:"
cygrunsrv -VQ "$SERVICE_NAME" | sed -n \
  -e '/^Service/p' \
  -e '/^Display name/p' \
  -e '/^Current State/p' \
  -e '/^Command/p' \
  -e '/^Environment/p' \
  -e '/^Startup/p'

info "Done."
