# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
inputs,
lib,
config,
pkgs,
...
}: 

{

  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd
    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
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
    };
  };



  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    channel.enable = true;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Hostname
  networking.hostName = "nixos"; # Keep your hostname

  # Enable networking
  networking.networkmanager.enable = true;

  # Timezone and locale
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # X11 and KDE Plasma
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];
  # services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  # services.displayManager.sddm.defaultSession = "";
  # Enable the gnome-keyring secrets vault. 
  # Will be exposed through DBus to programs willing to store secrets.
  services.gnome.gnome-keyring.enable = true;

  # programs.sway = {
  #   enable = true;
  #   wrapperFeatures.gtk = true;
  # };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true; 
  };

  # OpenGL and Vulkan
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    amdgpu.amdvlk = {
      enable = true;
      support32Bit.enable = true;
    };
  };
  hardware.enableAllFirmware = true;

  # Keymap
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Printing
  services.printing.enable = true;

  # Sound with PipeWire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    # jack.enable = true; # Uncomment if you need JACK
  };


  # System-wide user configuration (only the essential parts)
  # We define the user here, but Home Manager will manage most of their configuration.
  users.users.gonah = {
    initialPassword = "tard";
    isNormalUser = true;
    description = "gonah";
    extraGroups = [ "networkmanager" "wheel" ]; # Keep essential groups here
    # Remove the 'packages' list - this will be handled by Home Manager
  };


  # System-wide packages (keep these if you want them available to all users)
  #apps
  environment.systemPackages = with pkgs; [
    kdePackages.discover # Optional: Install if you use Flatpak or fwupd firmware update sevice
    kdePackages.kcalc # Calculator
    kdePackages.kcharselect # Tool to select and copy special characters from all installed fonts
    kdePackages.kcolorchooser # A small utility to select a color
    kdePackages.kolourpaint # Easy-to-use paint program
    kdePackages.ksystemlog # KDE SystemLog Application
    kdePackages.sddm-kcm
    kdePackages.isoimagewriter
    kdePackages.dolphin
    kdiff3
    brave
    cava
    sdbus-cpp
    vulkan-tools
    glxinfo
    mesa
    pciutils
    libGL
    libglvnd
    libdrm
    libpulseaudio
    gnumake
    git
    gcc
    unzip
    wget
    kdiff3
    hardinfo2
    haruna
    wayland-utils
    wl-clipboard
    protonup-qt
    protonplus
    heroic
    godot
    bitwarden
    ninja
    mpv
    python3Packages.websockets
    pkgs.qt5.full
    pkgs.qt6.full
    vulkan-headers
    cmake
    foot
    kitty
    wofi
    waybar
    hyprpaper
    discord
    grim 
    chromium
    slurp
    mako 
    ghostty
    brave
    firefox
    fnott
    lf
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    pipewire
    wireplumber
    dunst
    hyprpolkitagent
    mangohud
    rofi
  ];


  services.udisks2.enable = true;
  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
  services.flatpak.enable = true;


  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  # Allow insecure packages if needed
  nixpkgs.config.permittedInsecurePackages = [
    "electron-33.4.11"
  ];

  # Kernel modules
  boot.kernelModules = [ "amdgpu" ];
  fileSystems."/mnt/gameslinux" = {
    device = "/dev/disk/by-label/gameslinux";

    fsType = "btrfs"; 


  };

  # State version for NixOS
  system.stateVersion = "25.05";
}
