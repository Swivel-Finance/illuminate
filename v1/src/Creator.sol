// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.16;

import 'src/tokens/ERC5095.sol';

import 'src/interfaces/IERC20.sol';

import 'src/errors/Exception.sol';

contract Creator {
    /// @notice address that is allowed to create markets and set contracts. It is commonly used in the authorized modifier.
    address public admin;

    /// @notice the marketplace contract that is allowed to create markets
    address public marketPlace;

    /// @notice ensures that only a certain address can call the function
    /// @param a address that msg.sender must be to be authorized
    modifier authorized(address a) {
        if (msg.sender != a) {
            revert Exception(0, 0, 0, msg.sender, a);
        }
        _;
    }

    /// @notice initializes the Creator contract
    constructor() {
        admin = msg.sender;
    }

    /// @notice creates a new market for the given underlying token and maturity
    /// @param u address of an underlying asset
    /// @param m maturity (timestamp) of the market
    /// @param r address of the redeemer contract
    /// @param l address of the lender contract
    /// @param mp address of the marketPlace contract
    /// @param n name for the Illuminate token
    /// @param s symbol for the Illuminate token
    /// @return address of the new Illuminate principal token
    function create(
        address u,
        uint256 m,
        address r,
        address l,
        address mp,
        string calldata n,
        string calldata s
    ) external authorized(marketPlace) returns (address) {
        // Create an Illuminate principal token for the new market
        address illuminateToken = address(
            new ERC5095(u, m, r, l, mp, n, s, IERC20(u).decimals())
        );

        return illuminateToken;
    }

    /// @notice sets the address of the marketplace contract
    /// @param m the address of the marketplace contract
    /// @return bool true if the address was set
    function setMarketPlace(address m)
        external
        authorized(admin)
        returns (bool)
    {
        if (marketPlace != address(0)) {
            revert Exception(5, 0, 0, marketPlace, address(0));
        }
        marketPlace = m;
        return true;
    }
}
