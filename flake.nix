{
  description = "Akash's NixOS configuration";

  inputs = {
    # Stable NixOS release
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # Matching Home Manager release
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";

      # Use the same nixpkgs as NixOS.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = {
          inherit inputs;
        };

        modules = [
          ./configuration.nix

          home-manager.nixosModules.default

          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;

              # Allows home.nix to access flake inputs if needed.
              extraSpecialArgs = {
                inherit inputs;
              };

              users.akash = import ./home.nix;
            };
          }
        ];
      };
    };
}

