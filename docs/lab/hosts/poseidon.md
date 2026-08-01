# Poseidon Management Strategy

## Desired state

Manage Poseidon as `nixosConfigurations.poseidon` with Home Manager for its operator account. Its host module selects workloads; reusable service definitions live under `modules/services`.

## Ubuntu transition

Install multi-user Nix and apply a standalone Home Manager configuration. Nix may package applications and tools, but Ubuntu continues to own boot, users, networking, firewall, and root systemd state. Avoid expanding this split state indefinitely.

## NixOS target

Capture generated hardware configuration, then add shared Linux baseline and Poseidon-specific modules. Build remotely before switching. Keep bootable rollback generations and document recovery access.

## Workload rules

- Enable services explicitly in the Poseidon host configuration.
- Keep durable data outside the Nix store and backed up to the existing NAS.
- Run agent code as an isolated, resource-limited identity or container.
- Assign Forgejo, Hermes, or worker duty only after hardware inventory.

## Deployment unit

Poseidon is deployed independently. A failed Poseidon evaluation or workload must not block configuration builds for Zeus, Hades, or Eris.

## Decisions still needed

- CPU, RAM, disk, and accelerator inventory.
- Workloads currently running on Poseidon.
- Whether it is best suited to a stable service or disposable worker assignment.

