// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import 'src/mocks/ERC20.sol';

contract Pendle {
    struct SwapExactTokensForTokensArgs {
        uint256 amount;
        uint256 minimumBought;
        address[] path;
        uint256 deadline;
    }

    struct RedeemAfterExpiryArgs {
        bytes32 forgeId;
        uint256 maturity;
    }

    address pt;
    uint256 swapFor;
    mapping(address => SwapExactTokensForTokensArgs)
        public swapExactTokensForTokensCalled;
    mapping(address => RedeemAfterExpiryArgs) public redeemAfterExpiryCalled;

    constructor(address p) {
        pt = p;
    }

    function swapExactTokensForTokensFor(uint256 a) external {
        swapFor = a;
    }

    function swapExactTokensForTokens(
        uint256 a,
        uint256 m,
        address[] calldata p,
        address t,
        uint256 d
    ) external returns (uint256[] memory) {
        swapExactTokensForTokensCalled[t] = SwapExactTokensForTokensArgs(
            a,
            m,
            p,
            d
        );
        uint256 starting = ERC20(pt).balanceOf(address(0));
        ERC20(pt).balanceOfReturns(starting + swapFor);

        uint256[] memory amounts = new uint256[](3);
        amounts[2] = swapFor;

        return amounts;
    }

    function redeemAfterExpiry(
        bytes32 i,
        address u,
        uint256 m
    ) external {
        redeemAfterExpiryCalled[u] = RedeemAfterExpiryArgs(i, m);
    }
}
