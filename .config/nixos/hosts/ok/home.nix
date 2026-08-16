{ config, pkgs, ... }:

let

  dotfiles = "/home/ok/.dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in {
  home.username = "ok";
  home.homeDirectory = "/home/ok";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    awww
    blender
    btop
    brightnessctl
    discord
    emacs
    ffmpeg
    file
    findutils
    fzf
    gh
    git
    hledger
    imagemagick
    imv
    kitty
    libheif
    libreoffice
    mpv
    ncdu
    nautilus
    networkmanagerapplet
    pandoc
    pamixer
    playerctl
    poppler_utils
    python3
    ripgrep
    rofi-wayland
    sioyek
    tmux
    unzip
    wdisplays
    wf-recorder
    wl-clipboard
    wlogout
    wofi
    wtype
    yazi
    zathura
    zen-browser
    zoxide
  ];

  programs = {
    fish = {
      enable = true;
      interactiveShellInit = ''
        set -gx EDITOR "emacs -nw"
        set -gx VISUAL "emacs -nw"
        set -gx LEDGER_FILE "$HOME/finance/2026.journal"
        zoxide init fish | source

        for scripts_root in "$HOME/.local/share/dotfiles/sh" "$HOME/.local/share/dotfiles/ok"
          if test -d "$scripts_root"
            for script_dir in (find -L "$scripts_root" -type d -print)
              fish_add_path --append "$script_dir"
            end
          end
        end

        alias y="yazi"
        alias e="emacs -nw"
      '';
    };
    git = {
      enable = true;
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = false;
      };
    };
  };

  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  xdg.configFile = {
    "hypr/hyprland.conf".source = link ".config/hypr/hyprland.conf";
    "waybar/config.jsonc".source = link ".config/waybar/config.jsonc";
    "waybar/style.css".source = link ".config/waybar/style.css";
    "kitty/kitty.conf".source = link ".config/kitty/kitty.conf";
    "kitty/theme.conf".source = link ".config/kitty/theme.conf";
    "yazi/yazi.toml".source = link ".config/yazi/yazi.toml";
    "beets/config.yaml".source = link ".config/beets/config.yaml";
  };

  home.file = {
    ".local/share/dotfiles/sh".source = link "sh";
    ".local/share/dotfiles/py".source = link "py";
    ".local/share/dotfiles/ps".source = link "ps";
    ".local/share/dotfiles/ok".source = link "ok";

    ".local/bin/record.sh" = {
      source = link "sh/run/record.sh";
      executable = true;
    };
    ".local/bin/ffmpeg-record" = {
      source = link "sh/run/ffmpeg-record";
      executable = true;
    };
  };
}
