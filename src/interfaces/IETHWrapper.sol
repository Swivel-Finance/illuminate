// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.20;

interface IETHWrapper {
    function swap(
        address from,
        address to,
        address fromToken,
        address toToken,
        uint256 amount,
        uint256 minimum
    ) external returns (uint256, uint256);
}
