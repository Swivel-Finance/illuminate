// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.4;

interface ISenseDivider {
    function redeem(address adapter, uint256 maturity, uint256 uBal) external returns (uint256 tBal);
}