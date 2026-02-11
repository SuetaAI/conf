{ config, pkgs, inputs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  # 1. Bootloader and Kernel
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest; # Required for SCX

  # 2. Networking
  networking.hostName = "my-machine";
  networking.networkmanager.enable = true;

  # 3. Graphics (This fix is for libgbm/mesa)
  hardware.graphics.enable = true;

  # 4. Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # 5. Sound (Pipewire)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # 6. User Account
  users.users.user = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "video" ];
  };

  # 7. Niri Configuration
  programs.niri.enable = true;
  services.displayManager.sddm.enable = false; # Manual TTY login

  # 8. Packages
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = with pkgs; [
    vim wget git alacritty firefox
    mesa # Essential for GBM/Niri
  ];

  # 9. SCX Scheduler
  services.scx.enable = true;
  services.scx.scheduler = "scx_rustland";

  system.stateVersion = "24.11"; #
}
