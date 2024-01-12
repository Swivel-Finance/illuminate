// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.20;

interface IPendleYieldToken {
    function redeemPY(address) external returns (uint256);
}
