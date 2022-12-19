// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

contract APWineFutureVault {
    address private getControllerAddressReturn;
    uint256 private periodDurationReturn;
    uint256 private getCurrentPeriodIndexReturn;
    address private getFYTofPeriodReturn;
    address private getIBTAddressReturn;

    function periodDurationReturns(uint256 p) external {
        periodDurationReturn = p;
    }

    function PERIOD_DURATION() external view returns (uint256) {
        return periodDurationReturn;
    }

    function getCurrentPeriodIndexReturns(uint256 p) external {
        getCurrentPeriodIndexReturn = p;
    }

    function getCurrentPeriodIndex() external view returns (uint256) {
        return getCurrentPeriodIndexReturn;
    }

    function getFYTofPeriodReturns(address f) external {
        getFYTofPeriodReturn = f;
    }

    function getFYTofPeriod(uint256) external view returns (address) {
        return getFYTofPeriodReturn;
    }

    function getIBTAddressReturns(address i) external {
        getIBTAddressReturn = i;
    }

    function getIBTAddress() external view returns (address) {
        return getIBTAddressReturn;
    }

    function getControllerAddressReturns(address c) external {
        getControllerAddressReturn = c;
    }

    function getControllerAddress() external view returns (address) {
        return getControllerAddressReturn;
    }
}
