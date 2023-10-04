// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.20;

import {Lender} from "../Lender.sol";

import {IAdapter} from "../interfaces/IAdapter.sol";
import {IERC20} from "../interfaces/IERC20.sol";
import {IYield} from "../interfaces/IYield.sol";
import {IMarketPlace} from "../interfaces/IMarketPlace.sol";

import {Safe} from "../lib/Safe.sol";

contract YieldAdapter is IAdapter, Lender { 
    constructor() Lender(address(0), address(0), address(0)) {}

    address public lender = address(0);

    function underlying(address pt) public view returns (address) {
        return address(IYield(pt).base());
    }

    function lend(
        uint256[] memory amount,
        bytes calldata d
    ) external authorized(lender) returns (uint256, uint256) {
        // Parse the calldata
        (
            address underlying_,
            uint256 maturity,
            uint256 minimum,
            address pool
        ) = abi.decode(d, (address, uint256, uint256, address));

        address pt = IMarketPlace(marketPlace).markets(underlying_, maturity).tokens[0];

        // Receive underlying funds, extract fees
        Safe.transferFrom(
            IERC20(underlying_),
            msg.sender,
            address(this),
            amount[0]
        );

        uint256 fee = amount[0] / feenominator;
        fees[underlying_] += fee;

        // Execute the order
        uint256 starting = IERC20(pt).balanceOf(address(this));
        Safe.transfer(IERC20(underlying_), pool, amount[0] - fee);
        IYield(pool).sellBase(address(this), uint128(minimum));
        uint256 received = IERC20(pt).balanceOf(address(this)) - starting;

        return (received, amount[0]);
    }
}
