{ config, pkgs, ... }:

{
  imports =
    [ ./hardware-configuration.nix ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
    plymouth.enable = true;
    plymouth.theme = "bgrt";
    initrd.systemd.enable = true;
    initrd.verbose = false;
    consoleLogLevel = 0;
    # Run "btrfs inspect-internal map-swapfile -r /swap/swapfile" and replace 533760
    kernelParams = [ "quiet" "udev.log_level=0" "resume_offset=533760" ];
    resumeDevice = "/dev/mapper/crypted";
  };

  swapDevices = [ { device = "/swap/swapfile"; priority = 0; } ];
  systemd.sleep.extraConfig = "HibernateDelaySec=30m";

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Kolkata";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  users.users.parikshit = {
    isNormalUser = true;
    description = "parikshit";
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    packages = with pkgs; [];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
  ];

  system.stateVersion = "25.11";

}
