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
