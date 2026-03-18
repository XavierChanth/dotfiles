{
  lib,
  username,
  ...
}: let
  userHome = "/Users/${username}";
  extensionUrl = "raycast://extensions/pabroux/keepassxc";
  stateDir = "${userHome}/Library/Application Support/com.raycast.macos/nix";
  extensionMarker = "${stateDir}/keepassxc-extension-installed";
  symbolicHotkeysPlist = "${userHome}/Library/Preferences/com.apple.symbolichotkeys.plist";
in {
  system.defaults.CustomUserPreferences."com.raycast.macos" = {
    raycastGlobalHotkey = "Command-49";
  };

  system.activationScripts.raycastExtension.text = lib.mkAfter ''
    uid="$(/usr/bin/id -u '${username}')"

    /usr/bin/sudo -u '${username}' /usr/bin/env HOME='${userHome}' \
      /usr/bin/defaults write com.raycast.macos raycastGlobalHotkey -string 'Command-49'

    /usr/bin/mkdir -p "$(/usr/bin/dirname '${symbolicHotkeysPlist}')"
    /usr/bin/touch '${symbolicHotkeysPlist}'
    /usr/sbin/chown '${username}':staff '${symbolicHotkeysPlist}'

    /usr/libexec/PlistBuddy -c 'Delete :AppleSymbolicHotKeys:64' '${symbolicHotkeysPlist}' >/dev/null 2>&1 || true
    /usr/libexec/PlistBuddy -c 'Add :AppleSymbolicHotKeys:64 dict' '${symbolicHotkeysPlist}'
    /usr/libexec/PlistBuddy -c 'Add :AppleSymbolicHotKeys:64:enabled bool true' '${symbolicHotkeysPlist}'
    /usr/libexec/PlistBuddy -c 'Add :AppleSymbolicHotKeys:64:value dict' '${symbolicHotkeysPlist}'
    /usr/libexec/PlistBuddy -c 'Add :AppleSymbolicHotKeys:64:value:type string standard' '${symbolicHotkeysPlist}'
    /usr/libexec/PlistBuddy -c 'Add :AppleSymbolicHotKeys:64:value:parameters array' '${symbolicHotkeysPlist}'
    /usr/libexec/PlistBuddy -c 'Add :AppleSymbolicHotKeys:64:value:parameters:0 integer 32' '${symbolicHotkeysPlist}'
    /usr/libexec/PlistBuddy -c 'Add :AppleSymbolicHotKeys:64:value:parameters:1 integer 49' '${symbolicHotkeysPlist}'
    /usr/libexec/PlistBuddy -c 'Add :AppleSymbolicHotKeys:64:value:parameters:2 integer 1572864' '${symbolicHotkeysPlist}'

    /usr/libexec/PlistBuddy -c 'Delete :AppleSymbolicHotKeys:65' '${symbolicHotkeysPlist}' >/dev/null 2>&1 || true
    /usr/libexec/PlistBuddy -c 'Add :AppleSymbolicHotKeys:65 dict' '${symbolicHotkeysPlist}'
    /usr/libexec/PlistBuddy -c 'Add :AppleSymbolicHotKeys:65:enabled bool false' '${symbolicHotkeysPlist}'
    /usr/libexec/PlistBuddy -c 'Add :AppleSymbolicHotKeys:65:value dict' '${symbolicHotkeysPlist}'
    /usr/libexec/PlistBuddy -c 'Add :AppleSymbolicHotKeys:65:value:type string standard' '${symbolicHotkeysPlist}'
    /usr/libexec/PlistBuddy -c 'Add :AppleSymbolicHotKeys:65:value:parameters array' '${symbolicHotkeysPlist}'
    /usr/libexec/PlistBuddy -c 'Add :AppleSymbolicHotKeys:65:value:parameters:0 integer 32' '${symbolicHotkeysPlist}'
    /usr/libexec/PlistBuddy -c 'Add :AppleSymbolicHotKeys:65:value:parameters:1 integer 49' '${symbolicHotkeysPlist}'
    /usr/libexec/PlistBuddy -c 'Add :AppleSymbolicHotKeys:65:value:parameters:2 integer 1572864' '${symbolicHotkeysPlist}'

    /usr/bin/killall cfprefsd >/dev/null 2>&1 || true
    /bin/launchctl asuser "$uid" /usr/bin/killall SystemUIServer >/dev/null 2>&1 || true

    mkdir -p '${stateDir}'
    chown '${username}':staff '${stateDir}'

    if [ ! -e '${extensionMarker}' ]; then
      if /bin/launchctl asuser "$uid" /usr/bin/open -g '${extensionUrl}' >/dev/null 2>&1; then
        touch '${extensionMarker}'
        chown '${username}':staff '${extensionMarker}'
      fi
    fi
  '';
}
