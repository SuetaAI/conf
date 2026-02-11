{ config, pkgs, inputs, ... }: {
  imports = [ 
    # Mandatory hardware scan result
    ./hardware-configuration.nix 
  ];

  # Bootloader settings
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Use latest kernel for better hardware and sched_ext (scx) support
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Network and Sound
  networking.hostName = "my-machine";
  networking.networkmanager.enable = true;
  
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # User configuration
  users.users.user = {
    isNormalUser = true;
    description = "Main User";
    extraGroups = [ "networkmanager" "wheel" "video" ];
  };

  # Niri compositor configuration (provided by niri-flake)
  programs.niri.enable = true;

  # Core system packages
  environment.systemPackages = with pkgs; [
    vim 
    wget 
    git 
    alacritty 
    firefox
  ];

  # Enable Flakes and new Nix commands
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Sched-ext (SCX) schedulers
  services.scx.enable = true; 
  services.scx.scheduler = "scx_rustland";

  # System state version (do not change after install)
  system.stateVersion = "24.11";
}
