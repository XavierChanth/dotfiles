{
  config,
  hostname,
  lib,
  pkgs,
  ...
}: let
  clusterHosts = import ../../cluster/hosts;
  peers = lib.filterAttrs (name: _: name != hostname) clusterHosts;
  peerValues = builtins.attrValues peers;
in {
  nix = {
    distributedBuilds = true;
    buildMachines = lib.mapAttrsToList (name: peer: {
      hostName = name;
      protocol = "ssh-ng";
      sshUser = "nixbuilder";
      sshKey = "/etc/ssh/ssh_host_ed25519_key";
      system = "x86_64-linux";
      inherit (peer) maxJobs speedFactor publicHostKey;
      supportedFeatures = [
        "benchmark"
        "big-parallel"
        "kvm"
        "nixos-test"
      ];
    }) peers;
    settings = {
      builders-use-substitutes = true;
      trusted-users = [
        "root"
        "nixbuilder"
      ];
    };
  };

  users = {
    groups.nixbuilder = {};
    users.nixbuilder = {
      isSystemUser = true;
      group = "nixbuilder";
      shell = pkgs.bashInteractive;
      openssh.authorizedKeys.keys = map (peer: peer.publicKey) peerValues;
    };
  };

  # Builder host keys authenticate only to the Nix daemon protocol: no shell,
  # TTY, or forwarding. Private host keys never leave their machines.
  services.openssh = {
    extraConfig = ''
      Match User nixbuilder
        ForceCommand ${config.nix.package}/bin/nix-daemon --stdio
        DisableForwarding yes
        PermitTTY no
        X11Forwarding no
      Match all
    '';
  };
}
