# Convex Core (Queries / Mutations / Actions)

Use this when the request involves data modeling or server logic with Convex. Focus on queries, mutations, and actions.

## Selection guide
- **Query**: Read-only data access. Use for listing, searching, or fetching by id.
- **Mutation**: Write operations. Use for create/update/delete, and any state changes.
- **Action**: Long-running or external side effects (calling third-party APIs, heavy computation). Actions can call queries/mutations.

## Workflow
1. Identify the data model and required indexes.
2. Implement queries first to shape the read model.
3. Implement mutations to match UI flows.
4. Use actions only when side effects or long-running work are required.

## Client integration
- Prefer official Convex client integrations when wiring UI data flows.
- Keep client hooks close to the components or routes that consume the data.

## Output expectations
- Keep query/mutation/action function signatures explicit and readable.
- Prefer small functions with clear input validation.
- When unsure about schema or rules, ask for the existing Convex schema and function layout.

## Tooling
- Prefer Bun for installs, scripts, and CLIs unless the user explicitly requests npm/pnpm/yarn.
- Prefer `bunx` over `npx` for one-off CLIs.

## Docs (URLs)
Provide URLs in code blocks (no inline links).

```text
https://docs.convex.dev/
```
