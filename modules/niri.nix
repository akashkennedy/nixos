{ config, pkgs, lib, ... }:

# Niri (scrollable-tiling Wayland compositor) + greetd login manager.
#
# greetd is a minimal, display-server-agnostic login manager daemon; tuigreet
# is its text-based greeter (no GTK/Qt, very lightweight). After login it
# starts the current user's niri desktop session directly.
#
# Note: the NixOS `programs.niri` module already sets
# `systemd.user.services.niri.enableDefaultPath = false;` so that the user
# session manager keeps the PATH that niri-session imported. No manual
# override is required.

{
  programs.niri.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = "greeter";
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --cmd ${pkgs.niri}/bin/niri-session";
      };
    };
  };
}
