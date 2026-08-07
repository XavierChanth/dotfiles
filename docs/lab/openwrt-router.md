# Charon OpenWrt router DNS

## Desired state

`nix/lab.nix` is canonical. Charon (`192.168.8.1`) serves `lab.xavierchanth.xyz`; Eris is excluded while its address is pending. The renderer creates deterministic `hostrecord` UCI sections named `dotfiles_lab_*`, each carrying the ignored ownership option `dotfiles_owner=lab-dns-v2`. Apply removes only sections matching both that prefix and marker, so unrelated host records are preserved.

The default dnsmasq `domain='lan'` and `local='/lan/'` remain untouched. The private zone is the exact local-only `server` list item `/lab.xavierchanth.xyz/`. DHCP option 119 is the single value `option:domain-search,lab.xavierchanth.xyz,lan`, preserving `.lan`. Existing Harmonia `.local` endpoints are unchanged.

## Unverified live assumptions

The attended tool expects `dhcp.lan`, `dhcp.@dnsmasq[0]`, Charon's LAN address at `.1`, and dnsmasq answering on loopback. These are desired defaults, not live observations. Interface/domain-list support for advertising the IPv6 search domain has not been verified and is deliberately not configured yet. No router was contacted by this work.

## Render and attended apply

Build with `nix build .#openwrt-charon-uci --no-write-lock-file`, or inspect without networking using `nix run .#openwrt-apply-charon -- --dry-run`. A live run requires the explicit `--apply` argument and typed confirmation `apply charon` from a local TTY.

Before SSH, the tool creates a mode-700 local directory at `${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/openwrt/charon` with umask 077 and verifies it is writable. It rejects pre-existing staged DHCP changes, takes an atomic remote lock, then creates root-only persistent backups under `/root/dotfiles-openwrt/backups`. Both `/etc/config/dhcp` and a sysupgrade archive are copied locally and verified nonempty before staging.

The tool stages the complete desired set, displays exact changes, and exits without confirmation or commit when already converged. Refusal or any pre-commit failure reverts this run. Success commits once, reloads both dnsmasq and odhcpd, and retries local-router DNS checks for every rendered FQDN. Transient batch files and the lock are removed; named backups remain.

`CHARON_SSH_BIN`, `CHARON_SCP_BIN`, and `CHARON_TTY_PATH` are hermetic test seams. `CHARON_RENDER` selects a pre-reviewed render artifact; `CHARON_BACKUP_DIR` may relocate private local backups. The target is fixed to `root@192.168.8.1`.

## Recovery

After a post-commit error, the trap attempts to restore the persistent DHCP backup and reload both services. This is best effort: loss of SSH or connectivity makes automatic recovery impossible. Keep a second admin session open. For manual wired recovery use `192.168.8.1`, the router copies in `/root/dotfiles-openwrt/backups`, or the private local state directory above.

Only after router and client validation should Harmonia move away from `.local`.
