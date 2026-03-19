# JJ Semantic Label Heuristics

## Type Keywords

- `fix`: fix, bug, issue, crash, error, incorrect, wrong, hotfix, revert
- `feat`: add, support, implement, introduce, create, enable, allow
- `docs`: docs, readme, changelog, comment, document
- `test`: test, pytest, unittest, integration test, e2e, fixture
- `refactor`: refactor, cleanup, restructure, rename, simplify
- `perf`: perf, optimize, faster, speed, latency, throughput
- `build`: pyproject, uv.lock, setup.py, requirements, dependency, wheel, nuitka
- `ci`: github/workflows, pipeline, ci, actions, buildkite, azure-pipelines
- `style`: ruff format, black, isort, lint fix, whitespace, formatting
- `chore`: default fallback when signal is weak

## Scope Extraction

1. Prefer top-level directory from changed files.
2. Collapse nested package paths to stable scopes:
   - `packages/app/...` -> `app`
   - `packages/parser/...` -> `parser`
   - `drivers/x88_driver/...` -> `x88_driver`
3. Omit scope if no dominant area is visible.

## Confidence Guidelines

- `high`: direct keyword or file-pattern match.
- `medium`: weak keyword match or inferred from paths.
- `low`: fallback `chore` or ambiguous signal.
