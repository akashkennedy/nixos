{ config, pkgs, lib, wlctl, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;

  # TUI for managing WiFi via NetworkManager (Impala fork), from the flake input.
  wlctl-pkg = wlctl.packages.${system}.default;

  # Battery charge threshold manager (Ooooze/batctl).
  # NOTE: nixpkgs' own `batctl` is the B.A.T.M.A.N. mesh tool; we need the
  # battery one, which ships as a release binary, so we fetch it directly.
  batctl = pkgs.runCommand "batctl-2026.3.13" {
    src = pkgs.fetchurl {
      url = "https://github.com/Ooooze/batctl/releases/download/v2026.3.13/batctl-2026.3.13-linux-x86_64.tar.gz";
      sha256 = "14pbp78yz41b0pffrvyxmr5hgr66hm20cngsq2s178kn3vnrd6xz";
    };
  } ''
    tar xzf $src
    mkdir -p $out/bin
    install -m755 batctl $out/bin/batctl
  '';

  # GUI calendar (t4t5/rencal), launched directly by waybar.
  rencal = pkgs.appimageTools.wrapType2 rec {
    pname = "rencal";
    version = "0.6.4";

    src = pkgs.fetchurl {
      url = "https://github.com/t4t5/rencal/releases/download/v${version}/renCal_${version}_amd64.AppImage";
      sha256 = "15i298n6yf22dvar6iari9fpmz47bmljswn4qlprw144fcr30mq8";
    };
  };

  # Clock TUI (race604/clock-tui), binary name `tclock`.
  clock-tui = pkgs.rustPlatform.buildRustPackage rec {
    pname = "clock-tui";
    version = "0.6.0";

    src = pkgs.fetchFromGitHub {
      owner = "race604";
      repo = "clock-tui";
      rev = "v${version}";
      sha256 = "1cp226cw8rqhvmqnrqif73rswyzrqpqn3ibxpyq1pj3p4hl73hi2";
    };

    cargoLock.lockFile = ./clock-tui/Cargo.lock;
  };
in
{
  environment.systemPackages = [
    wlctl-pkg
    batctl
    rencal
    clock-tui
  ];
}