// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.16;

interface IAaveLendingPool {
    function withdraw(
        address,
        uint256,
        address
    ) external;

    // only used by integration tests
    function deposit(
        address,
        uint256,
        address,
        uint16
    ) external;
}
