{ config, pkgs, lib, ... }:

# System-level packages.
#
# User applications and CLI tools that do not need to be available
# system-wide live in home.nix instead.

{
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
    hyprlock
    hypridle
    brightnessctl
    awww
    waybar
    playerctl

    # Notification daemon (fnottctl must be on the session PATH for binds/indicator)
    fnott

    # On-screen indicators (volume, brightness) for media keys
    swayosd

    # Bluetooth
    bluetui

    # Audio
    pulsemixer
    ncpamixer
    alsa-utils

    # System monitoring
    btop

    # Network diagnostics
    mtr
    bandwhich

    # Dev tools
    nodejs
  ];
}