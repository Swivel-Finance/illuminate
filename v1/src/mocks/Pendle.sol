// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import 'src/mocks/ERC20.sol';
import 'src/lib/Pendle.sol' as plib;

contract Pendle {
    struct SwapExactTokenForPtArgs {
        address receiver;
        address market;
        uint256 minimum;
        plib.Pendle.ApproxParams guess;
        plib.Pendle.TokenInput input;
    }

    address pt;
    uint256 swapFor;
    mapping(address => SwapExactTokenForPtArgs)
        public swapExactTokenForPtCalled;

    constructor(address p) {
        pt = p;
    }

    function swapExactTokensForTokensFor(uint256 a) external {
        swapFor = a;
    }

    function swapExactTokenForPt(
        address r,
        address m,
        uint256 minimum,
        plib.Pendle.ApproxParams calldata g,
        plib.Pendle.TokenInput calldata t
    ) external returns (uint256, uint256) {
        swapExactTokenForPtCalled[r] = SwapExactTokenForPtArgs(
            r,
            m,
            minimum,
            g,
            t
        );
        uint256 starting = ERC20(pt).balanceOf(address(0));
        ERC20(pt).balanceOfReturns(starting + swapFor);

        return (swapFor, 0);
    }
}
