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
    mapping(uint8 => bool) public pausedCalled;

    bool private illuminatePausedReturn;
    bool private pausedReturn;

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

    function illuminatePausedReturns(bool a) external {
        illuminatePausedReturn = a;
    }

    function halted() external view returns (bool) {
        return illuminatePausedReturn;
    }

    function pausedReturns(bool a) external {
        pausedReturn = a;
    }

    function paused(uint8 p) external {
        pausedCalled[p] = true;
    }
}
