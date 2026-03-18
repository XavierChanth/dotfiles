{
  lib,
  username,
  ...
}: let
  userHome = "/Users/${username}";
  extensionUrl = "raycast://extensions/pabroux/keepassxc";
  stateDir = "${userHome}/Library/Application Support/com.raycast.macos/nix";
  extensionMarker = "${stateDir}/keepassxc-extension-installed";
in {
  system.defaults.CustomUserPreferences = {
    "com.raycast.macos" = {
      raycastGlobalHotkey = "Command-49";
    };

    "com.apple.symbolichotkeys" = {
      AppleSymbolicHotKeys = {
        "64" = {
          enabled = true;
          value = {
            parameters = [
              32
              49
              1572864
            ];
            type = "standard";
          };
        };

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
  };

  system.activationScripts.raycastExtension.text = lib.mkAfter ''
    uid="$(/usr/bin/id -u '${username}')"

    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u >/dev/null 2>&1 || true

    /usr/bin/mkdir -p '${stateDir}'
    /usr/sbin/chown '${username}':staff '${stateDir}'

    if [ ! -e '${extensionMarker}' ]; then
      if /bin/launchctl asuser "$uid" /usr/bin/open -g '${extensionUrl}' >/dev/null 2>&1; then
        /usr/bin/touch '${extensionMarker}'
        /usr/sbin/chown '${username}':staff '${extensionMarker}'
      fi
    fi
  '';
}
