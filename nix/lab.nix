{
  domain = "lab.xavierchanth.xyz";
  router = {
    host = "charon";
    uci = { dhcpSection = "lan"; dnsmasqSection = "@dnsmasq[0]"; };
  };
  deploymentOrder = [ "hades" "poseidon" "zeus" ];
  hosts = {
    charon = { address = "192.168.8.1"; fqdn = "charon.lab.xavierchanth.xyz"; status = "stable"; deploy = false; };
    hades = { address = "192.168.8.2"; fqdn = "hades.lab.xavierchanth.xyz"; status = "stable"; deploy = true; };
    poseidon = { address = "192.168.8.3"; fqdn = "poseidon.lab.xavierchanth.xyz"; status = "stable"; deploy = true; };
    zeus = { address = "192.168.8.4"; fqdn = "zeus.lab.xavierchanth.xyz"; status = "stable"; deploy = true; };
    eris = { address = "192.168.8.202"; fqdn = null; status = "pending-address"; deploy = false; };
  };
}
