# foundry deploy/test unification references

status: draft

there are no external pinned references for this skill yet.

current executable reference:

- local example: `examples/foundry-deploy-test-unification/`
- shared construction helper: `examples/foundry-deploy-test-unification/script/DeployBalanceSheet.s.sol`
- test using same construction path from `setUp()`: `examples/foundry-deploy-test-unification/test/BalanceSheet.t.sol`

note: the local example intentionally avoids `forge-std` so it can demonstrate the construction seam without external dependencies. real broadcast scripts should wrap the shared helper in a thin `forge-std/Script` contract instead of putting signer/rpc/env logic into the helper itself.

reference rule for future updates:

- only add external links when they are exact file urls, preferably pinned to a commit sha.
- do not add broad repository homepages as references.
- do not use references to imply audit, production safety, or deployment correctness.
