# Eris Management Strategy

## Desired state

Keep macOS and manage it through `darwinConfigurations.eris` plus Home Manager. Eris is managed by the same flake as the Linux machines without pretending macOS is NixOS.

## Configuration scope

- nix-darwin: macOS defaults, packages, launchd services, system integrations, and supported host settings.
- Home Manager: shell, Git, SSH client, editors, and user-level tools.
- Host module: hardware- or Eris-specific settings and explicitly enabled workloads.
- Shared modules: portable configuration used by both Darwin and Linux.

## Deployment

Build before switching. Retain the previous nix-darwin generation for rollback. Eris may initiate remote Linux deployments, but Linux services must continue when Eris is offline.

## Agent workloads

Eris can run a capability-labeled macOS worker when a task needs Apple tooling or ARM macOS. Do not use it as the default Linux worker. Agent identities must not inherit the operator's deployment credentials or full home-directory access.

## Current repository change required

The flake currently treats every host as `aarch64-darwin`. Replace that global value with per-host platform metadata before adding Linux hosts.

## Decisions still needed

- Whether Eris should run any always-on workload.
- Whether it will be the only deployment origin.
- Which macOS-specific background tasks justify a local worker.

