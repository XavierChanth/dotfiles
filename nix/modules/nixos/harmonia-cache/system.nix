{config, hostname, inventory, lib, pkgs, ...}: let
  hosts = lib.filterAttrs (_: host: host ? cacheAddress) inventory;
  keyDirectory = "/var/lib/harmonia-keys";
  localHost = hosts.${hostname};
  keyVersion = localHost.cacheKeyVersion;
  keyName = "${hostname}-harmonia-${keyVersion}";
  privateKey = "${keyDirectory}/${keyName}.secret";
  publicKey = "${keyDirectory}/${keyName}.public";
  readyPeers = lib.filterAttrs (name: peer:
    name != hostname && peer.cachePublicKey != null
  ) hosts;
  peerValues = builtins.attrValues readyPeers;
in {
  assertions = [{
    assertion = builtins.hasAttr hostname hosts;
    message = "${hostname} is absent from the cluster cache inventory";
  }];

  nix = {
    distributedBuilds = false;
    settings = {
      extra-substituters = map (peer: "http://${peer.cacheAddress}:5000") peerValues;
      extra-trusted-public-keys = map (peer: peer.cachePublicKey) peerValues;
      connect-timeout = 3;
      stalled-download-timeout = 60;
      fallback = true;
      require-sigs = true;
    };
  };

  networking.firewall.interfaces.${localHost.cacheInterface}.allowedTCPPorts = [5000];

  systemd.services.harmonia-keygen = {
    description = "Create the host-local Harmonia signing key";
    wantedBy = ["multi-user.target"];
    requiredBy = ["harmonia.service"];
    before = ["harmonia.service"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "root";
      Group = "root";
      UMask = "0077";
    };
    script = ''
      set -eu
      install -d -m 0755 -o root -g root ${keyDirectory}
      if [ ! -e ${lib.escapeShellArg privateKey} ] && [ ! -e ${lib.escapeShellArg publicKey} ]; then
        tmpdir="$(${pkgs.coreutils}/bin/mktemp -d ${keyDirectory}/.keygen.XXXXXX)"
        trap '${pkgs.coreutils}/bin/rm -rf "$tmpdir"' EXIT
        ${config.nix.package}/bin/nix-store --generate-binary-cache-key \
          ${lib.escapeShellArg keyName} "$tmpdir/secret" "$tmpdir/public"
        install -m 0400 -o root -g root "$tmpdir/secret" ${lib.escapeShellArg privateKey}
        install -m 0444 -o root -g root "$tmpdir/public" ${lib.escapeShellArg publicKey}
      elif [ ! -s ${lib.escapeShellArg privateKey} ] || [ ! -s ${lib.escapeShellArg publicKey} ]; then
        echo "refusing to replace an incomplete Harmonia keypair" >&2
        exit 1
      fi
      chmod 0755 ${keyDirectory}
      chmod 0400 ${lib.escapeShellArg privateKey}
      chmod 0444 ${lib.escapeShellArg publicKey}
    '';
  };

  services.harmonia.cache = {
    enable = true;
    signKeyPaths = [privateKey];
    settings = {
      bind = "[::]:5000";
      priority = 30;
    };
  };
}
