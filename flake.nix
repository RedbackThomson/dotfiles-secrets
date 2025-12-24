{
  description = "Encrypted secrets for RedbackThomson's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    ragenix.url = "github:yaxitech/ragenix";
    ragenix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, ragenix }:
    let
      # Support multiple systems
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      # Development shell with ragenix CLI available
      devShells = forAllSystems (system: {
        default = nixpkgs.legacyPackages.${system}.mkShell {
          packages = [
            ragenix.packages.${system}.default
          ];

          shellHook = ''
            echo "Ragenix secrets management environment loaded"
            echo "Use 'ragenix' command to manage encrypted secrets"
          '';
        };
      });

      # Make ragenix available as a package
      packages = forAllSystems (system: {
        ragenix = ragenix.packages.${system}.default;
        default = ragenix.packages.${system}.default;
      });

      # NixOS module for consuming secrets
      nixosModules.default = { config, ... }: {
        imports = [ ragenix.nixosModules.default ];

        # Secrets will be decrypted to /run/agenix/
        # Configure individual secrets in your NixOS configuration
      };

      # Home Manager module for consuming secrets
      homeManagerModules.default = { config, ... }: {
        imports = [ ragenix.homeManagerModules.default ];

        # Secrets will be decrypted to /run/user/UID/agenix/
        # Configure individual secrets in your home-manager configuration
      };
    };
}
