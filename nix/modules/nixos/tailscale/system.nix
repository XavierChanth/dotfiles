{ ... }: { services.tailscale = { enable = true; extraSetFlags = [ "--accept-dns=false" ]; }; }
