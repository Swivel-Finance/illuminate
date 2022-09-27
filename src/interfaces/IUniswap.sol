// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.16;

interface IUniswap {
    function swapExactTokensForTokens(
        uint256,
        uint256,
        address[] calldata,
        address,
        uint256
    ) external returns (uint256[] memory amounts);
}
