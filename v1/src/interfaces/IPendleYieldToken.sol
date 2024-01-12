// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.16;

interface IPendleYieldToken {
    function redeemPY(address) external returns (uint256);
}
