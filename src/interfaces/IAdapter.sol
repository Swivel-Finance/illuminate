// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.20;

interface IAdapter {
    function lend(bytes calldata) external returns (uint256, uint256);
}
