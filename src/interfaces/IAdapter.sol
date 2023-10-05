// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.20;

interface IAdapter {
    function lend(uint256[] calldata, bool internalBalance, bytes calldata) external returns (uint256, uint256);
    function underlying(address pt) external view returns (address);
}
