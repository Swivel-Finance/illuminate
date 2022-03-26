// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.4;

interface ISensePool {
    function swapUnderlyingForPTs(address adapter, uint256 maturity, uint256 uBal, uint256 minAccepted) external returns (uint256 ptBal);
}