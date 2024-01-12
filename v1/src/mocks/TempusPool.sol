// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import 'src/interfaces/ITempusPool.sol';

contract TempusPool is ITempusPool {
    uint256 private maturityTimeReturn;
    address private backingTokenReturn;
    address private principalShareReturn;
    uint256 private currentInterfaceRateReturn;
    uint256 private initialInterestRateReturn;
    address private controllerReturn;

    function maturityTimeReturns(uint256 m) external {
        maturityTimeReturn = m;
    }

    function maturityTime() external view returns (uint256) {
        return maturityTimeReturn;
    }

    function backingTokenReturns(address b) external {
        backingTokenReturn = b;
    }

    function backingToken() external view returns (address) {
        return backingTokenReturn;
    }

    function principalShareReturns(address p) external {
        principalShareReturn = p;
    }

    function principalShare() external view returns (address) {
        return principalShareReturn;
    }

    function currentInterestRateReturns(uint256 c) external {
        currentInterfaceRateReturn = c;
    }

    function currentInterestRate() external view returns (uint256) {
        return currentInterfaceRateReturn;
    }

    function initialInterestRateReturns(uint256 i) external {
        initialInterestRateReturn = i;
    }

    function initialInterestRate() external view returns (uint256) {
        return initialInterestRateReturn;
    }

    function controllerReturns(address t) external {
        controllerReturn = t;
    }

    function controller() external view returns (address) {
        return controllerReturn;
    }
}
