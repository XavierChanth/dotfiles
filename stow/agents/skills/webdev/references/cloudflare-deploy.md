# Deployment (Cloudflare Workers)

Use this when the request involves deployment, build output, or runtime constraints tied to Cloudflare Workers.

## Guidance
- Prefer Cloudflare Workers-compatible patterns for SSR and server entry points.
- Keep runtime assumptions aligned with the Workers environment (no Node-only APIs without compatibility layers).
- Call out any build or deployment steps explicitly if the user requests them.

## Tooling
- Prefer Bun for installs, scripts, and CLIs unless the user explicitly requests npm/pnpm/yarn.
- Prefer `bunx` over `npx` for one-off CLIs.

## Docs (URLs)
Provide URLs in code blocks (no inline links).

```text
https://developers.cloudflare.com/workers/
https://developers.cloudflare.com/workers/frameworks/
```
