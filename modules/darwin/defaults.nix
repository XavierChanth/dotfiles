{username, ...}: let
  userHome = "/Users/${username}";
in {
  # GUI apps on macOS inherit PATH from the per-user launchd session rather
  # than from interactive shell startup files.
  launchd.user.envVariables.PATH = [
    "/run/current-system/sw/bin"
    "/etc/profiles/per-user/${username}/bin"
    "${userHome}/.dotfiles/bin/shared"
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
    "/usr/local/bin"
    "/usr/bin"
    "/bin"
    "/usr/sbin"
    "/sbin"
  ];

  system.defaults = {
    CustomUserPreferences."com.apple.symbolichotkeys" = {
      AppleSymbolicHotKeys = {
        # Spotlight search on Command-Space.
        "64" = {
          enabled = true;
          value = {
            parameters = [
              32
              49
              1048576
            ];
            type = "standard";
          };
        };
        # Disable finder search window on Command-Option-Space.
        "65" = {
          enabled = false;
          value = {
            parameters = [
              32
              49
              1572864
            ];
            type = "standard";
          };
        };
      };
    };

    NSGlobalDomain = {
      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
    };

    dock = {
      autohide = true;
      show-recents = false;
      tilesize = 40;
    };

    finder = {
      AppleShowAllExtensions = true;
      FXEnableExtensionChangeWarning = false;
      ShowPathbar = true;
      ShowStatusBar = true;
    };

    trackpad = {
      Clicking = true;
    };
  };
}
