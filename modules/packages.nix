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

    # Network diagnostics
    mtr

    # Dev tools
    nodejs
  ];
}