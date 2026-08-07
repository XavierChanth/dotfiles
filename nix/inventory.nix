{
  nyx = { system = "aarch64-darwin"; kind = "darwin"; profile = "darwin-workstation"; };
  eris = { system = "aarch64-darwin"; kind = "darwin"; profile = "darwin-server"; };
  hades = {
    system = "x86_64-linux"; kind = "nixos"; profile = "linux-server";
    cacheAddress = "hades.xavierchanth.local"; cacheInterface = "enp1s0";
    cacheKeyVersion = "v1"; cachePublicKey = null;
  };
  poseidon = {
    system = "x86_64-linux"; kind = "nixos"; profile = "linux-server";
    cacheAddress = "poseidon.xavierchanth.local"; cacheInterface = "enp1s0";
    cacheKeyVersion = "v1"; cachePublicKey = null;
  };
  zeus = {
    system = "x86_64-linux"; kind = "nixos"; profile = "linux-server";
    cacheAddress = "zeus.xavierchanth.local"; cacheInterface = "enp1s0";
    cacheKeyVersion = "v1"; cachePublicKey = null;
  };
}
