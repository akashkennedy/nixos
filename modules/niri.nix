{ config, pkgs, lib, ... }:

# Niri (scrollable-tiling Wayland compositor) + Ly display manager.
#
# Note: the NixOS `programs.niri` module already sets
# `systemd.user.services.niri.enableDefaultPath = false;` so that the user
# session manager keeps the PATH that niri-session imported. No manual
# override is required.

{
  programs.niri.enable = true;

  services.displayManager.ly.enable = true;
}
