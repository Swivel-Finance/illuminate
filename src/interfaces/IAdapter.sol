// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.20;

interface IAdapter {
    function underlying(address pt) external view returns (address);
    function maturity(address pt) external view returns (uint256);
    function protocol() external view returns (uint8);
    function mint(address underlying_, uint256 maturity_, address targetToken, uint256 amount) external returns (uint256);
    function lend(address underlying_, uint256 maturity_, uint256[] calldata amount, bool internalBalance, bytes calldata d) external payable returns (uint256, uint256, uint256);
    function redeem(address underlying_, uint256 maturity_, uint256 amount, bool internalBalance, bytes calldata d) external returns (uint256, uint256);
}
