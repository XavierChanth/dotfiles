---
name: webdev
description: A set of resources for building web based applications and the default architectural preferences that should be mmade for projects
---

# React Content UI

## Overview
Create content-forward React components with Tailwind styling and shadcn/ui building blocks. Keep scope to frontend UI only, type props, and provide a fallback data object for review. Use the subresources below to branch into Convex data, TanStack integration, or auth when the request requires it.

## Tooling preferences
- Prefer Bun for installs, scripts, and CLIs unless the user explicitly requests npm/pnpm/yarn.
- Prefer `bunx` over `npx` for one-off CLIs.
- Prefer lucide icons via `lucide-react` when icons are needed.

## Workflow (choose the right subresource)

### 1) Confirm UI-only scope
- Do not implement backend or API routes.
- If data is needed, mock it with a `const` object that can be replaced later.

### 2) Pick the relevant subresource(s)
- **Content UI (Tailwind + shadcn/ui):** See `skills/webdev/references/content-ui.md`.
- **Monorepo (Bun + Turborepo):** See `skills/webdev/references/monorepo-bun-turbo.md`.
- **Convex data (queries, mutations, actions):** See `skills/webdev/references/convex-queries-mutations-actions.md`.
- **Billing (Autumn + Convex):** See `skills/webdev/references/autumn-billing.md`.
- **Routing & SSR (TanStack Start):** See `skills/webdev/references/routing-ssr.md`.
- **Auth (better-auth / better-auth-ui):** See `skills/webdev/references/better-auth.md`.
- **Deployment (Cloudflare Workers):** See `skills/webdev/references/cloudflare-deploy.md`.

### 3) Type props for new components
- Define a props interface/type for any new component.
- Prefer explicit types (no `any`); keep types close to the component.

### 4) Provide fallback content data
- Create a `const` object with realistic placeholder copy (titles, paragraphs, lists, CTAs).
- Pass the fallback data into the component as props.
- Keep the object easy to scan so the human can review UI copy quickly.

### 5) Keep the output focused on content UI
- Use semantic HTML within React (headings, lists, sections, articles).
- Prioritize readability: balanced line lengths, clear hierarchy, and mobile-first layout.

## Implementation pattern

Use a minimal pattern like this when building new content components:

```tsx
// Example only; adapt to the project structure.
type Feature = {
  title: string
  description: string
}

type ContentSectionProps = {
  heading: string
  subheading?: string
  features: Feature[]
  ctaLabel?: string
}

const fallbackContent: ContentSectionProps = {
  heading: "Ship content faster",
  subheading: "Reusable sections built with shadcn/ui and Tailwind.",
  features: [
    { title: "Consistent layout", description: "Composable cards and grids." },
    { title: "Typed props", description: "Clear data contracts for review." },
  ],
  ctaLabel: "View components",
}

export function ContentSection(props: ContentSectionProps) {
  const { heading, subheading, features, ctaLabel } = props
  // Use shadcn/ui components + Tailwind classes here
}
```

## Output expectations
- Provide only frontend changes.
- Use shadcn/ui components when available; fall back to simple Tailwind-marked elements when not.
- Include the fallback data object by default unless the user supplies data.
- Ask for clarification only if the UI requirements are ambiguous or conflicting.

## References
Use the subresources above to guide implementation details. Avoid loading all references at once; pick only the ones that match the user request.
