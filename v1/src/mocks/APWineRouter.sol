// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import 'src/mocks/ERC20.sol';

contract APWineRouter {
    struct SwapExactAmountInArg {
        address principalToken;
        uint256[] pairPath;
        uint256[] tokenPath;
        uint256 lent;
        uint256 minReturn;
        uint256 deadline;
        address refCode;
    }

    ERC20 pt;

    uint256 private swapExactAmountInReturn;

    mapping(address => SwapExactAmountInArg) public swapExactAmountInCalled;

    constructor(address p) {
        pt = ERC20(p);
    }

    function swapExactAmountInReturns(uint256 s) external {
        swapExactAmountInReturn = s;
    }

    function swapExactAmountIn(
        address principalToken,
        uint256[] calldata pairPath,
        uint256[] calldata tokenPath,
        uint256 lent,
        uint256 minReturn,
        address recipient,
        uint256 deadline,
        address refCode
    ) external returns (uint256) {
        pt.balanceOfReturns(pt.balanceOf(address(0)) + swapExactAmountInReturn);
        swapExactAmountInCalled[recipient] = SwapExactAmountInArg(
            principalToken,
            pairPath,
            tokenPath,
            lent,
            minReturn,
            deadline,
            refCode
        );
        return swapExactAmountInReturn;
    }
}
