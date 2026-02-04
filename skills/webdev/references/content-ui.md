# Content UI (Tailwind + shadcn/ui)

Use this when the request is primarily about layout, typography, components, or content presentation.

## Core guidance
- Prefer shadcn/ui components for layout primitives, cards, accordions, tabs, tables, buttons, and forms.
- Use Tailwind utilities for spacing, typography, and responsive layout.
- If a needed shadcn/ui component is missing, add it with `bunx shadcn@latest add <component>`.
- Avoid adding new libraries unless the user explicitly asks (TanStack Router is allowed).
- Prefer lucide icons via `lucide-react` when icons are needed.

## Tooling
- Prefer Bun for installs, scripts, and CLIs unless the user explicitly requests npm/pnpm/yarn.
- Prefer `bunx` over `npx` for one-off CLIs.

## Docs (URLs)
Provide URLs in code blocks (no inline links).

```text
https://ui.shadcn.com/docs
https://tailwindcss.com/docs
https://lucide.dev
```
