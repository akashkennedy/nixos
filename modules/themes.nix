{ config, lib, ... }:

# Runtime theme catalog.
#
# Each theme is generated into ~/.config/themes/<name>/ as self-contained
# snippets that desktop programs read. A `current` symlink (flipped at runtime
# by `theme-switch`) selects the active theme, so switching needs no rebuild.
#
# Applied live:  niri (focus-ring/border), kitty, waybar, fnott
# Applied next launch:  fuzzel, yazi, neovim, hyprlock (wallpaper)

let
  mkTheme = t: {
    inherit (t) desc nvim;

    bg = t.bg;
    mantle = t.mantle;
    crust = t.crust;
    surface0 = t.surface0;
    surface1 = t.surface1;
    surface2 = t.surface2;
    overlay0 = t.overlay0;
    overlay1 = t.overlay1;
    overlay2 = t.overlay2;
    subtext0 = t.subtext0;
    subtext1 = t.subtext1;
    fg = t.fg;
    accent = t.accent;
    accent2 = t.accent2;
    red = t.red;
    green = t.green;
    yellow = t.yellow;
    peach = t.peach;
    teal = t.teal;
    sky = t.sky;
    pink = t.pink;
    blue = t.accent;
    lavender = t.lavender;
    sapphire = t.sapphire;
    maroon = t.maroon;
    flamingo = t.flamingo;
    rosewater = t.rosewater;
    term = t.term;
  };

  mocha = mkTheme rec {
    desc = "Catppuccin Mocha — soft pastel dark (default)";
    nvim = "mocha";

    bg = "1e1e2e"; mantle = "181825"; crust = "11111b";
    surface0 = "313244"; surface1 = "45475a"; surface2 = "585b70";
    overlay0 = "6c7086"; overlay1 = "7f849c"; overlay2 = "9399b2";
    subtext0 = "a6adc8"; subtext1 = "bac2de"; fg = "cdd6f4";
    accent = "89b4fa"; accent2 = "cba6f7";
    lavender = "b4befe"; sapphire = "74c7ec"; sky = "89dceb"; teal = "94e2d5";
    green = "a6e3a1"; yellow = "f9e2af"; peach = "fab387"; maroon = "eba0ac";
    red = "f38ba8"; pink = "f5c2e7"; flamingo = "f2cdcd"; rosewater = "f5e0dc";

    term = [
      "45475a" "f38ba8" "a6e3a1" "f9e2af"
      "89b4fa" "f5c2e7" "94e2d5" "bac2de"
      "585b70" "f38ba8" "a6e3a1" "f9e2af"
      "89b4fa" "f5c2e7" "94e2d5" "a6adc8"
    ];
  };

  frappe = mkTheme rec {
    desc = "Catppuccin Frappe — cool grey pastel";
    nvim = "frappe";

    bg = "303446"; mantle = "292c3c"; crust = "232634";
    surface0 = "414559"; surface1 = "51576d"; surface2 = "626880";
    overlay0 = "737994"; overlay1 = "838ba7"; overlay2 = "949cbb";
    subtext0 = "a5adce"; subtext1 = "b5bfe2"; fg = "c6d0f5";
    accent = "8caaee"; accent2 = "ca9ee6";
    lavender = "babbf1"; sapphire = "85c1dc"; sky = "99d1db"; teal = "81c8be";
    green = "a6d189"; yellow = "e5c890"; peach = "ef9f76"; maroon = "ea999c";
    red = "e78284"; pink = "f4b8e4"; flamingo = "eebebe"; rosewater = "f2d5cf";

    term = [
      "51576d" "e78284" "a6d189" "e5c890"
      "8caaee" "f4b8e4" "81c8be" "b5bfe2"
      "737994" "e78284" "a6d189" "e5c890"
      "8caaee" "f4b8e4" "81c8be" "a5adce"
    ];
  };

  gruvbox = mkTheme rec {
    desc = "Gruvbox — warm retro dark";
    nvim = "gruvbox";

    bg = "282828"; mantle = "1d2021"; crust = "1d2021";
    surface0 = "3c3836"; surface1 = "504945"; surface2 = "665c54";
    overlay0 = "928374"; overlay1 = "a89984"; overlay2 = "bdae93";
    subtext0 = "d5c4a1"; subtext1 = "d5c4a1"; fg = "ebdbb2";
    accent = "83a598"; accent2 = "d3869b";
    lavender = "83a598"; sapphire = "458588"; sky = "8ec07c"; teal = "8ec07c";
    green = "b8bb26"; yellow = "fabd2f"; peach = "fe8019"; maroon = "cc241d";
    red = "fb4934"; pink = "d3869b"; flamingo = "ebdbb2"; rosewater = "fbf1c7";

    term = [
      "282828" "cc241d" "98971a" "d79921"
      "458588" "b16286" "689d6a" "a89984"
      "928374" "fb4934" "b8bb26" "fabd2f"
      "83a598" "d3869b" "8ec07c" "ebdbb2"
    ];
  };

  nord = mkTheme rec {
    desc = "Nord — arctic frost blue";
    nvim = "nord";

    bg = "2e3440"; mantle = "2e3440"; crust = "2e3440";
    surface0 = "3b4252"; surface1 = "434c5e"; surface2 = "4c566a";
    overlay0 = "4c566a"; overlay1 = "616e88"; overlay2 = "81a1c1";
    subtext0 = "d8dee9"; subtext1 = "e5e9f0"; fg = "e5e9f0";
    accent = "88c0d0"; accent2 = "b48ead";
    lavender = "81a1c1"; sapphire = "5e81ac"; sky = "88c0d0"; teal = "8fbcbb";
    green = "a3be8c"; yellow = "ebcb8b"; peach = "d08770"; maroon = "d08770";
    red = "bf616a"; pink = "b48ead"; flamingo = "e5e9f0"; rosewater = "e5e9f0";

    term = [
      "3b4252" "bf616a" "a3be8c" "ebcb8b"
      "81a1c1" "b48ead" "88c0d0" "e5e9f0"
      "4c566a" "bf616a" "a3be8c" "ebcb8b"
      "81a1c1" "b48ead" "8fbcbb" "eceff4"
    ];
  };

  themes = { inherit mocha frappe gruvbox nord; };

  h = { hex = t: "#${t}"; };

  mkFuzzel = t: ''
    [colors]
    background=${t.bg}CC
    text=${t.fg}
    prompt=${t.accent}
    placeholder=${t.overlay0}
    input=${t.fg}
    selection=${t.surface0}
    selection-text=${t.fg}
    match=${t.yellow}
    selection-match=${t.yellow}
    border=${t.accent}
  '';

  mkKitty = t: let
    c = t.term;
    at = i: lib.elemAt c i;
  in ''
    # ${t.desc}
    background ${h.hex t.bg}
    foreground ${h.hex t.fg}

    selection_foreground   ${h.hex t.bg}
    selection_background   ${h.hex t.surface2}
    cursor                 ${h.hex t.rosewater}
    cursor_text_color      ${h.hex t.bg}
    url_color              ${h.hex t.accent2}

    active_border_color    ${h.hex t.accent}
    inactive_border_color  ${h.hex t.surface1}
    bell_border_color      ${h.hex t.yellow}

    active_tab_foreground   ${h.hex t.bg}
    active_tab_background   ${h.hex t.accent2}
    inactive_tab_foreground ${h.hex t.fg}
    inactive_tab_background ${h.hex t.surface0}
    tab_bar_background      ${h.hex t.crust}

    mark1_foreground ${h.hex t.bg}
    mark1_background ${h.hex t.accent}
    mark2_foreground ${h.hex t.bg}
    mark2_background ${h.hex t.accent2}
    mark3_foreground ${h.hex t.bg}
    mark3_background ${h.hex t.sky}

    color0 ${h.hex (at 0)}
    color1 ${h.hex (at 1)}
    color2 ${h.hex (at 2)}
    color3 ${h.hex (at 3)}
    color4 ${h.hex (at 4)}
    color5 ${h.hex (at 5)}
    color6 ${h.hex (at 6)}
    color7 ${h.hex (at 7)}
    color8 ${h.hex (at 8)}
    color9 ${h.hex (at 9)}
    color10 ${h.hex (at 10)}
    color11 ${h.hex (at 11)}
    color12 ${h.hex (at 12)}
    color13 ${h.hex (at 13)}
    color14 ${h.hex (at 14)}
    color15 ${h.hex (at 15)}
  '';

  mkWaybar = t: ''
    @define-color bar_bg #${t.bg};
    @define-color text   #${t.fg};
    @define-color dim    #${t.subtext0};
    @define-color accent #${t.accent};
    @define-color accent2 #${t.accent2};
    @define-color red    #${t.red};
    @define-color green  #${t.green};
    @define-color yellow #${t.yellow};
    @define-color blue   #${t.accent};
    @define-color purple #${t.accent2};
    @define-color surface1 #${t.surface1};
    @define-color tooltip_bg #${t.crust};
  '';

  mkFnott = t: ''
    [main]
    anchor=top-right
    edge-margin-horizontal=20
    edge-margin-vertical=36
    notification-margin=6

    layer=overlay
    max-width=340
    max-icon-size=40
    icon-theme=Papirus-Dark

    default-timeout=8

    title-font=FiraCode Nerd Font
    summary-font=FiraCode Nerd Font
    body-font=FiraCode Nerd Font

    background=${t.bg}
    border-size=2
    border-color=${t.surface1}
    border-radius=0
    padding-vertical=12
    padding-horizontal=12

    title-color=${t.subtext0}
    summary-color=${t.fg}
    body-color=${t.fg}

    progress-bar-height=4
    progress-color=${t.surface2}
    progress-style=bar

    selection-helper=fuzzel --dmenu0
    selection-helper-uses-null-separator=yes

    [low]
    title-color=${t.subtext0}
    summary-color=${t.overlay1}
    body-color=${t.overlay0}
    border-color=${t.surface1}
    background=${t.bg}

    [normal]
    border-color=${t.accent}
    background=${t.bg}
    title-color=${t.subtext0}
    summary-color=${t.fg}
    body-color=${t.fg}

    [critical]
    background=${t.bg}
    border-color=${t.peach}
    title-color=${t.subtext0}
    summary-color=${t.fg}
    body-color=${t.fg}
  '';

  mkNiri = t: ''
    active-color "#${t.accent}"
    inactive-color "#${t.overlay0}"
  '';

  mkNeovim = t:
    if t.nvim == "mocha" || t.nvim == "frappe"
    then ''
      vim.g.catppuccin_flavour = "${t.nvim}"
      require("catppuccin").setup({})
      vim.cmd("colorscheme catppuccin")
    ''
    else ''
      vim.cmd("colorscheme ${t.nvim}")
    '';

  # Yazi theme — same schema as yazi's default theme.toml, colors injected.
  mkYazi = t: let
    ph = {
      "@bg@" = t.bg; "@fg@" = t.fg; "@mantle@" = t.mantle; "@crust@" = t.crust;
      "@surface0@" = t.surface0; "@surface1@" = t.surface1; "@surface2@" = t.surface2;
      "@overlay0@" = t.overlay0; "@overlay1@" = t.overlay1; "@overlay2@" = t.overlay2;
      "@accent@" = t.accent; "@accent2@" = t.accent2;
      "@red@" = t.red; "@green@" = t.green; "@yellow@" = t.yellow;
      "@peach@" = t.peach; "@teal@" = t.teal; "@sky@" = t.sky;
      "@pink@" = t.pink; "@flamingo@" = t.flamingo;
    };
  in lib.replaceStrings (lib.attrNames ph) (lib.attrValues ph) ''
    [app]
    overall = { bg = "#@bg@" }

    [mgr]
    cwd = { fg = "#@teal@" }

    find_keyword  = { fg = "#@yellow@", italic = true }
    find_position = { fg = "#@pink@", bg = "reset", italic = true }

    marker_copied   = { fg = "#@green@", bg = "#@green@" }
    marker_cut      = { fg = "#@red@", bg = "#@red@" }
    marker_marked   = { fg = "#@teal@", bg = "#@teal@" }
    marker_selected = { fg = "#@accent@", bg = "#@accent@" }

    count_copied   = { fg = "#@bg@", bg = "#@green@" }
    count_cut      = { fg = "#@bg@", bg = "#@red@" }
    count_selected = { fg = "#@bg@", bg = "#@accent@" }

    border_symbol = "│"
    border_style  = { fg = "#@overlay1@" }

    [tabs]
    active   = { fg = "#@bg@", bg = "#@fg@", bold = true }
    inactive = { fg = "#@fg@", bg = "#@surface1@" }

    [mode]
    normal_main = { fg = "#@bg@", bg = "#@accent@", bold = true }
    normal_alt  = { fg = "#@accent@", bg = "#@surface0@" }
    select_main = { fg = "#@bg@", bg = "#@green@", bold = true }
    select_alt  = { fg = "#@green@", bg = "#@surface0@" }
    unset_main  = { fg = "#@bg@", bg = "#@flamingo@", bold = true }
    unset_alt   = { fg = "#@flamingo@", bg = "#@surface0@" }

    [indicator]
    parent  = { fg = "#@bg@", bg = "#@fg@" }
    current = { fg = "#@bg@", bg = "#@accent@" }
    preview = { fg = "#@bg@", bg = "#@fg@" }

    [status]
    sep_left  = { open = " ", close = " " }
    sep_right = { open = " ", close = " " }

    progress_label  = { fg = "#ffffff", bold = true }
    progress_normal = { fg = "#@green@", bg = "#@surface1@" }
    progress_error  = { fg = "#@yellow@", bg = "#@red@" }

    perm_type  = { fg = "#@accent@" }
    perm_read  = { fg = "#@yellow@" }
    perm_write = { fg = "#@red@" }
    perm_exec  = { fg = "#@green@" }
    perm_sep   = { fg = "#@overlay1@" }

    [input]
    border   = { fg = "#@accent@" }
    title    = {}
    value    = {}
    selected = { reversed = true }

    [pick]
    border   = { fg = "#@accent@" }
    active   = { fg = "#@pink@" }
    inactive = {}

    [confirm]
    border  = { fg = "#@accent@" }
    title   = { fg = "#@accent@" }
    body    = {}
    list    = {}
    btn_yes = { reversed = true }
    btn_no  = {}

    [cmp]
    border = { fg = "#@accent@" }

    [tasks]
    border  = { fg = "#@accent@" }
    title   = {}
    hovered = { fg = "#@pink@", bold = true }

    [which]
    border          = { fg = "#@accent@" }
    mask            = {}
    cand            = { fg = "#@teal@" }
    rest            = { fg = "#@overlay2@" }
    desc            = { fg = "#@pink@" }
    separator       = "  "
    separator_style = { fg = "#@surface2@" }

    [help]
    border  = { fg = "#@accent@" }
    chord   = { fg = "#@teal@" }
    action  = { fg = "#@overlay2@" }
    hovered = { bg = "#@surface2@", bold = true }

    [notify]
    title_info  = { fg = "#@teal@" }
    title_warn  = { fg = "#@yellow@" }
    title_error = { fg = "#@red@" }

    [filetype]
    rules = [
      { mime = "**/image/*", fg = "#@yellow@" },
      { mime = "**/{audio,video}/*", fg = "#@pink@" },
      { mime = "**/application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}", fg = "#@red@" },
      { mime = "**/application/{pdf,doc,rtf}", fg = "#@sky@" },
      { url = "*", is = "orphan", bg = "#@red@" },
      { url = "*", is = "exec"  , fg = "#@green@" },
      { url = "*/", fg = "#@accent@" },
    ]
  '';

  mkThemeSh = name: t: ''
    THEME=${name}
    THEME_DIR=${config.home.homeDirectory}/.config/themes/${name}
    ACCENT=${t.accent}
    BG=${t.bg}
    FG=${t.fg}
  '';

  # Build the per-theme file set for one theme.
  filesFor = name: t: {
    ".config/themes/${name}/fuzzel.ini".text = mkFuzzel t;
    ".config/themes/${name}/kitty.conf".text = mkKitty t;
    ".config/themes/${name}/waybar.css".text = mkWaybar t;
    ".config/themes/${name}/fnott.ini".text = mkFnott t;
    ".config/themes/${name}/niri.snippet".text = mkNiri t;
    ".config/themes/${name}/neovim.lua".text = mkNeovim t;
    ".config/themes/${name}/yazi/theme.toml".text = mkYazi t;
    ".config/themes/${name}/theme.sh".text = mkThemeSh name t;
  };

  allFiles = lib.foldl (acc: name: acc // filesFor name themes.${name}) { } (lib.attrNames themes);

  listTsv = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (name: t: "${name}\t${t.desc}") themes
  ) + "\n";
in {
  home.file = allFiles // {
    ".config/themes/list.tsv".text = listTsv;
    # Default active theme; flipped at runtime by theme-switch.
    ".config/themes/current".source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/.config/themes/mocha";
  };
}