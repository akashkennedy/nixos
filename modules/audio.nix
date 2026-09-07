{ config, pkgs, lib, ... }:

# PipeWire is the recommended audio stack for modern Linux desktops.
# ALSA and PulseAudio compatibility layers are enabled so legacy
# applications keep working.

{
  services.pipewire = {
    enable = true;

    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };
}