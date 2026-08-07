# Deliberately host-local: this hardware/install contract may diverge independently.
{ lib, pkgs, ... }: {
  boot = { loader = { efi.canTouchEfiVariables = true; systemd-boot.enable = true; }; kernelPackages = pkgs.linuxPackages_latest; };
  hardware = { cpu.amd.updateMicrocode = lib.mkDefault true; enableRedistributableFirmware = true; };
  fileSystems = { "/" = { device = lib.mkDefault "/dev/nvme0n1p2"; fsType = lib.mkDefault "ext4"; }; "/boot" = { device = lib.mkDefault "/dev/nvme0n1p1"; fsType = lib.mkDefault "vfat"; options = [ "umask=0077" ]; }; };
  services.fstrim.enable = true;
  zramSwap.enable = true;
}
