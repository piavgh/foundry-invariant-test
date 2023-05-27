// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/Safe.sol";

contract InvariantSafeTest is Test {
    Safe safe;

    function setUp() external {
        safe = new Safe();
        vm.deal(address(safe), 100 ether); // Sets an address' balance, (who, newBalance)
    }

    function test_withdrawDepositedBalance() external payable {
        safe.deposit{value: 0 ether}();
        uint256 balanceBefore = safe.balance(address(this));
        assertEq(balanceBefore, 0 ether);
        safe.withdraw();
        uint256 balanceAfter = safe.balance(address(this));
        assertEq(balanceBefore, balanceAfter);
    }

    function invariant_withdrawDepositedBalance() external payable {
        safe.deposit{value: 1 ether}();
        uint256 balanceBefore = safe.balance(address(this));
        assertEq(balanceBefore, 1 ether);
        safe.withdraw();
        uint256 balanceAfter = safe.balance(address(this));
        assertGt(balanceBefore, balanceAfter);
    }

    receive() external payable {}
}
