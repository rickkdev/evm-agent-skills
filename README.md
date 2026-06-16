# evm-agent-skills

Deep, operational skills for AI agents building production-grade EVM protocols.

This repo starts with Solidity + Foundry methodology: deploy/test unification, branching-tree specs, fuzz bounds, invariant handlers, and module-structure guidance.

The goal is not a link list or toy scaffold. The goal is reusable agent knowledge that can later be consumed by an agentic Solidity CLI.

## Current status

Milestone 0 foundation is complete. The repository contains the v0 package skeleton, manifest, authoring docs, and placeholder skill files. The skill files are drafts, not production-ready guidance.

## Repository structure

```text
README.md
prd.json
docs/
  curation-policy.md
  skill-authoring-guide.md
skills/
  manifest.json
  write-solidity/
    module-structure/
      SKILL.md
      references/
    naming-and-natspec/
      SKILL.md
    security-primitives-checklist/
      SKILL.md
  test-verify/
    deploy-test-unification/
      SKILL.md
      references/
    branching-tree-technique/
      SKILL.md
      references/
    constraint-derived-fuzz-bounds/
      SKILL.md
    invariant-handler-store-pattern/
      SKILL.md
examples/
  foundry-deploy-test-unification/
  foundry-branching-tree/
```

## Skill package model

- `skills/manifest.json` is the package index for future CLI or agent loading.
- Each skill has a stable id, path, description, tags, version, and status.
- Each `SKILL.md` uses YAML frontmatter and an operational structure.
- References must be exact file links, preferably pinned to commit SHAs.
- Draft skeletons include TODO sections until the full skill is authored and reviewed.

## Validation

Run these checks after editing package metadata:

```sh
python3 -m json.tool prd.json >/tmp/prd.json
python3 -m json.tool skills/manifest.json >/tmp/manifest.json
git status --short
```

## Next milestone

Milestone 1 is the deploy/test unification skill:

- Author `skills/test-verify/deploy-test-unification/SKILL.md` beyond the skeleton.
- Add at least one curated exact reference file.
- Add a minimal Foundry example demonstrating shared deploy construction logic.
- Verify the example with `forge build` and `forge test`.
