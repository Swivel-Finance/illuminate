// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.20;

interface IAdapter {
    function lend(address underlying_, uint256 maturity_, uint256[] calldata, bool internalBalance, bytes calldata d) external returns (uint256, uint256, uint256);
    function underlying(address pt) external view returns (address);
    function maturity(address pt) external view returns (uint256);
    function redeem(uint256 amount, bool internalBalance, bytes calldata d) external returns (uint256, uint256);
}
