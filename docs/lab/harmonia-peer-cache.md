# Harmonia peer cache operations

The three caches are reachable only over the cluster LAN on TCP 5000, using their
`HOST.xavierchanth.local` names. Cache signing keys are
host-specific and versioned (`HOST-harmonia-VERSION`), with each version set by
that host's `cacheKeyVersion` inventory field. The private file is generated on
the host at `/var/lib/harmonia-keys/HOST-harmonia-VERSION.secret` (root, mode 0400); it
must never be copied off the host. The corresponding `.public` file is mode 0444.
Null keys in `modules/cluster/inventory.nix` deliberately disable that peer as a
substituter while allowing every host to evaluate and start its own cache.

## Two-phase bootstrap and Hades-first rollout

Keep all `cachePublicKey` values null for phase one. Deploy Hades locally using the
normal reviewed configuration workflow (do not use a peer cache yet):

```sh
sudo nixos-rebuild dry-activate --flake .#hades
sudo nixos-rebuild switch --flake .#hades
sudo systemctl status harmonia-keygen harmonia.socket --no-pager
sudo stat -c '%U:%G %a %n' /var/lib/harmonia-keys/hades-harmonia-v1.{secret,public}
```

Collect **only** the public key (the command does not read the secret):

```sh
ssh hades 'cat /var/lib/harmonia-keys/hades-harmonia-v1.public'
```

Put that exact output in Hades's `cachePublicKey` in
`modules/cluster/inventory.nix`, review and deploy Hades again, then deploy
Poseidon and Zeus phase one. Collect each public key with:

```sh
ssh poseidon 'cat /var/lib/harmonia-keys/poseidon-harmonia-v1.public'
ssh zeus 'cat /var/lib/harmonia-keys/zeus-harmonia-v1.public'
```

For phase two, replace the corresponding nulls with those exact public strings.
Run checks, commit, deploy Hades first, validate it, then Poseidon, then Zeus.
Never print, copy, commit, or place a `.secret` file in a Nix expression.

## Validation

Before either rollout:

```sh
nix flake check --no-build --no-write-lock-file
nix eval .#nixosConfigurations.hades.config.system.build.toplevel.drvPath --raw
nix eval .#nixosConfigurations.poseidon.config.system.build.toplevel.drvPath --raw
nix eval .#nixosConfigurations.zeus.config.system.build.toplevel.drvPath --raw
```

On each deployed host:

```sh
sudo systemctl is-active harmonia-keygen harmonia.socket
sudo ss -ltnp | grep ':5000'
sudo nft list ruleset | grep -C3 5000
nix config show | grep -E '^(substituters|trusted-public-keys|connect-timeout|stalled-download-timeout|fallback|require-sigs) ='
curl --fail --connect-timeout 3 http://PEER.xavierchanth.local:5000/nix-cache-info
```

Harmonia intentionally listens on the wildcard IPv6 socket (`[::]:5000`, which
also accepts IPv4 on the normal Linux configuration). The NixOS firewall exposes
TCP 5000 only on each host's declared cluster LAN interface (`enp1s0`); this
interface firewall—not address binding—is the network boundary. Confirm port 5000
appears only in the `enp1s0` firewall rules, every configured
peer has its matching key, self is absent, and `https://cache.nixos.org/` plus its
standard key remain present. A peer outage delays connection by at most the
configured timeout and then falls back to another substituter or local builds;
signatures remain mandatory.

## Rotation, rollback, and garbage collection

To rotate one host, change only that host's `cacheKeyVersion` in inventory (for
example, to `v2`) and deploy the host with peers still trusting v1. Collect only
the new versioned `.public`, replace that host's `cachePublicKey`, and roll out
Hades first. Remove the old private key only after every peer trusts v2. Do not
overwrite a key in place.

Rollback the NixOS generation normally. If a bad public key was published, set
that inventory entry to null and redeploy; clients then omit that peer. Do not
delete the persistent signing key during rollback.

Harmonia serves paths from the host's ordinary Nix store; it does not pin them.
Normal Nix GC can remove cached paths, after which clients receive a miss and use
another substituter or build locally. Add explicit GC roots separately for any
artifacts that must remain available.
