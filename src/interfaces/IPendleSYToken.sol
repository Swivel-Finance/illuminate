// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.16;

interface IPendleSYToken {
    function redeem(
        address,
        uint256,
        address,
        uint256,
        bool
    ) external returns (uint256);
}
