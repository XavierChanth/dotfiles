{ lab ? import ../lab.nix }:
let
  inherit (builtins) attrNames concatStringsSep filter map match;
  names = attrNames lab.hosts;
  records = filter (n: lab.hosts.${n}.fqdn != null) names;
  addresses = map (n: lab.hosts.${n}.address) names;
  fqdns = map (n: lab.hosts.${n}.fqdn) records;
  unique = xs: builtins.length xs == builtins.length (attrNames (builtins.listToAttrs (map (x: { name = x; value = true; }) xs)));
  labels = s: builtins.filter builtins.isString (builtins.split "\\." s);
  validLabel = s: match "^[a-z0-9]([a-z0-9-]*[a-z0-9])?$" s != null && builtins.stringLength s <= 63;
  validDNS = s: builtins.stringLength s <= 253 && builtins.all validLabel (labels s);
  validIP = s: let parts = builtins.filter builtins.isString (builtins.split "\\." s); in
    builtins.length parts == 4 && builtins.all (p: match "^[0-9]{1,3}$" p != null && builtins.fromJSON p <= 255) parts;
  underDomain = fqdn: let suffix = ".${lab.domain}"; l = builtins.stringLength fqdn; sl = builtins.stringLength suffix;
    in l > sl && builtins.substring (l - sl) sl fqdn == suffix;
  validHost = n: let h = lab.hosts.${n}; in validIP h.address
    && builtins.elem h.status [ "stable" "pending-address" ]
    && (if h.status == "pending-address" then h.fqdn == null else h.fqdn != null && validDNS h.fqdn && underDomain h.fqdn);
  valid = validDNS lab.domain && builtins.all validHost names && unique addresses && unique fqdns
    && lab.router.host == "charon" && lab.router.uci.dhcpSection == "lan" && lab.router.uci.dnsmasqSection == "@dnsmasq[0]";
  quote = s: "'${s}'";
  section = n: "dotfiles_lab_${n}";
  server = "/${lab.domain}/";
  search = "option:domain-search,${lab.domain},lan";
  hostLines = builtins.concatLists (map (n: [
    "set dhcp.${section n}=hostrecord"
    "set dhcp.${section n}.name=${quote lab.hosts.${n}.fqdn}"
    "set dhcp.${section n}.ip=${quote lab.hosts.${n}.address}"
    "set dhcp.${section n}.dotfiles_owner='lab-dns-v2'"
  ]) records);
in if !valid then throw "invalid canonical lab inventory" else concatStringsSep "\n" ([
  "add_list dhcp.${lab.router.uci.dnsmasqSection}.server=${quote server}"
  "add_list dhcp.${lab.router.uci.dhcpSection}.dhcp_option=${quote search}"
  "set dhcp.dotfiles_lab_metadata=dotfiles"
  "set dhcp.dotfiles_lab_metadata.dotfiles_owner='lab-dns-v2'"
  "set dhcp.dotfiles_lab_metadata.server=${quote server}"
  "set dhcp.dotfiles_lab_metadata.search=${quote search}"
] ++ hostLines ++ [ "" ])
