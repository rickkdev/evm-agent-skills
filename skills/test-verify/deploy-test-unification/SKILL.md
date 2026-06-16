---
name: Foundry Deploy/Test Unification
description: Use when Foundry tests and deployment scripts should share construction logic to avoid drift.
version: 0.1.0
status: draft
tags:
  - foundry
  - testing
  - deployment
  - forge-script
---

# foundry deploy/test unification

## status

draft. this skill is operational guidance for milestone 1. it is not a production deployment checklist, audit process, or post-deploy verification process.

## core rule

tests and scripts must share construction logic.

if a contract is deployed by a script with constructor arguments, initial owners, linked helper contracts, initial parameters, or default dependencies, tests must construct it through the same deploy helper path. do not maintain a second hand-written test setup that silently drifts from the real deploy path.

## when to use

use this skill when:

- a Foundry project has both `script/` deployment code and `test/` setup code.
- tests directly call `new Contract(...)` while scripts call a different constructor path.
- constructor arguments, owner/admin addresses, initial dependencies, salts, or config values are easy to mismatch.
- an agent is adding tests for a contract that already has a deploy script.
- an agent is adding a deploy script for a contract that already has tests.
- test failures or deployment failures suggest setup drift rather than contract behavior.

## when not to use

do not use this skill as a substitute for:

- multichain deployment orchestration.
- private key, rpc url, signer, or environment management.
- post-deploy verification, explorer verification, monitoring, or runbook checks.
- audit claims, production-readiness claims, or upgrade safety review.
- complex integration fixtures where deployment order is intentionally varied across tests.

for those cases, keep this skill limited to the construction seam and add separate deployment/ops guidance.

## recommended Foundry layout

```text
foundry.toml
src/
  Contract.sol
script/
  DeployContract.s.sol      # shared construction helper
  BroadcastDeploy.s.sol     # optional Script wrapper for broadcast/env concerns
test/
  Contract.t.sol            # setUp calls the shared construction helper
```

for larger systems:

```text
src/
  Core.sol
  dependencies/...
script/
  DeploySystem.s.sol        # deploy(config) returns deployed contract addresses
  DeployConfig.sol          # optional typed config; no private keys in source
test/
  Core.t.sol                # uses DeploySystem.deploy(testConfig)
  integration/...
```

## exact workflow for agents

1. inventory construction paths
   - search `test/` for direct `new Contract(...)` calls.
   - search `script/` for deploy scripts and constructor arguments.
   - list every constructor argument, initial owner/admin, dependency address, and initial value.

2. choose the shared construction seam
   - prefer a small deploy helper function in `script/DeployX.s.sol`.
   - make it return the deployed contract, or a typed struct for multi-contract systems.
   - pass explicit config values as parameters or a config struct.
   - keep signer/rpc/env lookup outside the shared construction logic.
   - separate the construction helper from any optional `forge-std/Script` broadcast wrapper.

3. move construction into the deploy helper
   - the helper is the only place that calls `new X(...)` for the standard deployment path.
   - tests can instantiate or inherit the helper and call the same helper from `setUp()`.
   - if the repo uses real broadcast scripts, put `run()` and `vm.startBroadcast()` in a thin wrapper that calls the same helper.

4. update tests
   - replace duplicate constructor setup with the deploy helper call.
   - assert the deployed defaults that matter: owner, dependencies, initial accounting, limits.
   - keep tests free to deploy alternate fixtures only when a test explicitly needs a non-standard setup.

5. verify drift is removed
   - grep for remaining duplicate `new X(...)` calls in tests.
   - run `forge build`.
   - run `forge test`.
   - if the script has a `run()` path, run the safest local script command available for the repo.

6. document exceptions
   - if a test intentionally bypasses the deploy helper, add a short comment explaining why.
   - do not leave unexplained parallel construction paths.

## copyable minimal pattern

plain Solidity deploy helper, no `forge-std` required:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {BalanceSheet} from "../src/BalanceSheet.sol";

contract DeployBalanceSheet {
    uint256 internal constant DEFAULT_MINIMUM_DEPOSIT = 0.01 ether;

    function deploy(address initialOwner) public returns (BalanceSheet sheet) {
        sheet = deploy(initialOwner, DEFAULT_MINIMUM_DEPOSIT);
    }

    function deploy(address initialOwner, uint256 minimumDeposit) public returns (BalanceSheet sheet) {
        sheet = new BalanceSheet(initialOwner, minimumDeposit);
    }
}
```

test setup uses the same helper:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {BalanceSheet} from "../src/BalanceSheet.sol";
import {DeployBalanceSheet} from "../script/DeployBalanceSheet.s.sol";

contract BalanceSheetTest {
    BalanceSheet internal sheet;
    DeployBalanceSheet internal deployer;

    function setUp() public {
        deployer = new DeployBalanceSheet();
        sheet = deployer.deploy(address(this));
    }
}
```

for a multi-contract deployment, return a typed struct:

```solidity
struct Deployment {
    Token token;
    Vault vault;
}

function deploy(address owner) public returns (Deployment memory d) {
    d.token = new Token(owner);
    d.vault = new Vault(address(d.token), owner);
}
```

optional broadcast wrapper pattern:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {BalanceSheet} from "../src/BalanceSheet.sol";
import {DeployBalanceSheet} from "./DeployBalanceSheet.s.sol";

contract BroadcastDeployBalanceSheet is Script, DeployBalanceSheet {
    function run() external returns (BalanceSheet sheet) {
        vm.startBroadcast();
        sheet = deploy(msg.sender);
        vm.stopBroadcast();
    }
}
```

keep this wrapper thin. tests should still target the shared `deploy(...)` helper, not duplicate constructor logic.

## anti-patterns

avoid:

- `test/Contract.t.sol` calling `new Contract(...)` with copied constructor arguments while `script/DeployContract.s.sol` has different values.
- tests using magic owners or dependency addresses not present in deployment code.
- deploy scripts reading environment variables inside the only deploy function, making tests depend on shell state.
- tests that pass because they deploy a simplified fixture that production never uses.
- comments such as "same as deploy script" without actually sharing code.
- claiming that shared construction proves a deployment is safe, audited, or production-ready.

## verification commands

from the repo root:

```sh
python3 -m json.tool prd.json >/tmp/prd.json
python3 -m json.tool skills/manifest.json >/tmp/manifest.json
```

from a Foundry example or project root:

```sh
forge build
forge test
```

for this repository's milestone 1 example:

```sh
cd examples/foundry-deploy-test-unification
forge build
forge test
```

## limitations in v0

- no multichain deployment operations.
- no env var, private key, signer, or rpc management.
- no explorer or post-deploy verification workflow.
- no claim that this produces audited or production-safe deployments.
- no external pinned references yet; the local example is the executable reference for this draft.

## local executable reference

see `examples/foundry-deploy-test-unification/` and `references/foundry-deploy-test-unification.md`.
