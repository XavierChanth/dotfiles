# better-auth + better-auth-ui

Use this when the request includes authentication flows or UI built with better-auth and better-auth-ui.

## Guidance
- Ask which auth providers are required before wiring UI flows.
- Server-side: configure BetterAuth in Convex using the Convex component/plugin approach.
- Server-side: use the Convex BetterAuth React Start helper to export `handler`, `getToken`, and fetch helpers, wired with `VITE_CONVEX_URL` and a `convexSiteUrl` derived from it.
- Frontend: use the Convex-based BetterAuth provider approach; do not use TanStack Start-specific auth wiring.
- Frontend: wrap the app with `ConvexBetterAuthProvider` using the Convex client from route context and pass `initialToken`.
- Frontend: mount BetterAuth UI via `AuthQueryProvider` + `AuthUIProviderTanstack`, and wire navigation through the router.
- Frontend: create the auth client with `createAuthClient` and include `convexClient()` plus `twoFactorClient()` plugins.
- Keep auth UI composable and consistent with the existing design system.
- Avoid hard-coding secrets; keep config in env and passed through the expected runtime mechanism.
- If CAPTCHA is required, prefer Cloudflare Turnstile and keep the site key in env.

## Tooling
- Prefer Bun for installs, scripts, and CLIs unless the user explicitly requests npm/pnpm/yarn.
- Prefer `bunx` over `npx` for one-off CLIs.

## Docs (URLs)
Provide URLs in code blocks (no inline links).

```text
https://labs.convex.dev/better-auth/framework-guides/tanstack-start#usage
(Ask the user for the canonical better-auth docs if not already provided.)
```
