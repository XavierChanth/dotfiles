# Bun + Turborepo Monorepo Reference

This reference covers setting up and working with a Bun-managed monorepo with Turborepo, TanStack Start, Convex, and shadcn/ui.

## Repository Layout

```
/
  apps/
    web/                 # Vite + TanStack Start web app
  packages/
    backend/             # Convex backend project
    ui/                  # Shared React UI components (shadcn)
  tools/                 # Deploy scripts (preview/prod)
  package.json           # Root workspace + scripts
  turbo.json             # Turborepo pipeline
  biome.json             # Biome config
  tsconfig.base.json     # Shared TS paths
  bun.lock               # Bun lockfile
```

## Root Configuration

### package.json

Root `package.json` should:

- Set `private: true`
- Define `packageManager` with fixed Bun version (e.g., `"bun@1.2.3"`)
- Define workspaces:
  - `apps/*`
  - `packages/*`
- Include root scripts that delegate to Turborepo:
  - `dev`: `turbo run dev`
  - `build`: `turbo run build`
  - `typegen`: `turbo run typegen`
  - `format`: `turbo run format`
  - `lint`: `turbo run lint`
  - `check`: `turbo run check`
  - `deploy:preview`: `bash tools/deploy-preview.sh`
  - `deploy:prod`: `bash tools/deploy-prod.sh`

### turbo.json

Root `turbo.json` defines the task pipeline:

```json
{
  "$schema": "https://turbo.build/schema.json",
  "tasks": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["dist/**", ".next/**"]
    },
    "dev": {
      "cache": false,
      "persistent": true
    },
    "typegen": {
      "cache": false
    },
    "format": {
      "cache": false
    },
    "lint": {
      "cache": false
    },
    "check": {
      "dependsOn": ["^build"]
    },
    "deploy:preview": {
      "dependsOn": ["build"],
      "cache": false
    },
    "deploy:prod": {
      "dependsOn": ["build"],
      "cache": false
    }
  }
}
```

App-specific `turbo.json` (e.g., `apps/web/turbo.json`) can extend the root pipeline:

```json
{
  "extends": ["//"],
  "tasks": {
    "dev": {
      "dependsOn": ["backend:dev"]
    }
  }
}
```

### biome.json

Repo-wide formatter and linter:

```json
{
  "$schema": "https://biomejs.dev/schemas/1.9.0/schema.json",
  "formatter": {
    "enabled": true,
    "formatWithErrors": false,
    "indentStyle": "space",
    "indentWidth": 2,
    "lineWidth": 100,
    "lineEnding": "lf"
  },
  "linter": {
    "enabled": true
  },
  "files": {
    "include": ["src/**/*", "*.json", "*.ts", "*.tsx", "*.js", "*.jsx"],
    "ignore": ["node_modules/**", "dist/**", ".next/**", ".turbo/**"]
  }
}
```

### tsconfig.base.json

Shared TypeScript config with path aliases:

```json
{
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@convex/*": ["packages/backend/convex/*"],
      "@web/*": ["apps/web/src/*"],
      "@ui/*": ["packages/ui/src/*"],
      "@backend/*": ["packages/backend/src/*"]
    },
    "module": "ESNext",
    "moduleResolution": "bundler",
    "target": "ES2022",
    "strict": true
  }
}
```

## Apps

### apps/web (Vite + TanStack Start)

#### package.json scripts

```json
{
  "scripts": {
    "dev": "vite dev --port 3000",
    "build": "vite build",
    "typegen": "wrangler types",
    "format": "biome format --write .",
    "lint": "biome lint .",
    "check": "biome check ."
  }
}
```

#### Key dependencies

```json
{
  "dependencies": {
    "react": "^19.0.0",
    "react-dom": "^19.0.0",
    "@tanstack/react-start": "^1.0.0",
    "@tanstack/react-router": "^2.0.0",
    "@tanstack/react-query": "^5.0.0",
    "convex": "^1.0.0",
    "@your-org/ui": "workspace:*",
    "@your-org/backend": "workspace:*"
  },
  "devDependencies": {
    "vite": "^6.0.0",
    "@vitejs/plugin-react": "^4.0.0",
    "vite-tsconfig-paths": "^5.0.0",
    "@tailwindcss/vite": "^4.0.0",
    "tailwindcss": "^4.0.0",
    "wrangler": "^3.0.0"
  }
}
```

#### File-based routing

Routes live under `apps/web/src/routes/`:

```
src/routes/
  __root.tsx          # Root layout
  index.tsx           # Home page (/)
  about.tsx           # About page (/about)
  blog/
    __root.tsx        # Blog layout
    index.tsx         # Blog index (/blog)
    $slug.tsx         # Blog post (/blog/:slug)
```

#### Tailwind integration

In `apps/web/src/styles.css`:

```css
@import "tailwindcss";

@source "../**/*.{ts,tsx}";
@source "../../../packages/ui/src/**/*.{ts,tsx}";

@import "@your-org/ui/styles.css";
```

#### Convex client setup

In `apps/web/src/convex/client.ts`:

```ts
import { ConvexProvider, ConvexReactClient } from "convex/react";
import { StrictMode } from "react";
import { createRootRoute, Outlet } from "@tanstack/react-router";

const convex = new ConvexReactClient(import.meta.env.VITE_CONVEX_URL!);

export const Route = createRootRoute({
  component: () => (
    <ConvexProvider client={convex}>
      <Outlet />
    </ConvexProvider>
  ),
});
```

## Packages

### packages/backend (Convex)

#### package.json scripts

```json
{
  "scripts": {
    "dev": "convex dev",
    "format": "biome format --write .",
    "lint": "biome lint .",
    "check": "biome check ."
  }
}
```

#### Dependencies

```json
{
  "dependencies": {
    "convex": "^1.0.0",
    "better-auth": "^1.0.0"
  },
  "devDependencies": {
    "@types/node": "^22.0.0"
  }
}
```

#### Convex functions

Define queries, mutations, and actions in `packages/backend/convex/`:

```
convex/
  schema.ts            # Data models
  auth.config.ts       # Better auth config
  users.ts             # User-related functions
  posts.ts             # Post-related functions
```

Example query:

```ts
import { query } from "./_generated/server";

export const list = query({
  args: {},
  handler: async (ctx) => {
    return await ctx.db.query("posts").order("desc").collect();
  },
});
```

### packages/ui (shadcn/ui)

#### package.json

```json
{
  "name": "@your-org/ui",
  "type": "module",
  "exports": {
    ".": "./src/index.ts",
    "./components/*": "./src/components/*",
    "./lib/*": "./src/lib/*",
    "./styles.css": "./src/styles.css"
  },
  "dependencies": {
    "react": "^19.0.0",
    "@radix-ui/react-slot": "^1.0.0",
    "@radix-ui/react-dialog": "^1.0.0",
    "class-variance-authority": "^0.7.0",
    "clsx": "^2.0.0",
    "tailwind-merge": "^2.0.0",
    "lucide-react": "^0.400.0",
    "tw-animate-css": "^1.0.0"
  },
  "devDependencies": {
    "tailwindcss": "^4.0.0"
  }
}
```

#### Adding shadcn/ui components

Install shadcn CLI in the UI package:

```bash
cd packages/ui
bunx shadcn@latest init
```

Then add components:

```bash
bunx shadcn@latest add button
bunx shadcn@latest add card
bunx shadcn@latest add dialog
```

#### Central Tailwind CSS

In `packages/ui/src/styles.css`:

```css
@import "tailwindcss";

@theme {
  --color-primary: oklch(0.65 0.25 250);
  --color-secondary: oklch(0.7 0.2 320);
}
```

Component exports in `packages/ui/src/index.ts`:

```ts
export { Button } from "./components/ui/button";
export { Card, CardHeader, CardContent } from "./components/ui/card";
export { cn } from "./lib/utils";
export * from "./styles.css";
```

## Styling Architecture

- **Tailwind CSS entry**: `apps/web/src/styles.css` imports tailwind, defines `@source` globs, then imports `@your-org/ui/styles.css`
- **Shared styles**: Design tokens and base styles live in `packages/ui/src/styles.css`
- **Component styling**: Shared UI components use Tailwind classes; Tailwind scans `packages/ui/src/**/*` via the `@source` directive in the web app's CSS

## Deployment

### tools/deploy-preview.sh

```bash
#!/usr/bin/env bash
set -euo pipefail

bun run build
bunx wrangler pages deploy dist --project-name=your-app-preview --branch=preview
```

### tools/deploy-prod.sh

```bash
#!/usr/bin/env bash
set -euo pipefail

bun run build
bunx wrangler pages deploy dist --project-name=your-app
```

Make scripts executable:

```bash
chmod +x tools/deploy-preview.sh tools/deploy-prod.sh
```

## Environment Variables

Create `.env.local` in root:

```
# Convex
VITE_CONVEX_URL=https://your-deployment.convex.cloud
VITE_CONVEX_SITE_URL=http://localhost:3000
CONVEX_DEPLOYMENT=your-deployment-name

# Auth (if using BetterAuth)
AUTH_SECRET=your-auth-secret
AUTH_URL=http://localhost:3000

# Email (if using Resend)
RESEND_API_KEY=re_*
```

## Common Commands

### Development

```bash
# Start all dev servers
bun dev

# Start specific workspace
bun run dev --filter=@your-org/web
```

### Building

```bash
# Build all packages and apps
bun run build

# Build specific workspace
bun run build --filter=@your-org/web
```

### Code Quality

```bash
# Format all files
bun run format

# Lint all files
bun run lint

# Run all checks
bun run check

# Type generation (Convex, Wrangler)
bun run typegen
```

### Deployment

```bash
# Deploy to preview
bun run deploy:preview

# Deploy to production
bun run deploy:prod
```

## Type Generation

Run type generation commands:

```bash
# Generate Convex types
cd packages/backend && bun run convex dev

# Generate Cloudflare Workers types
cd apps/web && bun run typegen
```

## Tooling Preferences

- **Package manager**: Bun (use `bun install`, `bun run`, `bunx` for one-off CLIs)
- **Task runner**: Turborepo (coordinated builds, caching, filtering)
- **Formatter/Linter**: Biome (repo-wide consistency)
- **Icons**: lucide-react
- **Styles**: Tailwind CSS v4 via Vite plugin
