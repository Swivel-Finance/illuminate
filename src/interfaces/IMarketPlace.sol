// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.20;

interface IMarketPlace {
    
    function markets(address, uint256) external returns (Market memory);

    struct Market {
        address[] tokens;
        address[] adapters;
        address pool;
    }

    function sellPrincipalToken(
        address,
        uint256,
        uint128,
        uint128
    ) external returns (uint128);

    function buyPrincipalToken(
        address,
        uint256,
        uint128,
        uint128
    ) external returns (uint128);

    function sellUnderlying(
        address,
        uint256,
        uint128,
        uint128
    ) external returns (uint128);

    function buyUnderlying(
        address,
        uint256,
        uint128,
        uint128
    ) external returns (uint128);

    function redeemer() external view returns (address);
}
