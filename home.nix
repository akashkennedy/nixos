{ config, pkgs, ... }:

{
  home.username = "akash";
  home.homeDirectory = "/home/akash";

  home.stateVersion = "26.05";

  home.sessionPath = [
    "$HOME/.opencode/bin"
  ];

  home.packages = with pkgs; [
    fastfetch
    ripgrep
    fd
    tree
    unzip
    zip
    lazygit
    calcurse
    (pkgs.writeShellScriptBin "battery-tui" (builtins.readFile ./scripts/battery-tui))
  ];

  programs.git = {
    enable = true;

    settings = {
      user.name = "Akash";
    };
  };

  programs.bash = {
    enable = true;

    shellAliases = {
      nixos = "cd ~/nixos";

      rebuild = "sudo nixos-rebuild switch --flake ~/nixos#nixos";
      test = "sudo nixos-rebuild test --flake ~/nixos#nixos";
      build = "nixos-rebuild build --flake ~/nixos#nixos";

      update = "nix flake update ~/nixos";
      check = "nix flake check ~/nixos";

      status = "git -C ~/nixos status";
      diff = "git -C ~/nixos diff";
      log = "git -C ~/nixos log --oneline --decorate --graph";

      nixdoc = "less ~/nixos/README.md";
    };
  };

  programs.home-manager.enable = true;

  programs.waybar = {
    enable = true;

    settings.bar = {
      layer = "top";
      position = "top";
      height = 28;
      spacing = 6;

      modules-left = ["niri/workspaces" ];
      modules-center = [ "clock" ];
      modules-right = [ "network" "bluetooth" "battery" ];

      "niri/workspaces" = {
        format = "{icon}";
        format-icons = {
          focused = "●";
          active = "◍";
          urgent = "!";
          empty = "•";
          default = "○";
        };
      };

      network = {
        format-wifi = " {signalStrength}%";
        format-ethernet = "󰀂";
        format-disconnected = "󰤮";
        tooltip-format = "{ifname}: {essid} {signalStrength}%";
        on-click = "kitty --class waybar-tui --title 'WiFi' --geometry 90x28 -e nmtui";
      };

      bluetooth = {
        format = "{icon}";
        format-icons = {
          disabled = "󰂲";
          off = "󰂯";
          on = "󰂯";
          connected = "󰂯";
        };
        format-connected = "󰂯 {num_connections}";
        tooltip-format = "{controller_alias}\t{controller_address}\n\n{status}: {num_connections} connected";
        on-click = "kitty --class waybar-tui --title 'Bluetooth' --geometry 70x26 -e bluetuith";
      };

      battery = {
        interval = 10;
        format = "{capacity}%";
        format-charging = "{capacity}% 󰂄";
        format-warning = "⚠ {capacity}%";
        format-critical = "⛔ {capacity}%";
        tooltip-format = "{power}W · {time}";
        states = {
          warning = 25;
          critical = 10;
        };
        on-click = "kitty --class waybar-tui --title 'Battery' --geometry 60x22 -e battery-tui";
      };

      clock = {
        format = "󰥔 {:%H:%M}";
        tooltip-format = "{:%A, %d %B %Y}";
        on-click = "kitty --class waybar-tui --title 'Calendar' --geometry 90x30 -e calcurse";
      };
    };

    style = ''
      * {
        font-family: "FiraCode Nerd Font", "JetBrainsMono Nerd Font", monospace;
        font-size: 13px;
        border: none;
        border-radius: 0;
        min-height: 0;
      }

      window#waybar {
        background-color: rgba(19, 21, 26, 0.92);
        color: #d8dee9;
      }

      #workspaces button {
        padding: 0 6px;
        color: #5e6a7d;
      }
      #workspaces button.focused {
        background-color: rgba(94, 129, 172, 0.30);
        color: #88c0d0;
      }
      #workspaces button.active {
        color: #88c0d0;
      }
      #workspaces button.urgent {
        color: #bf616a;
      }

      #network { color: #81a1c1; }
      #bluetooth { color: #81a1c1; }
      #clock { color: #d8dee9; }
      #battery { color: #a3be8c; }
      #battery.warning { color: #ebcb8b; }
      #battery.critical { color: #bf616a; }

      #network, #bluetooth, #battery, #clock {
        padding: 0 8px;
      }

      #network:hover, #bluetooth:hover, #battery:hover, #clock:hover,
      #workspaces button:hover {
        background-color: rgba(94, 129, 172, 0.40);
        color: #eceff4;
      }

      tooltip {
        background-color: rgba(19, 21, 26, 0.95);
        border: 1px solid #3b4252;
        color: #d8dee9;
      }
    '';
  };
}
