{ config, lib, pkgs, home-manager, ... }:

{
  imports = [
    ./hardware-configuration.nix
    home-manager.nixosModules.home-manager
    ../../modules/desktop.nix
  ];

  networking.hostName = "ok";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # Assumes a modern UEFI install. For a legacy-BIOS machine, replace this with
  # the appropriate GRUB configuration before running nixos-install.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  users.users.ok = {
    isNormalUser = true;
    description = "ok";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "docker" ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;
  programs.git.enable = true;
  programs.dconf.enable = true;

  services.openssh.enable = true;
  services.syncthing = {
    enable = true;
    user = "ok";
    dataDir = "/home/ok";
    configDir = "/home/ok/.config/syncthing";
    openDefaultPorts = true;
  };

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.ok = import ./home.nix;
  };

  # Keep this at the release used for the first successful installation.
  system.stateVersion = "26.05";
}
