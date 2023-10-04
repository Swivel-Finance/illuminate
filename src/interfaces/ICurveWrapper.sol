// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.20;

interface ICurveWrapper {
    function swap(
        address from,
        address to,
        uint256 amount,
        uint256 minimum
    ) external returns (uint256);
}
