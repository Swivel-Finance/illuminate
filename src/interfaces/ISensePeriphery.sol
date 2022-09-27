// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.16;

interface ISensePeriphery {
    function swapUnderlyingForPTs(
        address,
        uint256,
        uint256,
        uint256
    ) external returns (uint256);
}
