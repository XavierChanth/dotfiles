# Lab Hosts

## Eris

Eris remains on macOS and is managed by `darwinConfigurations.eris` plus Home Manager. nix-darwin owns supported system settings and Home Manager owns user tools. It may be a macOS-capability worker, but Linux services must not depend on it being online. Whether it hosts always-on work or is the sole deployment origin remains undecided.

## Linux hosts: Hades, Poseidon, and Zeus

Each host is independently exposed as `nixosConfigurations.<hostname>` with Home Manager for the operator account. The repository now has NixOS configurations for all three; any real-world Ubuntu-to-NixOS transition must still preserve bootable rollback and recovery access.

For each host:

- Select workloads explicitly in its host module; do not infer assignments from its name.
- Keep durable data outside the Nix store and back it up to the NAS.
- Isolate and resource-limit agent workloads.
- Record CPU, RAM, disks, accelerators, and existing workloads before assigning stable-service or disposable-worker duties.
- Build and deploy independently so one host's failure does not block the others.

## Deployment

The deploy-rs lab set is Eris, Hades, Poseidon, and Zeus, addressed by canonical IP. Charon is OpenWrt and Nyx is only a client. The canonical sequential order is Poseidon, Zeus, Hades, Eris; see [deploy.md](deploy.md).
