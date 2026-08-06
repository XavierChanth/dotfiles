{
  hostname,
  lib,
  pkgs,
  username,
  ...
}: {
  imports = [
    ./harmonia-peer-cache.nix
  ];

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault true;
    enableRedistributableFirmware = true;
  };

  # Installation contract. A future hardware or Disko module can override
  # these defaults without changing the shared machine configuration.
  fileSystems = {
    "/" = {
      device = lib.mkDefault "/dev/nvme0n1p2";
      fsType = lib.mkDefault "ext4";
    };
    "/boot" = {
      device = lib.mkDefault "/dev/nvme0n1p1";
      fsType = lib.mkDefault "vfat";
      options = ["umask=0077"];
    };
  };

  networking = {
    hostName = hostname;
    networkmanager.enable = true;
    firewall = {
      enable = true;
      interfaces.tailscale0.allowedTCPPorts = [3389];
    };
  };

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
  nixpkgs.config.allowUnfree = true;

  users = {
    defaultUserShell = pkgs.zsh;
    users = {
      ${username} = {
        isNormalUser = true;
        uid = 1000;
        description = username;
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGjNyTPVTrUJcWrox+nheN7oEOYejfIrwcLgTac/qdNy xavierchanth nyx"
        ];
      };

      computer = {
        isNormalUser = true;
        description = "Computer Use";
        extraGroups = ["networkmanager"];
      };
    };
  };

  programs = {
    dconf = {
      enable = true;
      profiles.user.databases = [
        {
          settings."org/gnome/settings-daemon/plugins/power" = {
            sleep-inactive-ac-type = "nothing";
            sleep-inactive-battery-type = "nothing";
            sleep-inactive-ac-timeout = lib.gvariant.mkInt32 0;
            sleep-inactive-battery-timeout = lib.gvariant.mkInt32 0;
          };
          locks = [
            "/org/gnome/settings-daemon/plugins/power/sleep-inactive-ac-type"
            "/org/gnome/settings-daemon/plugins/power/sleep-inactive-battery-type"
            "/org/gnome/settings-daemon/plugins/power/sleep-inactive-ac-timeout"
            "/org/gnome/settings-daemon/plugins/power/sleep-inactive-battery-timeout"
          ];
        }
      ];
    };
    firefox.enable = true;
    zsh.enable = true;
  };

  services = {
    desktopManager.gnome.enable = true;
    displayManager.gdm = {
      enable = true;
      autoSuspend = false;
    };
    fwupd.enable = true;
    gnome.gnome-remote-desktop.enable = true;
    openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
    tailscale = {
      enable = true;
      # These fixed LAN hosts must retain working Internet DNS even if the
      # tailnet's configured DNS servers or MagicDNS proxy are unavailable.
      extraSetFlags = ["--accept-dns=false"];
    };
    xserver = {
      enable = true;
      xkb.layout = "us";
    };
  };

  # These are always-on lab machines. GNOME, logind, and direct systemd calls
  # must not suspend or hibernate them; display blanking remains available.
  services.logind.settings.Login = {
    HandleHibernateKey = "ignore";
    HandleLidSwitch = "ignore";
    HandleLidSwitchDocked = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleSuspendKey = "ignore";
    IdleAction = "ignore";
  };

  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  environment.systemPackages = with pkgs; [
    curl
    git
    gnome-terminal
    jq
    neovim
    ripgrep
    vim
  ];

  security.sudo.wheelNeedsPassword = true;
  security.sudo.execWheelOnly = true;
  services.fstrim.enable = true;
  zramSwap.enable = true;

  system.stateVersion = "26.05";
}
