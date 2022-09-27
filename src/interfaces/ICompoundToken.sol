// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.16;

interface ICompoundToken {
    function redeem(uint256) external returns (uint256);

    function exchangeRateCurrent() external returns (uint256);
}
