{ config, pkgs, lib, wlctl, nirimon, helium, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ./modules/niri.nix
    ./modules/audio.nix
    ./modules/packages.nix
    ./modules/tui-packages.nix
  ];

  # ==========================================================================
  # Home Manager
  # ==========================================================================

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = {
      inherit wlctl nirimon;
    };

    users.akash = import ./home.nix;
  };


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
  nixpkgs.overlays = [ helium.overlays.default ];


  # ==========================================================================
  # Dynamic loader for non-Nix binaries
  # ==========================================================================

  # Lets manually-installed, dynamically-linked binaries (e.g. the OpenCode
  # binary at ~/.opencode/bin/opencode) run on NixOS.
  programs.nix-ld.enable = true;


  # ==========================================================================
  # Boot
  # ==========================================================================

  boot = {
    loader = {
      # Keep only the last 5 generations in the systemd-boot menu.
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;

      # Boot menu hidden. Hold a key during boot to show it.
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

    firewall.enable = true;
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

    shell = pkgs.fish;

    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };


  # ==========================================================================
  # Bluetooth
  # ==========================================================================

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };


  # ==========================================================================
  # Power management
  # ==========================================================================

  # Power profile switching (power-saver / balanced / performance).
  services.power-profiles-daemon.enable = true;

  # Battery monitoring backend for the battery TUI + Waybar.
  services.upower.enable = true;


  # ==========================================================================
  # Fonts
  # ==========================================================================

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];


  # ==========================================================================
  # Programs
  # ==========================================================================

  programs.fish.enable = true;

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