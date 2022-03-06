// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.4;

interface INotionalRouter {
    function takefCash(uint32 maturity, uint128 fCashAmount, uint32 maxTime, uint128 minImpliedRate) external returns (uint128);
}