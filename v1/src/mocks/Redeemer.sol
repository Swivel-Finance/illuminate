// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

contract Redeemer {
    address public approveCalled;

    function approve(address p) external {
        approveCalled = p;
    }
}
