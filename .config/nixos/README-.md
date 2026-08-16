# NixOS configuration

## Install

1. Run the install step:

   ```sh
   sudo bash /mnt/home/ok/.dotfiles/nixos/install.sh --install
   ```

2. Reboot, log in as `ok`, then make sure the checkout is owned by that user:

   ```sh
   sudo chown -R "$USER":users ~/.dotfiles
   ```

   Start Hyprland from your display manager or TTY.

After installation, rebuild from the repository with:

```sh
sudo nixos-rebuild switch --flake ~/.dotfiles/nixos#ok
```

The linked desktop files remain editable in `.config`. Home Manager updates
their links on the next rebuild. The `sh`, `py`, `ps`, and `ok` script folders
are also live-linked under `~/.local/share/dotfiles`; every subdirectory of
`sh` and `ok` is placed on Fish's `PATH`, retaining the original folder
structure. When scripts share a filename, invoke the intended one by its full
path under `~/.local/share/dotfiles`. 