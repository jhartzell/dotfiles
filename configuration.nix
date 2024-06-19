# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, pkgs, lib, nixpkgs-unstable, nixos-hardware, nixgl, hyprland, hyprlock, hypridle, vars, ... }:
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Default system packages
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
  ];

  # Set the default editor to vim
  environment.variables.EDITOR = "vim";
  # Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set up X11
  #services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  #services.xserver.displayManager.sddm.enable = true;
  #services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  #services.xserver.layout = "us"  
  #services.xserver.xkbVariant = "";

  # Enable greetd
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${pkgs.hyprland}/bin/Hyprland";
        user = "zyph";
      };
      default_session = initial_session;
    };
  };

  services.xserver.displayManager.sessionCommands = ''
    ${lib.getBin pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all
  '';

  # Enable the OpenSSH daemon.
  services.openssh.enable = false;

  # Enable sound with pipewire
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    nerdfonts
  ];

  # OpenGL Support
  hardware.opengl = {
    enable = true;
    driSupport = true;
  };

  # Enable ZSH
  programs.zsh.enable = true;
  programs.dconf.enable = true;

  # My base user
  users.users.zyph = {
    isNormalUser = true;
    description = "zyph";
    extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
    # shell = pkgs.zsh;
    createHome = true;
    packages = with pkgs; [
    ];
  };

  # Gnome Keyring
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.gnomekey.enableGnomeKeyring = true;
  security.polkit.enable = true;
  security.sudo.wheelNeedsPassword = false;

  # XDG Portal Configuration
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk ];
  };

  # Allow unfree licensed packages to be installed
  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 2d";
    };
    package = pkgs.nixVersions.unstable;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';
  };

  system.stateVersion = "23.11"; # Did you read the comment?

}
