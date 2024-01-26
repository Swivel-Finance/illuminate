// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.20;

interface IMarketPlace {
    
    enum Principals {
        Illuminate, // 0
        Swivel, // 1
        Yield, // 2
        Element, // 3
        Pendle, // 4
        Apwine, // 5
        Notional, // 6
        Exactly, // 7
        Term // 8
    }
    
    struct Market {
        address[] tokens;
        address pool;
    }


    function markets(address, uint256) external view returns (Market memory);

    function adapters(uint8) external view returns (address);

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
