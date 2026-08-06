{
  nyx = { system = "aarch64-darwin"; profile = "workstation"; };
  eris = { system = "aarch64-darwin"; profile = "server"; };
  hades = {
    system = "x86_64-linux"; profile = "server";
    cacheAddress = "hades.xavierchanth.local"; cacheInterface = "enp1s0";
    cacheKeyVersion = "v1"; cachePublicKey = null;
  };
  poseidon = {
    system = "x86_64-linux"; profile = "server";
    cacheAddress = "poseidon.xavierchanth.local"; cacheInterface = "enp1s0";
    cacheKeyVersion = "v1"; cachePublicKey = null;
  };
  zeus = {
    system = "x86_64-linux"; profile = "server";
    cacheAddress = "zeus.xavierchanth.local"; cacheInterface = "enp1s0";
    cacheKeyVersion = "v1"; cachePublicKey = null;
  };
}
