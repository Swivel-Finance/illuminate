// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.16;

interface IAPWineFutureVault {
    function PERIOD_DURATION() external view returns (uint256);

    function getControllerAddress() external view returns (address);
}
