{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # ==========================================================================
  # Nix
  # ==========================================================================

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    # Keep old generations around so you can roll back.
    auto-optimise-store = true;
  };

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;


  # ==========================================================================
  # Boot
  # ==========================================================================

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;

      # Press a key during boot if you need the boot menu.
      timeout = 0;
    };

    plymouth.enable = true;

    consoleLogLevel = 3;

    initrd.verbose = false;

    kernelParams = [
      "quiet"
      "rd.udev.log_level=3"
      "rd.systemd.show_status=auto"
      "systemd.restore_state=0"
    ];
  };


  # ==========================================================================
  # Networking
  # ==========================================================================

  networking = {
    hostName = "nixos";

    networkmanager.enable = true;
  };


  # ==========================================================================
  # Time / Locale
  # ==========================================================================

  time.timeZone = "Asia/Kolkata";

  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
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
  };


  # ==========================================================================
  # Keyboard
  # ==========================================================================

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };


  # ==========================================================================
  # User
  # ==========================================================================

  users.users.akash = {
    isNormalUser = true;

    description = "Akash";

    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };


  # ==========================================================================
  # Desktop / Wayland
  # ==========================================================================

  programs.niri.enable = true;

  services.displayManager.ly.enable = true;


  # ==========================================================================
  # Bluetooth
  # ==========================================================================

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };


  # ==========================================================================
  # Audio
  # ==========================================================================

  # PipeWire is recommended for modern Linux desktop audio.
  services.pipewire = {
    enable = true;

    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };


  # ==========================================================================
  # Fonts
  # ==========================================================================

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];


  # ==========================================================================
  # System packages
  # ==========================================================================

  environment.systemPackages = with pkgs; [
    # Editors
    vim
    neovim

    # Shell / terminal utilities
    bash
    wget
    git

    # Terminal
    kitty

    # File manager
    yazi

    # Launcher
    fuzzel

    # Wayland
    waylock
    brightnessctl
    awww
    waybar

    # Bluetooth
    bluetuith

    # Audio
    pulsemixer
    ncpamixer
    alsa-utils

    # System monitoring
    btop
  ];


  # ==========================================================================
  # Programs
  # ==========================================================================

  programs.firefox.enable = true;

  programs.mtr.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };


  # ==========================================================================
  # SSH
  # ==========================================================================

  services.openssh = {
    enable = true;

    # Security-conscious defaults.
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };


  # ==========================================================================
  # Firewall
  # ==========================================================================

  networking.firewall.enable = true;


  # ==========================================================================
  # Niri PATH workaround
  # ==========================================================================

  # NixOS otherwise injects a stripped PATH via Environment=
  # on the niri.service unit.
  #
  # Keep this only if you actually need it with your Niri setup.
  systemd.user.services.niri.enableDefaultPath = false;


  # ==========================================================================
  # NixOS State Version
  # ==========================================================================

  # IMPORTANT:
  #
  # Do not change this just because you upgrade NixOS.
  #
  # It represents the version of the system configuration/data
  # semantics you originally installed with.
  system.stateVersion = "26.05";
}

