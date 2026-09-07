# NixOS Configuration

Akash's NixOS setup using flakes, Home Manager (as a NixOS module), the Niri
Wayland compositor, and the Ly display manager.

The canonical configuration lives in `~/nixos`. The system is built with:

```
sudo nixos-rebuild switch --flake ~/nixos#nixos
```

## Layout

```
flake.nix                  Flake entry point (nixpkgs + Home Manager inputs)
configuration.nix          System-level configuration (NixOS module)
home.nix                   Home Manager user configuration
hardware-configuration.nix Auto-generated; do not edit
modules/
  niri.nix                 Niri compositor + Ly display manager
  audio.nix                PipeWire
  packages.nix             System-level packages
scripts/
  rebuild                  flake check -> nixos-rebuild switch
  test                     nixos-rebuild test
  build                    nixos-rebuild build
  check                    nix flake check
  update                   nix flake update
  battery-tui              Battery status + power-profile TUI (clicked from Waybar)
docs/                      Additional notes
```

## Commands

| Command  | What it does                                          |
|----------|-------------------------------------------------------|
| `nixos`  | `cd ~/nixos`                                          |
| `rebuild`| Validate flake, then switch to the new generation      |
| `test`   | Apply without switching (for testing)                 |
| `build`  | Build without applying                                |
| `check`  | `nix flake check`                                     |
| `update` | Update `flake.lock`                                   |
| `status` | `git status` for the repo                             |
| `diff`   | `git diff` for the repo                               |
| `log`    | `git log --oneline` for the repo                      |
| `nixdoc` | View this README                                      |

All aliases live in `home.nix` and shell script equivalents in `scripts/`.

## Waybar

Declared in `home.nix` under `programs.waybar` (config + `style.css`). Layout:

- left: empty, center: clock, right: `niri/workspaces` → wifi → bluetooth →
  battery (battery at the far right end)

Clicking a module opens a TUI in a kitty window:

| Module  | Click opens                  |
|---------|------------------------------|
| WiFi    | `nmtui`                      |
| Bluetooth | `bluetuith`                |
| Battery | `battery-tui` (status + power profile switching) |
| Clock   | `calcurse` (calendar)        |

The TUIs open as **floating popups pinned right below the bar** (not tiled
windows). This is done with `window-rule`s in `~/.config/niri/config.kdl`
(`open-floating` + `default-floating-position`): WiFi/Bluetooth/Battery tuck
under the right modules, the calendar centers under the clock. Each kitty
window is spawned with `--class waybar-tui` and a `--title`/`--geometry` so
niri can match and size it. Note that niri reads its config only at startup,
so after changing these rules you must log out and back in for them to apply.

`programs.niri` (in `modules/niri.nix`) spawns waybar at login
(`spawn-at-startup "waybar"` in `~/.config/niri/config.kdl`). The niri IPC
socket is exposed to waybar via `NIRI_SOCKET`, which niri sets for session
processes — do not launch waybar outside the session or workspaces will not
render.

`battery-tui` is installed from `scripts/battery-tui` and uses
`power-profiles-daemon` (`services.power-profiles-daemon.enable`, see
`configuration.nix`) for power mode switching and `upower` for battery detail.

## Note on /etc/nixos

An older copy of this configuration still exists in `/etc/nixos` as its own git
repository. It is no longer used: the current system generation is built from
`~/nixos`. Once the `~/nixos` setup is confirmed working, `/etc/nixos` may
safely be removed or emptied, for example:

```
sudo mv /etc/nixos /etc/nixos.backup
```

Nothing here forces that; it is left untouched.