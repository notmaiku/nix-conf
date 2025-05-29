{ config, pkgs, ... }:

{
  # ... other configurations

  # Enable Wayland backend for Firefox for all users
  environment.variables.MOZ_ENABLE_WAYLAND = "1";

  # ... rest of your configuration.nix
}

