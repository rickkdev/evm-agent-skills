// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {BalanceSheet} from "../src/BalanceSheet.sol";
import {DeployBalanceSheet} from "../script/DeployBalanceSheet.s.sol";

contract BalanceSheetTest {
    BalanceSheet internal sheet;
    DeployBalanceSheet internal deployer;

    receive() external payable {}

    function setUp() public {
        deployer = new DeployBalanceSheet();
        sheet = deployer.deploy(address(this));
    }

    function testDeployUsesRequestedOwnerAndDefaults() public view {
        assertEq(sheet.owner(), address(this));
        assertEq(sheet.minimumDeposit(), 0.01 ether);
        assertEq(sheet.totalDeposits(), 0);
    }

    function testDepositAndWithdraw() public {
        sheet.deposit{value: 1 ether}();

        assertEq(sheet.balanceOf(address(this)), 1 ether);
        assertEq(sheet.totalDeposits(), 1 ether);

        uint256 beforeBalance = address(this).balance;
        sheet.withdraw(0.4 ether);

        assertEq(sheet.balanceOf(address(this)), 0.6 ether);
        assertEq(sheet.totalDeposits(), 0.6 ether);
        assertEq(address(this).balance, beforeBalance + 0.4 ether);
    }

    function testCanOverrideDeploymentConfigThroughSharedHelper() public {
        BalanceSheet customSheet = deployer.deploy(address(this), 0.5 ether);

        assertEq(customSheet.owner(), address(this));
        assertEq(customSheet.minimumDeposit(), 0.5 ether);
    }

    function testSmallDepositRevertsWithExpectedSelector() public {
        try sheet.deposit{value: 1 wei}() {
            revert ExpectedRevert();
        } catch (bytes memory reason) {
            assertSelector(reason, BalanceSheet.DepositTooSmall.selector);
        }
    }

    function testInsufficientWithdrawRevertsWithExpectedSelector() public {
        try sheet.withdraw(1 wei) {
            revert ExpectedRevert();
        } catch (bytes memory reason) {
            assertSelector(reason, BalanceSheet.InsufficientBalance.selector);
        }
    }

    function assertEq(uint256 actual, uint256 expected) internal pure {
        if (actual != expected) revert AssertionFailedUint(actual, expected);
    }

    function assertEq(address actual, address expected) internal pure {
        if (actual != expected) revert AssertionFailedAddress(actual, expected);
    }

    function assertSelector(bytes memory revertData, bytes4 expected) internal pure {
        if (revertData.length < 4) revert MissingRevertSelector(revertData);

        bytes4 actual;
        assembly {
            actual := mload(add(revertData, 0x20))
        }

        if (actual != expected) revert AssertionFailedSelector(actual, expected);
    }
}

error ExpectedRevert();
error MissingRevertSelector(bytes revertData);
error AssertionFailedUint(uint256 actual, uint256 expected);
error AssertionFailedAddress(address actual, address expected);
error AssertionFailedSelector(bytes4 actual, bytes4 expected);
