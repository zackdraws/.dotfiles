#!/usr/bin/env bash
set -e
echo "==> Checking for root privileges..."
if [[ $EUID -ne 0 ]]; then
  echo "run in sudo ."
  exit 1
fi
echo "Enabling multilib repository "
if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
  echo "Enabling multilib repo..."
  sed -i '/#\[multilib\]/,/Include/ s/^#//' /etc/pacman.conf
else
  echo "Multilib repo already enabled."
fi
pacman -Sy --noconfirm
pacman -Su --noconfirm
pacman -S --noconfirm steam
echo "ok"
