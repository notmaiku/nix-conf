# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
self,
inputs,
lib,
config,
pkgs,
...
}: {
  # You can import other home-manager modules here
  imports = [ 
    # ./desktop
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

    programs.rofi = {
    enable = true;
    theme = "Arc-Dark";
  };


  programs.git = {
    enable = true;
    userName = "maiku";
    userEmail = "mike1davis@rocketmail.com";

    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "neovim";
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
    cava
    neovim
    lazygit
    unzip
    nodejs
    typescript
    python
    gcc
    gnumake
    cmake
    ninja
    go 
    lua
    pkg-config
    shaderc
    ripgrep
    rofi
    pamixer
    mpc-cli
    tty-clock
    btop
    tokyo-night-gtk
  ];
  nixpkgs.config.permittedInsecurePackages = [
    "python-2.7.18.8"
  ];



   programs.waybar = {
     enable = true;
     systemd = {
       enable = false;
       target = "graphical-session.target";
     };
     style = ''
                * {
                  font-family: "JetBrainsMono Nerd Font";
                  font-size: 12pt;
                  font-weight: bold;
                  border-radius: 8px;
                  transition-property: background-color;
                  transition-duration: 0.5s;
                }
                @keyframes blink_red {
                  to {
                    background-color: rgb(242, 143, 173);
                    color: rgb(26, 24, 38);
                  }
                }
                .warning, .critical, .urgent {
                  animation-name: blink_red;
                  animation-duration: 1s;
                  animation-timing-function: linear;
                  animation-iteration-count: infinite;
                  animation-direction: alternate;
                }
                window#waybar {
                  background-color: transparent;
                }
                window > box {
                  margin-left: 5px;
                  margin-right: 5px;
                  margin-top: 5px;
                  background-color: #1e1e2a;
                  padding: 3px;
                  padding-left:8px;
                  border: 2px none #33ccff;
                }
          #workspaces {
                  padding-left: 0px;
                  padding-right: 4px;
                }
          #workspaces button {
                  padding-top: 5px;
                  padding-bottom: 5px;
                  padding-left: 6px;
                  padding-right: 6px;
                }
          #workspaces button.active {
                  background-color: rgb(181, 232, 224);
                  color: rgb(26, 24, 38);
                }
          #workspaces button.urgent {
                  color: rgb(26, 24, 38);
                }
          #workspaces button:hover {
                  background-color: rgb(248, 189, 150);
                  color: rgb(26, 24, 38);
                }
                tooltip {
                  background: rgb(48, 45, 65);
                }
                tooltip label {
                  color: rgb(217, 224, 238);
                }
          #custom-launcher {
                  font-size: 20px;
                  padding-left: 8px;
                  padding-right: 6px;
                  color: #7ebae4;
                }
          #mode, #clock, #memory, #temperature,#cpu,#mpd, #custom-wall, #temperature, #pulseaudio, #network, #battery, #custom-powermenu, #custom-cava-internal {
                  padding-left: 10px;
                  padding-right: 10px;
                }
                /* #mode { */
                /* 	margin-left: 10px; */
                /* 	background-color: rgb(248, 189, 150); */
                /*     color: rgb(26, 24, 38); */
                /* } */
          #memory {
                  color: rgb(181, 232, 224);
                }
          #cpu {
                  color: rgb(245, 194, 231);
                }
          #clock {
                  color: rgb(217, 224, 238);
                }
         /* #idle_inhibitor {
                  color: rgb(221, 182, 242);
                }*/
          #custom-wall {
                  color: #33ccff;
             }
          #temperature {
                  color: rgb(150, 205, 251);
                }
          #pulseaudio {
                  color: rgb(245, 224, 220);
                }
          #network {
                  color: #ABE9B3;
                }
          #network.disconnected {
                  color: rgb(255, 255, 255);
                }
          #custom-powermenu {
                  color: rgb(242, 143, 173);
                  padding-right: 8px;
                }
          #tray {
                  padding-right: 8px;
                  padding-left: 10px;
                }
          #mpd.paused {
                  color: #414868;
                  font-style: italic;
                }
          #mpd.stopped {
                  background: transparent;
                }
          #mpd {
                  color: #c0caf5;
                }
          #custom-cava-internal{
                  font-family: "Hack Nerd Font" ;
                  color: #33ccff;
                }
     '';
     settings = [{
       "output" = "HDMI-A-5";
       "layer" = "top";
       "position" = "top";
       modules-left = [
         "custom/launcher"
         "temperature"
         "mpd"
         "custom/cava-internal"
       ];
       modules-center = [
         "clock"
       ];
       modules-right = [
         "pulseaudio"
         "memory"
         "cpu"
         "network"
         "custom/powermenu"
         "tray"
       ];
       "custom/launcher" = {
         "format" = " ";
         "on-click" = "pkill rofi || rofi2";
         "on-click-middle" = "exec default_wall";
         "on-click-right" = "exec wallpaper_random";
         "tooltip" = false;
       };
       "custom/cava-internal" = {
         "exec" = "sleep 1s && cava";
         "tooltip" = false;
       };
       "pulseaudio" = {
         "scroll-step" = 1;
         "format" = "{icon} {volume}%";
         "format-muted" = "󰖁 Muted";
         "format-icons" = {
           "default" = [ "" "" "" ];
         };
         "on-click" = "pamixer -t";
         "tooltip" = false;
       };
       "clock" = {
         "interval" = 1;
         "format" = "{:%I:%M %p  %A %b %d}";
         "tooltip" = true;
         "tooltip-format"= "{:%A, %B %d, %Y}\n<tt>{calendar}</tt>";

       };
       "memory" = {
         "interval" = 1;
         "format" = "󰻠 {percentage}%";
         "states" = {
           "warning" = 85;
         };
       };
       "cpu" = {
         "interval" = 1;
         "format" = "󰍛 {usage}%";
       };
       "mpd" = {
         "max-length" = 25;
         "format" = "<span foreground='#bb9af7'></span> {title}";
         "format-paused" = " {title}";
         "format-stopped" = "<span foreground='#bb9af7'></span>";
         "format-disconnected" = "";
         "on-click" = "mpc --quiet toggle";
         "on-click-right" = "mpc update; mpc ls | mpc add";
         "on-click-middle" = "kitty --class='ncmpcpp' ncmpcpp ";
         "on-scroll-up" = "mpc --quiet prev";
         "on-scroll-down" = "mpc --quiet next";
         "smooth-scrolling-threshold" = 5;
         "tooltip-format" = "{title} - {artist} ({elapsedTime:%M:%S}/{totalTime:%H:%M:%S})";
       };
       "network" = {
         "format-disconnected" = "󰯡 Disconnected";
         "format-ethernet" = "󰒢 Connected!";
         "format-linked" = "󰖪 {essid} (No IP)";
         "format-wifi" = "󰖩 {essid}";
         "interval" = 1;
         "tooltip" = false;
       };
       "custom/powermenu" = {
         "format" = "";
         "on-click" = "pkill rofi || ~/.config/rofi/powermenu/type-3/powermenu.sh";
         "tooltip" = false;
       };
       "tray" = {
         "icon-size" = 15;
         "spacing" = 5;
       };
     }];
   };


  # Enable home-manager and git
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
