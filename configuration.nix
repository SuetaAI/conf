{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  # 1. Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # 2. Kernel (Latest required for sched_ext support)
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # 3. Networking
  networking.hostName = "my-machine";
  networking.networkmanager.enable = true;

  # 4. Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true; # GUI for bluetooth

  # 5. Audio (Pipewire is essential for Niri/Wayland)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # 6. User account
  users.users.user = { # You can change 'user' to your name later
    isNormalUser = true;
    description = "Main User";
    extraGroups = [ "networkmanager" "wheel" "video" ];
  };

  # 7. Niri & Graphics
  programs.niri.enable = true;
  # We disable SDDM/GDM. You will log in via TTY and type 'niri session'
  services.displayManager.sddm.enable = false; 

  # 8. Packages
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    alacritty # Terminal needed inside Niri
    firefox
    
    # SCHED_EXT tools
    # Usage: sudo scx_rusty (after reboot)
    scx 
  ];

  system.stateVersion = "25.11";
}
