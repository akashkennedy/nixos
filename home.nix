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
}
