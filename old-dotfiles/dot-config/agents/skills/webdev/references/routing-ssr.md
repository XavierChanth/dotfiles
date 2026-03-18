# Routing & SSR (TanStack Start)

Use this when the request involves routing, data loaders, or SSR behavior.

## Core guidance
- Emphasize SSR data preloading via React Query to minimize loading states and improve TTFB.
- Use SSR to prime the initial cache; then use Convex client hooks to keep data in sync after hydration.
- Treat Convex as the live source of truth on the client while React Query provides SSR prefetch and cache hydration.
- Prefer official Convex client integrations for TanStack Start + React Query workflows.
- Do not rely on client auth state during SSR; keep SSR data access scoped to server-safe inputs.

## Workflow
1. Identify the route boundaries and data needed for first paint.
2. Prefetch with React Query during SSR for those routes.
3. Hydrate on the client and subscribe via Convex hooks to keep data current.
4. Keep loaders and client hooks close to the route/component that consumes the data.

## Tooling
- Prefer Bun for installs, scripts, and CLIs unless the user explicitly requests npm/pnpm/yarn.
- Prefer `bunx` over `npx` for one-off CLIs.

## Docs (URLs)
Provide URLs in code blocks (no inline links).

```text
https://tanstack.com/start/latest
https://tanstack.com/router/latest
https://tanstack.com/query/latest
https://docs.convex.dev/
```
