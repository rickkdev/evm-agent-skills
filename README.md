# evm-agent-skills

Deep, operational skills for AI agents building production-grade EVM protocols.

This repo starts with Solidity + Foundry methodology: deploy/test unification, branching-tree specs, fuzz bounds, invariant handlers, and module-structure guidance.

The goal is not a link list or toy scaffold. The goal is reusable agent knowledge that can later be consumed by an agentic Solidity CLI.

## Current status

Milestone 1 draft is in progress. The deploy/test unification skill now has operational draft guidance and a minimal executable Foundry example. Other skill files remain draft skeletons, not production-ready guidance.

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
    foundry.toml
    src/BalanceSheet.sol
    script/DeployBalanceSheet.s.sol
    test/BalanceSheet.t.sol
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

## Milestone 1

Milestone 1 is the deploy/test unification skill draft:

- `skills/test-verify/deploy-test-unification/SKILL.md` is authored beyond the skeleton.
- `skills/test-verify/deploy-test-unification/references/foundry-deploy-test-unification.md` records the local executable reference and notes that no external pinned references are included yet.
- `examples/foundry-deploy-test-unification/` demonstrates shared deploy construction logic.
- Validate with `forge build` and `forge test` when Foundry is installed.
