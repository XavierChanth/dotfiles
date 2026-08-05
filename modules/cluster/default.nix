{lib, ...}: {
  options.cluster.hosts = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule {
      options = {
        tailscaleAddress = lib.mkOption {
          type = lib.types.str;
          description = "Tailscale IPv4 address used for cluster-only services.";
        };
        cacheKeyVersion = lib.mkOption {
          type = lib.types.str;
          description = "Version suffix for this host's Harmonia signing key.";
        };
        cachePublicKey = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Harmonia public signing key for cacheKeyVersion, or null until bootstrapped.";
        };
      };
    });
    default = import ./inventory.nix;
    readOnly = true;
    description = "Single inventory for trusted cluster cache peers.";
  };
}
