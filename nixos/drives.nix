{ pkgs, ... }: {
  # Kernel modules
  fileSystems."/mnt/gameslinux" = {
    device = "/dev/disk/by-label/gameslinux";
    fsType = "btrfs"; 
  };
  fileSystems."/mnt/M2" = {
    device = "/dev/disk/by-label/M2";
    fsType = "btrfs"; 
  };
}
