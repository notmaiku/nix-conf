{ config, pkgs, ... }: {
  home.file."testfile".text = "Hello from test!";
}

