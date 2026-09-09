{ config, pkgs, ... }:

{
  imports = [
    ./modules/neovim.nix
    ./modules/themes.nix
  ];

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
    bat
    tree
    unzip
    zip
    lazygit

    # C/C++ toolchain
    gcc
    gdb
    gnumake
    cmake
    pkg-config
  ];

  programs.git = {
    enable = true;

    settings = {
      user.name = "Akash";
    };
  };

  programs.fish = {
    enable = true;

    shellAliases = {
      nixos = "cd ~/nixos";

      rebuild = "sudo nixos-rebuild switch --flake ~/nixos#nixos";
      nixtest = "sudo nixos-rebuild test --flake ~/nixos#nixos";
      build = "nixos-rebuild build --flake ~/nixos#nixos";

      update = "nix flake update ~/nixos";
      check = "nix flake check ~/nixos";

      gs = "git -C ~/nixos status";
      diff = "git -C ~/nixos diff";
      log = "git -C ~/nixos log --oneline --decorate --graph";

      nixdoc = "less ~/nixos/README.md";
    };

    interactiveShellInit = ''
      # Suppress the 'Welcome to fish' greeting banner
      set -g fish_greeting

      # Load Pure prompt. nixpkgs 26.05 ships fishPlugins.pure (v4.18.0) using
      # the fish "vendor" layout (share/fish/vendor_functions.d etc.) instead of
      # the legacy functions/conf.d layout that home-manager's programs.fish.plugins
      # expects, so we wire it up manually here.
      set -g pure_share "${pkgs.fishPlugins.pure}/share/fish"
      set fish_function_path $pure_share/vendor_functions.d $fish_function_path
      set fish_complete_path $pure_share/vendor_completions.d $fish_complete_path
      for f in $pure_share/vendor_conf.d/*.fish
          source $f
      end

      # Pure prompt customisation
      # Keep the current directory on its own line (bigger, more breathing room)
      set -g pure_enable_single_line_prompt false

      # Show the full home path instead of abbreviating it to '~'
      function _pure_prompt_current_folder --argument-names current_prompt_width
          if test -z "$current_prompt_width"; return 1; end
          set --local current_folder (_pure_parse_directory (math $COLUMNS - $current_prompt_width - 1))
          set --local current_folder (string replace --regex '^~' "$HOME" $current_folder)
          set --local current_folder_color (_pure_set_color $pure_color_current_directory)
          echo "$current_folder_color$current_folder"
      end
    '';
  };

  programs.home-manager.enable = true;

  # ==========================================================================
  # eza — modern `ls` with icons + Catppuccin Mocha theme
  # ==========================================================================

  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    icons = "auto";
    colors = "auto";
    git = true;
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];

    # Catppuccin Mocha (blue accent), matching the desktop theme
    theme = {
      colourful = true;

      filekinds = {
        normal = { foreground = "#cdd6f4"; };
        directory = { foreground = "#89b4fa"; };
        symlink = { foreground = "#89b4fa"; };
        pipe = { foreground = "#bac2de"; };
        block_device = { foreground = "#eba0ac"; };
        char_device = { foreground = "#eba0ac"; };
        socket = { foreground = "#bac2de"; };
        special = { foreground = "#cba6f7"; };
        executable = { foreground = "#a6e3a1"; };
        mount_point = { foreground = "#94e2d5"; };
      };

      perms = {
        user_read = { foreground = "#f38ba8"; is_bold = true; };
        user_write = { foreground = "#f9e2af"; is_bold = true; };
        user_execute_file = { foreground = "#a6e3a1"; is_bold = true; };
        user_execute_other = { foreground = "#a6e3a1"; is_bold = true; };
        group_read = { foreground = "#f38ba8"; };
        group_write = { foreground = "#f9e2af"; };
        group_execute = { foreground = "#a6e3a1"; };
        other_read = { foreground = "#f38ba8"; };
        other_write = { foreground = "#f9e2af"; };
        other_execute = { foreground = "#a6e3a1"; };
        special_user_file = { foreground = "#cba6f7"; };
        special_other = { foreground = "#7f849c"; };
        attribute = { foreground = "#9399b2"; };
      };

      size = {
        major = { foreground = "#a6adc8"; };
        minor = { foreground = "#89dceb"; };
        number_byte = { foreground = "#bac2de"; };
        number_kilo = { foreground = "#a6adc8"; };
        number_mega = { foreground = "#89b4fa"; };
        number_giga = { foreground = "#cba6f7"; };
        number_huge = { foreground = "#cba6f7"; };
        unit_byte = { foreground = "#a6adc8"; };
        unit_kilo = { foreground = "#89dceb"; };
        unit_mega = { foreground = "#cba6f7"; };
        unit_giga = { foreground = "#cba6f7"; };
        unit_huge = { foreground = "#94e2d5"; };
      };

      users = {
        user_you = { foreground = "#cdd6f4"; };
        user_root = { foreground = "#f38ba8"; };
        user_other = { foreground = "#eba0ac"; };
        group_yours = { foreground = "#a6adc8"; };
        group_other = { foreground = "#9399b2"; };
        group_root = { foreground = "#f38ba8"; };
      };

      links = {
        normal = { foreground = "#89b4fa"; };
        multi_link_file = { foreground = "#89b4fa"; };
      };

      git = {
        new = { foreground = "#a6e3a1"; };
        modified = { foreground = "#f9e2af"; };
        deleted = { foreground = "#eba0ac"; };
        renamed = { foreground = "#94e2d5"; };
        typechange = { foreground = "#f5c2e7"; };
        ignored = { foreground = "#7f849c"; };
        conflicted = { foreground = "#fab387"; };
      };

      git_repo = {
        branch_main = { foreground = "#a6adc8"; };
        branch_other = { foreground = "#cba6f7"; };
        git_clean = { foreground = "#a6e3a1"; };
        git_dirty = { foreground = "#eba0ac"; };
      };

      security_context = {
        colon = { foreground = "#6c7086"; };
        user = { foreground = "#7f849c"; };
        role = { foreground = "#cba6f7"; };
        typ = { foreground = "#585b70"; };
        range = { foreground = "#cba6f7"; };
      };

      file_type = {
        image = { foreground = "#f9e2af"; };
        video = { foreground = "#f38ba8"; };
        music = { foreground = "#a6e3a1"; };
        lossless = { foreground = "#94e2d5"; };
        crypto = { foreground = "#7f849c"; };
        document = { foreground = "#cdd6f4"; };
        compressed = { foreground = "#f5c2e7"; };
        temp = { foreground = "#eba0ac"; };
        compiled = { foreground = "#74c7ec"; };
        source = { foreground = "#89b4fa"; };
      };

      punctuation = { foreground = "#6c7086"; };
      date = { foreground = "#f9e2af"; };
      inode = { foreground = "#a6adc8"; };
      blocks = { foreground = "#6c7086"; };
      header = { foreground = "#cdd6f4"; };
      octal = { foreground = "#94e2d5"; };
      flags = { foreground = "#cba6f7"; };

      symlink_path = { foreground = "#89dceb"; };
      control_char = { foreground = "#74c7ec"; };
      broken_symlink = { foreground = "#f38ba8"; };
      broken_path_overlay = { foreground = "#585b70"; };
    };
  };

  # ==========================================================================
  # fzf — fuzzy finder for files, dirs, and history (Ctrl-T / Alt-C / Ctrl-R)
  # ==========================================================================

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;

    defaultCommand = "fd --type f --hidden --exclude .git";
    fileWidgetCommand = "fd --type f --hidden --exclude .git";
    changeDirWidgetCommand = "fd --type d --hidden --exclude .git";

    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
      "--info=inline"
    ];

    fileWidgetOptions = [
      "--preview 'bat --color=always --line-range=:200 {}'"
    ];

    changeDirWidgetOptions = [
      "--preview 'ls -la {}'"
    ];

    # Catppuccin Mocha colors
    colors = {
      "fg+" = "#cdd6f4";
      fg = "#cdd6f4";
      "hl+" = "#f38ba8";
      hl = "#f38ba8";
      "bg+" = "#313244";
      bg = "#1e1e2e";
      header = "#f38ba8";
      info = "#cba6f7";
      pointer = "#f5e0dc";
      marker = "#f5e0dc";
      prompt = "#cba6f7";
      spinner = "#f5e0dc";
    };
  };

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
      "exclusive": false,
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
        path = /home/akash/.config/themes/wallpaper
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

  home.file.".local/bin/powermenu".text = ''
    #!/usr/bin/env bash
    # Power menu via fuzzel: Lock / Reboot / Shutdown.
    choice=$(printf 'Lock\nReboot\nShutdown\n' | fuzzel --dmenu --prompt='Power: ')
    case "$choice" in
        Lock) hyprlock ;;
        Reboot) systemctl reboot ;;
        Shutdown) systemctl poweroff ;;
    esac
  '';

  home.file.".local/bin/powermenu".executable = true;

  home.file.".local/bin/keybinds".text = ''
    #!/usr/bin/env bash
    # Searchable keybind list: parse the niri config, group duplicate aliases
    # (e.g. Mod+Left / Mod+H) into one entry, and show the bound action.
    config="$HOME/.config/niri/config.kdl"

    list=$(awk '
      /^[ \t]+[A-Za-z0-9+_-]+( [^{}]*)?\{/ {
        line = $0
        gsub(/^[ \t]+/, "", line)
        if (line ~ /^\/\//) next
        key = line
        sub(/[ \t].*/, "", key)
        if (key !~ /^(Mod|Ctrl|Alt|Super|Shift|XF86)/) next

        title = ""
        if (match(line, /hotkey-overlay-title="[^"]*"/)) {
          title = substr(line, RSTART + 22, RLENGTH - 23)
        }

        rest = line
        sub(/^[^{]*\{[ \t]*/, "", rest)
        action = rest
        sub(/[ \t]*;[ \t]*}[ \t]*$/, "", action)
        gsub(/^[ \t]+|[ \t]+$/, "", action)

        keys[action] = keys[action] " " key
        if (title != "" && !(action in ttl)) ttl[action] = title
      }
      END {
        for (a in keys) {
          ks = keys[a]
          gsub(/^ /, "", ks)
          label = (a in ttl) ? ttl[a] : a
          detail = (a == label) ? "" : a
          printf "%s\t%s\t%s\n", ks, label, detail
        }
      }
    ' "$config" | sort -t$'\t' -k2 | while IFS=$'\t' read -r ks label detail; do
      if [ -n "$detail" ]; then
        printf "%-24s %s\n%26s %s\n" "$ks" "$label" "" "$detail"
      else
        printf "%-24s %s\n" "$ks" "$label"
      fi
    done)

    printf '%s\n' "$list" | fuzzel --dmenu --width=70 --lines=30 \
      --font='FiraCode Nerd Font:size=13' --prompt='Keybindings: ' >/dev/null
  '';

  home.file.".local/bin/keybinds".executable = true;

  home.file.".local/bin/theme-switch".text = ''
    #!/usr/bin/env bash
    # Switch the active runtime theme without a rebuild: flip the `current`
    # symlink, then live-reload every themeable desktop app.
    set -euo pipefail

    base="$HOME/.config/themes"
    name="$1"
    [ -n "$name" ] || { echo "usage: theme-switch <theme>" >&2; exit 1; }
    [ -d "$base/$name" ] || {
      echo "unknown theme: $name (available: $(cut -f1 "$base/list.tsv" | tr '\n' ' '))" >&2
      exit 1
    }

    ln -sfn "$base/$name" "$base/current"

    # --- niri: focus-ring / border colors + live reload ---
    niri_config="$HOME/.config/niri/config.kdl"
    if [ -f "$niri_config" ]; then
      active="$(sed -n 's/^[[:space:]]*active-color[[:space:]]*"\([^"]*\)".*/\1/p' "$base/$name/niri.snippet")"
      inactive="$(sed -n 's/^[[:space:]]*inactive-color[[:space:]]*"\([^"]*\)".*/\1/p' "$base/$name/niri.snippet")"
      if [ -n "$active" ]; then
        sed -i "s/^\([[:space:]]*active-color[[:space:]]*\)\"[^\"]*\"/\1\"$active\"/; s/^\([[:space:]]*inactive-color[[:space:]]*\)\"[^\"]*\"/\1\"$inactive\"/" "$niri_config"
        niri msg action load-config-file 2>/dev/null || true
      fi
    fi

    # --- kitty: theme.conf symlinks into `current`; SIGUSR1 reloads config ---
    kitty_theme="$HOME/.config/kitty/theme.conf"
    if [ -L "$kitty_theme" ] || [ ! -e "$kitty_theme" ]; then
      ln -sfn "$base/current/kitty.conf" "$kitty_theme"
    fi
    pkill -USR1 -x kitty 2>/dev/null || true

    # --- waybar ---
    systemctl --user restart waybar 2>/dev/null || true

    # --- fnott: no `include` support, write the full config then restart ---
    mkdir -p "$HOME/.config/fnott"
    rm -f "$HOME/.config/fnott/fnott.ini"
    cp "$base/$name/fnott.ini" "$HOME/.config/fnott/fnott.ini"
    systemctl --user restart fnott 2>/dev/null || true

    # --- yazi: local writable file ---
    mkdir -p "$HOME/.config/yazi"
    cp "$base/$name/yazi/theme.toml" "$HOME/.config/yazi/theme.toml"

    echo "theme -> $name"
    echo "fuzzel + neovim will use the new theme on next launch."
  '';

  home.file.".local/bin/theme-switch".executable = true;

  home.file.".local/bin/theme-pick".text = ''
    #!/usr/bin/env bash
    # Pick a theme via fuzzel and apply it.
    base="$HOME/.config/themes"
    choice=$(awk -F'\t' '{print $1"  —  "$2}' "$base/list.tsv" | \
      fuzzel --dmenu --prompt='Theme: ' --width=60 --lines=8 \
        --font='FiraCode Nerd Font:size=12')
    [ -n "$choice" ] || exit 0
    theme_name=$(printf '%s' "$choice" | awk '{print $1}')
    theme-switch "$theme_name"
  '';

  home.file.".local/bin/theme-pick".executable = true;

  home.file.".local/bin/wallpaper-pick".text = ''
    #!/usr/bin/env bash
    # Pick a wallpaper from ~/wallpapers; sweep it onto the display with
    # awww and point the hyprlock wallpaper symlink at the same image.
    dir="$HOME/wallpapers"
    [ -d "$dir" ] || { echo "no wallpaper dir: $dir" >&2; exit 1; }

    pics=$(find "$dir" -maxdepth 1 -type f \
      \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \
         -o -iname '*.webp' -o -iname '*.gif' -o -iname '*.bmp' \) \
      -printf '%f\t%p\n' | sort)

    choice=$(printf '%s\n' "$pics" | fuzzel --dmenu --prompt='Wallpaper: ' \
      --width=55 --lines=12 --font='FiraCode Nerd Font:size=12')
    [ -n "$choice" ] || exit 0

    path=$(printf '%s\n' "$choice" | awk -F'\t' '{print $2}')
    ln -sfn "$path" "$HOME/.config/themes/wallpaper"
    awww img "$path" 2>/dev/null || true
  '';

  home.file.".local/bin/wallpaper-pick".executable = true;

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
  # Fuzzel (launcher) — modern, centered, minimal
  #
  # True backdrop blur isn't supported by niri/fuzzel, so the surface uses a
  # semi-transparent background (1e1e2e @ 80%) to match kitty's
  # background_opacity 0.8 look. Centered, wide, sharp corners.
  # ==========================================================================

  xdg.configFile."fuzzel/fuzzel.ini".text = ''
    [main]
    # Colors/border come from the active runtime theme (~/.config/themes/current)
    include=~/.config/themes/current/fuzzel.ini
    font=FiraCode Nerd Font:size=12
    terminal=kitty
    icons-enabled=no
    layer=overlay
    lines=8
    width=38
    horizontal-pad=20
    vertical-pad=14
    inner-pad=18
    anchor=center
    y-margin=0
  '';

  # Power options appear in the fuzzel launcher alongside apps (Mod+Space).
  # Lock maps to hyprlock; Reboot/Shutdown go through systemd/logind.
  xdg.desktopEntries = {
    "Lock Screen" = {
      name = "Lock Screen";
      exec = "${pkgs.hyprlock}/bin/hyprlock";
      comment = "Lock the screen";
      categories = [ "Utility" ];
    };
    Reboot = {
      name = "Reboot";
      exec = "systemctl reboot";
      comment = "Restart the system";
      categories = [ "System" ];
    };
    Shutdown = {
      name = "Shutdown";
      exec = "systemctl poweroff";
      comment = "Power off the system";
      categories = [ "System" ];
    };
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
      @import url("/home/akash/.config/themes/current/waybar.css");

      * {
        font-family: "FiraCode Nerd Font", "JetBrainsMono Nerd Font", monospace;
        font-size: 13px;
        border: none;
        border-radius: 0;
        min-height: 0;
      }

      window#waybar {
        background-color: alpha(@bar_bg, 0.92);
        color: @text;
      }

      #workspaces button {
        padding: 0 6px;
        color: @dim;
      }
      #workspaces button.focused {
        background-color: alpha(@accent, 0.30);
        color: @accent;
      }
      #workspaces button.active {
        color: @accent;
      }
      #workspaces button.urgent {
        color: @red;
      }

      #network { color: @blue; }
      #bluetooth { color: @purple; }
      #clock { color: @text; }
      #battery { color: @green; }
      #battery.warning { color: @yellow; }
      #battery.critical { color: @red; }

      #network, #bluetooth, #battery, #clock {
        padding: 0 8px;
      }

      #network:hover, #bluetooth:hover, #battery:hover, #clock:hover,
      #workspaces button:hover {
        background-color: alpha(@accent, 0.25);
        color: @text;
      }

      tooltip {
        background-color: alpha(@tooltip_bg, 0.95);
        border: 1px solid @surface1;
        color: @text;
      }
    '';
  };
}
