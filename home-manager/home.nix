# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
inputs,
lib,
config,
pkgs,
...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "gonah";
    homeDirectory = "/home/gonah";
  };

  programs.git = {
    enable = true;
    userName = "maiku";
    userEmail = "mike1davis@rocketmail.com";
    
    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "vim";
      core.autocrlf = "input";
      push.default = "simple";
      pull.rebase = true;
    };

    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      ci = "commit";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
      visual = "!gitk";
    };

    # Git ignore patterns
    ignores = [
      ".DS_Store"
      "*.log"
      "node_modules/"
      ".env"
    ];
  };

  home.packages = with pkgs; [
    # Packages from your original users.users.gonah.packages list
    vscode
    discord
    brave
    xclip
    mangohud
    protonup-qt
    lutris
    bottles
    heroic
    firefox
    neovim
    lazygit
    steam
    unzip
    nodejs
    typescript
    python
    gcc
    gnumake
    cmake
    ninja
    go 
    qt6.full
    kdePackages.extra-cmake-modules
    pkg-config
    shaderc
    kdePackages.kpackage
    ripgrep
  ];
  nixpkgs.config.permittedInsecurePackages = [
    "electron-33.4.11"
    "python-2.7.18.8"
  ];
  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.ghostty.enable = true;
  programs.bash.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
