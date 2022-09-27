// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

contract APWineFutureVault {
    address private getControllerAddressReturn;
    uint256 private periodDurationReturn;

    function periodDurationReturns(uint256 p) external {
        periodDurationReturn = p;
    }

    function PERIOD_DURATION() external view returns (uint256) {
        return periodDurationReturn;
    }

    function getControllerAddressReturns(address c) external {
        getControllerAddressReturn = c;
    }

    function getControllerAddress() external view returns (address) {
        return getControllerAddressReturn;
    }
}
