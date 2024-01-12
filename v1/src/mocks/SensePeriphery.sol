// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.16;

import 'src/mocks/ERC20.sol';

contract SensePeriphery {
    struct SwapUnderlyingForPTsArg {
        uint256 maturity;
        uint256 lent;
        uint256 minReturn;
    }

    ERC20 pt;

    uint256 private swapUnderlyingForPTsReturn;
    address private dividerReturn;

    mapping(address => SwapUnderlyingForPTsArg)
        public swapUnderlyingForPTsCalled;

    constructor(address p) {
        pt = ERC20(p);
    }

    function swapUnderlyingForPTsReturns(uint256 s) external {
        swapUnderlyingForPTsReturn = s;
    }

    function swapUnderlyingForPTs(
        address a,
        uint256 s,
        uint256 l,
        uint256 m
    ) external returns (uint256) {
        pt.balanceOfReturns(
            swapUnderlyingForPTsReturn + pt.balanceOf(address(0))
        );
        swapUnderlyingForPTsCalled[a] = SwapUnderlyingForPTsArg(s, l, m);
        return swapUnderlyingForPTsReturn;
    }

    function dividerReturns(address d) external {
        dividerReturn = d;
    }

    function divider() external view returns (address) {
        return dividerReturn;
    }
}
