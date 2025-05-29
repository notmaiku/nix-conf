{
  description = "gonutters flake file";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # hyprland
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    hyprland,
    ...
    } @ inputs: let
      inherit (self) outputs;
      pkgs = import nixpkgs {
        config.allowUnfree = true;	
      };
      lib = nixpkgs.lib;

    in {
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs outputs;};
          modules = [
            ./nixos/configuration.nix 
            ./nixos/yubikey.nix
            ./nixos/theme.nix
            ./nixos/fonts.nix
            ./nixos/location.nix
            ./nixos/fingerprint-scanner.nix
            ./firefox.nix
          ];
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        "gonah@nixos" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; 
          extraSpecialArgs = {inherit inputs outputs hyprland;};
          modules = [
            ./home-manager/home.nix
          ];
        };
      };
    };
}
