// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.16;

interface IPendleToken {
    function underlyingAsset() external returns (address);

    function underlyingYieldToken() external returns (address);

    function expiry() external view returns (uint256);

    function forge() external returns (address);
}
