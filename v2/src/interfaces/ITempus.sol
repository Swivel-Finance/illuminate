// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.20;

interface ITempus {
    function depositAndFix(address, uint256, bool, uint256, uint256) external;

    function redeemToBacking(address, uint256, uint256, address) external;
}
