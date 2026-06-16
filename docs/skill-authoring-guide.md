# Skill authoring guide

Skills are operational instructions for AI agents working in EVM repositories. They should be narrow enough to load for one task and concrete enough to drive code changes, tests, and verification.

## Format

Each skill uses an Anthropic-style `SKILL.md` file:

```markdown
---
name: Short Skill Name
description: One sentence describing when the skill should be used.
version: 0.0.0
status: draft/skeleton
tags:
  - foundry
  - solidity
---

# Short Skill Name

## Status

Draft skeleton. TODO: author full skill content.

## When to use

...

## When not to use

...

## Agent workflow

...

## Verification commands

...

## References

...
```

Required frontmatter fields:

- `name`: human-readable skill name.
- `description`: task trigger for loading the skill.
- `version`: semantic version for the skill content.
- `status`: use `draft/skeleton` until authored and reviewed.
- `tags`: stable tags for discovery.

## When to use a skill

Use a skill when the agent needs a repeatable method, not a generic explanation. Good skill scopes include:

- Designing Solidity module boundaries.
- Deriving Foundry tests from a behavior spec.
- Sharing deploy construction logic between scripts and tests.
- Choosing fuzz bounds from constraints.
- Structuring invariant handlers and state stores.

Do not create skills for basic definitions, broad essays, or general Ethereum background.

## Authoring workflow

1. Define the task the skill should trigger on.
2. State when not to use it.
3. Write a step-by-step agent workflow.
4. Add minimal examples only where they clarify an action.
5. Add verification commands and expected outcomes.
6. Add exact reference links only after curation.
7. Mark unresolved content with TODOs instead of pretending the skill is complete.
8. Run validation commands before committing.

## Verification commands

Minimum repository-level checks:

```sh
python3 -m json.tool prd.json >/tmp/prd.json
python3 -m json.tool skills/manifest.json >/tmp/manifest.json
git status --short
```

For authored Foundry examples, include skill-specific commands such as:

```sh
forge build
forge test
```

Only include Foundry commands when an example project exists and the expected working directory is clear.

## Reference-link discipline

References must use exact file links. Prefer URLs pinned to commit SHAs. Do not link only to a repository root. Do not invent links. If a reference has not been selected yet, write `TODO: add curated exact references`.

Every reference entry should explain:

- Why it is included.
- Which file or test demonstrates the pattern.
- What license applies.
- What not to copy blindly.

## Anti-patterns

Avoid:

- Long essays without executable instructions.
- Generic Solidity tips without task context.
- Unpinned repo-root links.
- Security claims without explicit review.
- Claiming draft content is production-ready.
- Copying large external codebases into this repo.
- Examples that cannot be verified.
- Vague instructions like "write good tests" without concrete checks.
