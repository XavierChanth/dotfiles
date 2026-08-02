{lib, ...}: {
  environment.etc."pf.conf" = {
    # Allow the module to replace the stock Apple pf.conf on first activation.
    knownSha256Hashes = [
      "6fb5b260918922ca5ca4dfb296967d8edb9c12f2c043f26b64590758441d682d"
    ];
    text = ''
      #
      # Default PF configuration file.
      #
      # This file contains the main ruleset, which gets automatically loaded
      # at startup. PF will not be automatically enabled, however. Instead,
      # each component which utilizes PF is responsible for enabling and
      # disabling PF via -E and -X as documented in pfctl(8). That will ensure
      # that PF is disabled only when the last enable reference is released.
      #
      # Care must be taken to ensure that the main ruleset does not get flushed,
      # as the nested anchors rely on the anchor point defined here. In addition,
      # to the anchors loaded by this file, some system services would dynamically
      # insert anchors into the main ruleset. These anchors will be added only
      # when the system service is used and would removed on termination of the
      # service.
      #
      # See pf.conf(5) for syntax.
      #

      # Don't apply rules to localhost.
      set skip on lo0

      # Silently block all inbound.
      set block-policy return

      #
      # com.apple anchor point
      #
      scrub-anchor "com.apple/*"
      nat-anchor "com.apple/*"
      rdr-anchor "com.apple/*"
      dummynet-anchor "com.apple/*"
      anchor "com.apple/*"
      load anchor "com.apple" from "/etc/pf.anchors/com.apple"

      block all

      # Allow outbound connections.
      pass out all keep state

      # Allowed inbound services.
      pass in quick proto udp to port 68 # DHCP client replies
    '';
  };

  system.activationScripts.networking.text = lib.mkAfter ''
    run_pfctl() {
      local output

      if ! output="$("$@" 2>&1 >/dev/null)"; then
        printf '%s\n' "$output" >&2
        return 1
      fi
    }

    pf_is_enabled() {
      /sbin/pfctl -s info 2>/dev/null | /usr/bin/grep -q '^Status: Enabled'
    }

    printf >&2 'configuring PF close-ports rules...\n'
    run_pfctl /sbin/pfctl -n -f /etc/pf.conf
    run_pfctl /sbin/pfctl -f /etc/pf.conf

    if ! pf_is_enabled; then
      run_pfctl /sbin/pfctl -e
    fi
  '';
}
