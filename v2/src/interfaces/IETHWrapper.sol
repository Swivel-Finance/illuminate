// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.20;

interface IETHWrapper {
    function swap(
        address input,
        address output,
        uint256 amount,
        uint256 minimum
    ) external returns (uint256, uint256);
}
