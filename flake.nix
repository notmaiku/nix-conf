{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
    } @ inputs: let
      inherit (self) outputs;
      customPkgs = prev: {
        # Define your custom package here.
        # Use callPackage to load the derivation from its file.
        # The path is relative to the flake.nix file.
        wallpaperEngineKde = prev.callPackage ./nixos/wallpaper-engine-plasma-plugin.nix {
          # Pass necessary dependencies.
          # Use 'prev' to access packages from the previous pkgs set.
          inherit (prev)
          stdenv fetchFromGitHub cmake pkg-config wrapQtAppsHook
          mpv lz4 vulkan-headers vulkan-tools vulkan-loader
          spirv-tools wayland wayland-protocols libass
          libsysprof-capture fribidi shaderc ninja python3;

          inherit (prev.gst_all_1) gst-libav;
          inherit (prev.python3Packages) websockets;

          # Access packages from specific sets within pkgs
          inherit (prev.kdePackages) extra-cmake-modules kpackage kdeclarative libplasma;
          inherit (prev.qt6Packages) qtbase full qtwebsockets qtwebengine qtwebchannel qtmultimedia qtdeclarative;
        };

        # You can add other custom packages here if you have them
        # myOtherCustomTool = prev.callPackage ./path/to/my-other-tool.nix {};
      };
    in {
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        # FIXME replace with your hostname
        nixos = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs outputs;};
          # > Our main nixos configuration file <
          modules = [./nixos/configuration.nix 
          ];
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        # FIXME replace with your username@hostname
        "gonah@nixos" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {inherit inputs outputs;};
          # > Our main home-manager configuration file <
          modules = [./home-manager/home.nix];
        };
      };
    };
}
