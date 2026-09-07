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

  # ==========================================================================
  # Notifications (swaync)
  # ==========================================================================

  services.swaync = {
    enable = true;

    settings = {
      positionX = "right";
      positionY = "top";
      layer = "overlay";
      control-center-layer = "overlay";
      layer-shell = true;
      cssPriority = "application";

      # Sit just below the waybar.
      margin-top = 38;
      margin-bottom = 8;
      margin-right = 8;
      margin-left = 8;

      control-center-margin-top = 38;
      control-center-margin-bottom = 8;
      control-center-margin-right = 8;
      control-center-margin-left = 8;
      control-center-width = 400;
      control-center-height = 800;

      timeout = 10;
      timeout-low = 5;
      timeout-critical = 0;

      fit-to-screen = true;
      keyboard-shortcuts = true;

      notification-icon-size = 48;
      notification-body-image-height = 128;
      notification-body-image-width = 256;
      image-visibility = "when-available";

      widgets = [ "title" "dnd" "notifications" "mpris" ];

      widget-config = {
        title = {
          text = "Notifications";
          clear-all-button = true;
          button-text = "Clear All";
        };
        dnd = {
          text = "Do Not Disturb";
        };
        mpris = {
          image-size = 96;
          image-radius = 10;
        };
      };
    };

    style = ''
      @define-color noti-bg rgba(19, 21, 26, 0.92);
      @define-color noti-bg-hover rgba(94, 129, 172, 0.40);
      @define-color noti-close-bg rgba(19, 21, 26, 0.9);
      @define-color noti-close-bg-hover #bf616a;
      @define-color noti-border #3b4252;
      @define-color noti-fg #d8dee9;
      @define-color noti-fg-alt #5e6a7d;
      @define-color text #d8dee9;
      @define-color text-disabled #5e6a7d;
      @define-color bg #1e222b;
      @define-color bg-hover rgba(94, 129, 172, 0.30);
      @define-color bg-selected #3b4252;
      @define-color bg-alt #2a2f3a;
      @define-color borders #3b4252;
      @define-color accent #88c0d0;
      @define-color accent-red #bf616a;
      @define-color accent-green #a3be8c;

      * {
        font-family: "FiraCode Nerd Font", "JetBrainsMono Nerd Font", monospace;
        font-size: 13px;
      }

      .notification-row {
        outline: none;
        margin: 8px 10px;
        padding: 0;
      }

      .notification-row:focus,
      .notification-row:hover {
        background: transparent;
      }

      .notification {
        border-radius: 10px;
        border: 1px solid @noti-border;
        background: @noti-bg;
        color: @noti-fg;
        margin: 0;
        padding: 0;
        box-shadow: none;
      }

      .notification-content {
        padding: 10px 12px;
      }

      .notification-default-action,
      .notification-action {
        margin: 0;
        padding: 6px 10px;
        border-radius: 6px;
        color: @text;
        background: transparent;
      }

      .notification-default-action:hover,
      .notification-action:hover {
        background: @bg-hover;
      }

      .close-button {
        background: @noti-close-bg;
        border-radius: 6px;
        color: @text;
      }

      .close-button:hover {
        background: @noti-close-bg-hover;
        color: white;
      }

      .notification-title {
        font-weight: bold;
        color: @accent;
      }

      .notification-body {
        color: @noti-fg;
      }

      .notification-actions {
        border-top: 1px solid @borders;
        background: transparent;
      }

      .control-center {
        background: rgba(19, 21, 26, 0.95);
        border: 1px solid @borders;
        border-radius: 12px;
        color: @text;
      }

      .widget-title {
        color: @accent;
        font-weight: bold;
      }

      .widget-title > button {
        background: transparent;
        color: @text;
        border-radius: 6px;
      }

      .widget-title > button:hover {
        background: @bg-hover;
      }

      .widget-dnd > button {
        background: transparent;
        color: @text;
        border-radius: 8px;
      }

      .widget-dnd > button:hover {
        background: @bg-hover;
      }

      .widget-dnd > button.checked {
        background: @noti-close-bg-hover;
        color: white;
      }

      .widget-mpris {
        color: @accent;
      }

      .widget-mpris > box > button {
        background: transparent;
        border-radius: 6px;
      }

      .widget-mpris > box > button:hover {
        background: @bg-hover;
      }

      .empty-placeholder {
        color: @text-disabled;
      }

      .control-center .notification-row .notification {
        border-radius: 8px;
        margin: 4px;
      }

      .control-center .notification-row:hover .notification {
        background: @bg-hover;
      }
    '';
  };

  # ==========================================================================
  # On-screen indicators (swayosd-server) for volume / brightness
  # ==========================================================================

  systemd.user.services.swayosd = {
    Unit = {
      Description = "SwayOSD daemon";
      Documentation = "https://github.com/ErikReider/SwayOSD";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      ConditionEnvironment = "WAYLAND_DISPLAY";
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.swayosd}/bin/swayosd-server";
      Restart = "on-failure";
      RestartSec = 2;
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };

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
        on-click = "kitty --class waybar-tui --title 'WiFi' -o initial_window_width=90 -o initial_window_height=28 -e wlctl";
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
        on-click = "kitty --class waybar-tui --title 'Bluetooth' -o initial_window_width=70 -o initial_window_height=26 -e bluetui";
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
        on-click = "kitty --class waybar-tui --title 'Battery' -o initial_window_width=60 -o initial_window_height=22 -e batctl";
      };

      clock = {
        format = "{:%H:%M}";
        tooltip-format = "{:%A, %d %B %Y}";
        on-click = "rencal";
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
