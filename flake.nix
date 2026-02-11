{ config, pkgs, inputs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  # Bootloader settings
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Networking
  networking.hostName = "my-machine";
  networking.networkmanager.enable = true;

  # User setup
  users.users.user = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "video" ];
  };

  # Niri and experimental features
  programs.niri.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
    vim wget git alacritty firefox scx
  ];

  # Sched-ext settings
  services.scx.enable = true;
  services.scx.scheduler = "scx_rustland";

  system.stateVersion = "24.11";
}
