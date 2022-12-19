// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

contract Lender {
    struct ApproveArgs {
        address apwine;
        address element;
        address notional;
        address sense;
    }

    mapping(address => ApproveArgs) public approveCalled;
    mapping(address => uint256) public transferFYTsCalled;
    mapping(address => uint256) public transferPremiumCalled;

    function approve(
        address u,
        address a,
        address e,
        address n,
        address p
    ) external {
        approveCalled[u] = ApproveArgs(a, e, n, p);
    }

    function transferFYTs(address f, uint256 a) external {
        transferFYTsCalled[f] = a;
    }

    function transferPremium(address u, uint256 m) external {
        transferPremiumCalled[u] = m;
    }
}
