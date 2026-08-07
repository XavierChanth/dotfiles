{ lib, pkgs, ... }: {
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 3389 ];
  users.users.computer = { isNormalUser = true; description = "Computer Use"; extraGroups = [ "networkmanager" ]; };
  programs = { dconf = { enable = true; profiles.user.databases = [{ settings."org/gnome/settings-daemon/plugins/power" = { sleep-inactive-ac-type = "nothing"; sleep-inactive-battery-type = "nothing"; sleep-inactive-ac-timeout = lib.gvariant.mkInt32 0; sleep-inactive-battery-timeout = lib.gvariant.mkInt32 0; }; locks = [ "/org/gnome/settings-daemon/plugins/power/sleep-inactive-ac-type" "/org/gnome/settings-daemon/plugins/power/sleep-inactive-battery-type" "/org/gnome/settings-daemon/plugins/power/sleep-inactive-ac-timeout" "/org/gnome/settings-daemon/plugins/power/sleep-inactive-battery-timeout" ]; }]; }; firefox.enable = true; };
  services = { desktopManager.gnome.enable = true; displayManager.gdm = { enable = true; autoSuspend = false; }; gnome.gnome-remote-desktop.enable = true; xserver = { enable = true; xkb.layout = "us"; }; };
  environment.systemPackages = [ pkgs.gnome-terminal ];
}
