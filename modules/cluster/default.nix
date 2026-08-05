{lib, ...}: {
  options.cluster.hosts = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule {
      options = {
        cacheAddress = lib.mkOption {
          type = lib.types.str;
          description = "LAN DNS name used for the host's binary cache.";
        };
        cacheInterface = lib.mkOption {
          type = lib.types.str;
          description = "LAN interface on which the host exposes its binary cache.";
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
