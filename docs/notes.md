# Notes

Environment facts and maintainability notes for this configuration.

## Machine

- NixOS: 26.05 (Yarara), nixpkgs `nixos-26.05`
- Architecture: x86_64-linux
- Hostname: `nixos`
- User: `akash` (wheel + networkmanager)
- Boot: systemd-boot (menu hidden, hold a key during boot to show it)
- Display: Niri (Wayland) started by Ly
- Audio: PipeWire (Pulse + ALSA compat, 32-bit ALSA support)
- Bluetooth: enabled, powers on at boot (`bluetuith` for TUI control)

## OpenCode

OpenCode is installed manually at `~/.opencode/bin/opencode` and must not be
reinstalled through Nix. It is exposed on the user PATH via Home Manager:

```nix
home.sessionPath = [ "$HOME/.opencode/bin" ];
```

## Security

- Firewall: enabled (`networking.firewall.enable = true`)
- SSH server: enabled, root login disabled
- No secrets are stored in this repository.

## Directory conventions

- System-level packages: `modules/packages.nix`
- User-level packages/tools: `home.nix`
- Anything that genuinely needs system scope only belongs in system packages.
- `hardware-configuration.nix` is auto-generated and should not be edited.