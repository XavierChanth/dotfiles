# Autumn Billing (Convex Component)

Use this when the request includes billing, pricing plans, subscriptions, usage-based limits, or feature gating with Autumn in a Convex app.

## Guidance
- Use the Convex component for Autumn; avoid custom backend endpoints.
- Convex projects should use the Convex component even if they use Better Auth for auth.
- Keep billing logic on the server via Autumn's Convex client and expose only the minimum UI needed.
- Use `check` before gated actions; call `track` after usage happens.
- Prefer Autumn's React components/hooks for pricing and billing UX.
- Keep secrets in Convex env vars; never hardcode keys.

## Setup (Convex)
1) Install packages:

```bash
bun add @useautumn/convex autumn-js
```

2) Set the secret key in Convex env:

```bash
bunx convex env set AUTUMN_SECRET_KEY=am_sk_xxx
```

3) Add the component to `convex/convex.config.ts`:

```ts
import { defineApp } from "convex/server";
import autumn from "@useautumn/convex/convex.config";

const app = defineApp();
app.use(autumn);

export default app;
```

4) Initialize Autumn in `convex/autumn.ts`:

```ts
import { components } from "./_generated/api";
import { Autumn } from "@useautumn/convex";

export const autumn = new Autumn(components.autumn, {
  secretKey: process.env.AUTUMN_SECRET_KEY ?? "",
  identify: async (ctx: any) => {
    const user = await ctx.auth.getUserIdentity();
    if (!user) return null;

    return {
      customerId: user.subject,
      customerData: {
        name: user.name as string,
        email: user.email as string,
      },
    };
  },
});

export const {
  track,
  cancel,
  query,
  attach,
  check,
  checkout,
  usage,
  setupPayment,
  createCustomer,
  listProducts,
  billingPortal,
  createReferralCode,
  redeemReferralCode,
  createEntity,
  getEntity,
} = autumn.api();
```

Note: Only split `user.subject` if you use Auth0-style `provider|id` values.

## Frontend setup
Wrap the app with `AutumnProvider` to use hooks and UI components:

```tsx
"use client";
import { AutumnProvider } from "autumn-js/react";
import { useConvex } from "convex/react";
import { api } from "@convex/_generated/api";

export function AutumnWrapper({ children }: { children: React.ReactNode }) {
  const convex = useConvex();

  return (
    <AutumnProvider convex={convex} convexApi={api.autumn}>
      {children}
    </AutumnProvider>
  );
}
```

Note: Nest this provider inside existing Convex/Auth providers.

## Schema guidance
Prefer storing the auth user id directly as a string, without a local users table:

```ts
import { defineSchema, defineTable } from "convex/server";
import { v } from "convex/values";

export default defineSchema({
  workspaces: defineTable({
    userId: v.string(),
    name: v.string(),
  }).index("by_user_id", ["userId"]),
});
```

## Local subscription tables
When Autumn is the source of truth, a local subscriptions table is usually unnecessary.

Add one only when you need:
- complex joins across billing and app data
- caching for high-traffic reads
- custom metadata not stored in Autumn

Default recommendation: do not create a local subscriptions table.

## Common UI patterns
- Pricing: `PricingTable` component for plan selection.
- Paywall: `PaywallDialog` to upsell when limits are hit.
- Checkout: `CheckoutDialog` / `AttachDialog` for upgrades and payments.
- Usage: `useCustomer()` to show balances, invoices, and limits.

## Server-side usage
Check access before gated actions, then track usage:

```ts
import { autumn } from "convex/autumn";

const { data } = await autumn.check(ctx, { featureId: "messages" });
if (!data.allowed) return;

await autumn.track(ctx, { featureId: "messages", value: 1 });
```

## Non-consumable (limit-based) features
Example for a feature like `np_endpoints` where each resource counts against a limit:

```ts
import { autumn } from "convex/autumn";

// Before creating an endpoint
const { data } = await autumn.check(ctx, { featureId: "np_endpoints" });
if (!data.allowed) {
  const isFreeTier = (data.included_usage ?? 0) > 0;
  const atLimit = (data.included_usage ?? 0) === 0;
  if (atLimit) throw new Error("limit_reached");
  if (isFreeTier) throw new Error("upgrade_required");
  return;
}

// After creating the endpoint
await autumn.track(ctx, { featureId: "np_endpoints", value: 1 });

// After deleting the endpoint
await autumn.track(ctx, { featureId: "np_endpoints", value: -1 });
```

## Docs (URLs)
Provide URLs in code blocks (no inline links).

```text
https://www.convex.dev/components/autumn
https://docs.useautumn.com/documentation/getting-started/setup/convex
https://docs.useautumn.com/react/hooks/autumn-provider
https://www.better-auth.com/docs/plugins/autumn
https://docs.useautumn.com/documentation/customers/check
https://docs.useautumn.com/react/hooks/useCustomer
```
