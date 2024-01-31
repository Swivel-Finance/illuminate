// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.20;

interface IMarketPlace {
    
    enum Principals {
        Illuminate, // 0
        Yield, // 2
        Pendle, // 3
        Apwine, // 4
        Notional, // 5
        Exactly, // 6
        Term // 7
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
