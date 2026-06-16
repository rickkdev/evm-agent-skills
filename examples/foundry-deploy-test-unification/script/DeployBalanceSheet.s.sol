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
