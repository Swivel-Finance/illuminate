// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.20;

interface IPendleSYToken {


    enum AssetType {
        TOKEN,
        LIQUIDITY
    }

    function redeem(
        address,
        uint256,
        address,
        uint256,
        bool
    ) external returns (uint256);

    function assetInfo() external returns(AssetType assetType, address assetAddress, uint8 assetDecimals);
}
