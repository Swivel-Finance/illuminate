// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

contract Lender {
    struct ApproveArgs {
        address element;
        address apwine;
        address notional;
    }

    mapping(address => ApproveArgs) public approveCalled;

    function approve(
        address u,
        address e,
        address a,
        address n
    ) external {
        approveCalled[u] = ApproveArgs(e, a, n);
    }
}
