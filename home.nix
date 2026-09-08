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
  # Notifications (fnott) — Omarchy toast style, Catppuccin Mocha, sharp
  #
  # fnott is a pure-C, GTK-free Wayland notification daemon. The look copies
  # Omarchy's (basecamp/omarchy) NotificationCard: dark surface, subtle 2px
  # border, bold summary, dimmed body, blue accent on normal / red on critical.
  # ==========================================================================

  services.fnott = {
    enable = true;

    settings = {
      main = {
        # Position — top-right, just below the waybar (same spot as swaync was)
        anchor = "top-right";
        edge-margin-horizontal = 20;
        edge-margin-vertical = 36;
        notification-margin = 6;

        layer = "overlay";
        max-width = 340;
        max-icon-size = 40;
        icon-theme = "Papirus-Dark";

        default-timeout = 8;

        # Fonts to match the rest of the desktop
        title-font = "FiraCode Nerd Font";
        summary-font = "FiraCode Nerd Font";
        body-font = "FiraCode Nerd Font";

        # Omarchy card surface
        background = "1e1e2e";
        border-size = 2;
        border-color = "313244";
        border-radius = 0;
        padding-vertical = 12;
        padding-horizontal = 12;

        title-color = "a6adc8";
        summary-color = "cdd6f4";
        body-color = "cdd6f4";

        # Progress (volume / media notifs)
        progress-bar-height = 4;
        progress-color = "6c7086";
        progress-style = "bar";

        # Actions via fuzzel (dmenu replacement)
        selection-helper = "fuzzel --dmenu0";
        selection-helper-uses-null-separator = "yes";
      };

      low = {
        # Dimmed accent — Omarchy tints low urgency toward the muted tone
        title-color = "a6adc8";
        summary-color = "9399b2";
        body-color = "7f849c";
      };

      normal = {
        # Blue accent border, matching the Omarchy "countdown" accent
        border-color = "89b4fa";
        background = "1e1e2e";
        title-color = "a6adc8";
        summary-color = "cdd6f4";
        body-color = "cdd6f4";
      };

      critical = {
        # Urgent accent — orange border as the urgency indicator
        background = "1e1e2e";
        border-color = "fab387";
        title-color = "a6adc8";
        summary-color = "cdd6f4";
        body-color = "cdd6f4";
      };
    };
  };

  # ==========================================================================
  # Notification indicator pill — bottom-center, 20px from the bottom,
  # sharp edges, Catppuccin blue border. A second, minimal waybar instance
  # (waybar is already resident for the top bar, so no new GTK libs load).
  # Shows a bell + count while notifications are pending; left click dismisses
  # the top notification, right click dismisses all.
  # ==========================================================================

  home.file.".local/bin/notif-indicator".text = ''
    #!/usr/bin/env bash
    count=$(${pkgs.fnott}/bin/fnottctl list 2>/dev/null | wc -l)
    if [ "$count" -gt 0 ]; then
      printf '{"text":" %s","class":"active"}' "$count"
    else
      printf '{"text":"","class":"idle"}'
    fi
  '';

  home.file.".local/bin/notif-indicator".executable = true;

  xdg.configFile."waybar/indicator.jsonc".text = ''
    {
      "layer": "overlay",
      "position": "bottom",
      "height": 22,
      "modules-center": ["notif"],
      "notif": {
        "format": "{}",
        "interval": 1,
        "return-type": "json",
        "exec": "${config.home.homeDirectory}/.local/bin/notif-indicator",
        "on-click": "fnottctl dismiss",
        "on-click-right": "fnottctl dismiss all"
      }
    }
  '';

  xdg.configFile."waybar/indicator.css".text = ''
    * {
      border: none;
      border-radius: 0;
      font-family: "FiraCode Nerd Font", "JetBrainsMono Nerd Font", monospace;
      font-size: 12px;
      min-height: 0;
      padding: 0;
      margin: 0;
    }

    window#waybar {
      background: transparent;
      margin-bottom: 20px;
    }

    #notif {
      background: #1e1e2e;
      border: 2px solid #89b4fa;
      border-radius: 0;
      color: #6c7086;
      padding: 0 8px;
    }

    #notif.active {
      background: #313244;
      color: #89b4fa;
    }

    #notif.active:hover {
      background: #45475a;
    }
  '';

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

  # ==========================================================================
  # hyprlock (screen locker) — Catppuccin Mocha
  #
  # Blurred wallpaper + minimal clock/date pinned to the bottom-left corner,
  # and a centered password box in the surface color with a blue ring.
  # ==========================================================================

  xdg.configFile."hypr/hyprlock.conf".text = ''
    general {
        hide_cursor = true
    }

    background {
        monitor =
        path = /home/akash/Downloads/1377801.png
        color = rgba(30, 30, 46, 1.0)
        blur_size = 4
        blur_passes = 2
        noise = 0.0117
        contrast = 0.8917
        brightness = 0.8172
        vibrancy = 0.1686
        vibrancy_darkness = 0.05
    }

    # Clock — bottom-left, 24h time
    label {
        monitor =
        text = $TIME
        font_size = 64
        font_family = FiraCode Nerd Font
        color = rgba(205, 214, 244, 1.0)
        position = 40, 28
        halign = left
        valign = bottom
    }

    # Date — under the clock
    label {
        monitor =
        text = cmd[update:60000] date +"%A, %d %B %Y"
        font_size = 20
        font_family = FiraCode Nerd Font
        color = rgba(166, 173, 200, 1.0)
        position = 42, 108
        halign = left
        valign = bottom
    }

    # Password box
    input-field {
        monitor =
        size = 320, 64
        outline_thickness = 2
        rounding = 10
        dots_size = 0.3
        dots_spacing = 0.3
        dots_center = true

        inner_color = rgba(49, 50, 68, 0.7)
        outer_color = rgba(137, 180, 250, 1.0)
        font_color = rgba(205, 214, 244, 1.0)
        font_family = FiraCode Nerd Font
        placeholder_text = <span foreground="#a6adc8">Enter Password...</span>
        fail_text = $PAMFAIL

        check_color = rgba(166, 227, 161, 1.0)
        fail_color = rgba(243, 139, 168, 1.0)
        capslock_color = rgba(249, 226, 175, 1.0)
        numlock_color = rgba(203, 166, 247, 1.0)

        fade_on_empty = true
        fade_timeout = 2000

        position = 0, 0
        halign = center
        valign = center
    }
  '';

  # ==========================================================================
  # hypridle (idle daemon) — lock before sleep, suspend only on battery
  #
  # After 180 s of inactivity on battery the machine suspends. On AC power the
  # session stays on (no idle sleep). Manual lock: Super+Alt+L.
  # ==========================================================================

  xdg.configFile."hypr/hypridle.conf".text = ''
    general {
        lock_cmd = pidof hyprlock || hyprlock
        before_sleep_cmd = loginctl lock-session
    }

    listener {
        timeout = 180
        on-timeout = ${config.home.homeDirectory}/.local/bin/suspend-on-battery
    }
  '';

  home.file.".local/bin/suspend-on-battery".text = ''
    #!/usr/bin/env bash
    # Idle suspend: only when discharging. On AC power the session stays on.
    for bat in /sys/class/power_supply/BAT*; do
        [ -d "$bat" ] || continue
        if [ "$(cat "$bat/status" 2>/dev/null)" = "Discharging" ]; then
            systemctl suspend
            exit 0
        fi
    done
    exit 0
  '';

  home.file.".local/bin/suspend-on-battery".executable = true;

  systemd.user.services.hypridle = {
    Unit = {
      Description = "Hyprland idle daemon";
      Documentation = "https://wiki.hypr.land/Hypr-Ecosystem/hypridle/";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      ConditionEnvironment = "WAYLAND_DISPLAY";
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.hypridle}/bin/hypridle";
      Restart = "on-failure";
      RestartSec = 2;
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };

  # ==========================================================================
  # Catppuccin Mocha GTK / icon / cursor themes
  # ==========================================================================

  home.sessionVariables = {
    XCURSOR_THEME = "catppuccin-mocha-light-cursors";
    XCURSOR_SIZE = "22";
  };

  gtk = {
    enable = true;

    theme = {
      name = "catppuccin-mocha-blue-standard";
      package = pkgs.catppuccin-gtk.override {
        variant = "mocha";
        accents = [ "blue" ];
      };
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    cursorTheme = {
      name = "catppuccin-mocha-light-cursors";
      package = pkgs.catppuccin-cursors.mochaLight;
      size = 22;
    };
  };

  # ==========================================================================
  # Fuzzel (launcher) — minimal, docked at the bottom, no icons, Catppuccin
  #
  # Uses the same FiraCode Nerd Font as the rest of the desktop (the old
  # "0x Proto Nerd Font" isn't installed and silently fell back), with valid
  # fuzzel 1.14 color keys.
  # ==========================================================================

  xdg.configFile."fuzzel/fuzzel.ini".text = ''
    [main]
    font=FiraCode Nerd Font:size=11
    terminal=kitty
    icons-enabled=no
    layer=overlay
    lines=8
    width=30
    horizontal-pad=14
    vertical-pad=8
    inner-pad=10
    prompt="> "
    anchor=bottom
    y-margin=16

    [colors]
    background=1e1e2eF2
    text=cdd6f4FF
    prompt=89b4faFF
    placeholder=585b70FF
    input=cdd6f4FF
    selection=313244FF
    selection-text=cdd6f4FF
    match=f9e2afFF
    selection-match=f9e2afFF
    border=89b4fa00

    [border]
    width=2
    radius=0
  '';

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
        background-color: rgba(30, 30, 46, 0.92);
        color: #cdd6f4;
      }

      #workspaces button {
        padding: 0 6px;
        color: #6c7086;
      }
      #workspaces button.focused {
        background-color: rgba(137, 180, 250, 0.30);
        color: #89b4fa;
      }
      #workspaces button.active {
        color: #89b4fa;
      }
      #workspaces button.urgent {
        color: #f38ba8;
      }

      #network { color: #89b4fa; }
      #bluetooth { color: #cba6f7; }
      #clock { color: #cdd6f4; }
      #battery { color: #a6e3a1; }
      #battery.warning { color: #f9e2af; }
      #battery.critical { color: #f38ba8; }

      #network, #bluetooth, #battery, #clock {
        padding: 0 8px;
      }

      #network:hover, #bluetooth:hover, #battery:hover, #clock:hover,
      #workspaces button:hover {
        background-color: rgba(137, 180, 250, 0.25);
        color: #cdd6f4;
      }

      tooltip {
        background-color: rgba(17, 17, 27, 0.95);
        border: 1px solid #313244;
        color: #cdd6f4;
      }
    '';
  };
}
