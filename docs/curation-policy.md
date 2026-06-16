# Reference curation policy

This repo uses references to teach operational patterns, not to collect links. A reference is included only when it helps an agent make a better implementation or verification decision.

## Inclusion criteria

Use references that are:

- Audited or production-proven: prefer code that has been reviewed, deployed, and maintained in real protocol contexts.
- Readable: source layout, naming, and tests should be understandable enough for an agent to inspect and adapt safely.
- Strongly tested: prefer references with meaningful unit, fuzz, integration, or invariant tests.
- License-compatible: do not copy or adapt code in ways that conflict with the upstream license.
- Exact: link to specific files, not only repository roots.
- Pinned when possible: prefer commit-SHA links over branch links so future readers see the same code.
- Explained: every reference must state why it is included and what pattern it demonstrates.

## Initial candidates

Initial reference candidates for future authored skills:

- OpenZeppelin: primitives and standard Solidity patterns.
- Sablier: streaming protocol structure and advanced testing references.
- Aave GHO: facilitator and stablecoin architecture references.
- Hifi V3: branching-tree and testing methodology references.

These are candidates only. Do not add a reference file until the exact upstream files, license context, and reason for inclusion are checked.

## Reference format

When adding a reference, include:

1. Name of the upstream project.
2. Exact file URL, preferably pinned to a commit SHA.
3. License note.
4. Why this file is included.
5. What the agent should learn from it.
6. What the agent must not blindly copy.

## Rejection rules

Do not include references that are:

- Repo-root links without exact files.
- Blog posts used as substitutes for source or tests.
- Code snippets with unclear license terms.
- Unreviewed examples presented as production patterns.
- Large copied codebases instead of small quoted excerpts or links.
- Security claims without a review trail or explicit uncertainty.
