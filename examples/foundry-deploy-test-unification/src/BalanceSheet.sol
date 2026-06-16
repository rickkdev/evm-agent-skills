// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract BalanceSheet {
    error ZeroOwner();
    error ZeroMinimumDeposit();
    error DepositTooSmall(uint256 amount, uint256 minimum);
    error InsufficientBalance(address account, uint256 available, uint256 requested);
    error TransferFailed();

    address public immutable owner;
    uint256 public immutable minimumDeposit;
    uint256 public totalDeposits;

    mapping(address account => uint256 amount) public balanceOf;

    constructor(address initialOwner, uint256 initialMinimumDeposit) {
        if (initialOwner == address(0)) revert ZeroOwner();
        if (initialMinimumDeposit == 0) revert ZeroMinimumDeposit();

        owner = initialOwner;
        minimumDeposit = initialMinimumDeposit;
    }

    function deposit() external payable {
        if (msg.value < minimumDeposit) {
            revert DepositTooSmall(msg.value, minimumDeposit);
        }

        balanceOf[msg.sender] += msg.value;
        totalDeposits += msg.value;
    }

    function withdraw(uint256 amount) external {
        uint256 available = balanceOf[msg.sender];
        if (available < amount) revert InsufficientBalance(msg.sender, available, amount);

        balanceOf[msg.sender] = available - amount;
        totalDeposits -= amount;

        (bool success,) = msg.sender.call{value: amount}("");
        if (!success) revert TransferFailed();
    }
}
