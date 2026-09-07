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

## Boot Menu

`boot.loader.timeout = 0` hides the systemd-boot menu. To open it, **hold any
key** (e.g. Shift or arrow key) during the very early boot. From there you can
select a previous generation to roll back.

## Rollback

Find a previous generation:

```
nixos-rebuild list-generations
```

Switch back to it:

```
sudo nixos-rebuild switch --flake ~/nixos#nixos --rollback
```

or select it from the boot menu with a held key.

## Updating

```
nix flake update ~/nixos
sudo nixos-rebuild switch --flake ~/nixos#nixos
```

nixpkgs tracks `nixos-26.05` and Home Manager tracks `release-26.05`, so inputs
are kept in lock-step.

## Note on /etc/nixos

An older copy of this configuration still exists in `/etc/nixos` as its own git
repository. It is no longer used: the current system generation is built from
`~/nixos`. Once the `~/nixos` setup is confirmed working, `/etc/nixos` may
safely be removed or emptied, for example:

```
sudo mv /etc/nixos /etc/nixos.backup
```

Nothing here forces that; it is left untouched.