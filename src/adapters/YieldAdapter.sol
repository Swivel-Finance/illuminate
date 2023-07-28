// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.20;

import {Lender} from 'src/Lender.sol';

import {IAdapter} from 'src/interfaces/IAdapter.sol';
import {IERC20} from 'src/interfaces/IERC20.sol';
import {IYield} from 'src/interfaces/IYield.sol';
import {IMarketPlace} from 'src/interfaces/IMarketPlace.sol';

import {Exception} from 'src/errors/Exception.sol';
import {Safe} from 'src/lib/Safe.sol';

contract YieldAdapter is IAdapter, Lender {
    constructor() Lender(address(0), address(0), address(0)) {}

    address public lender = address(0);

    modifier authorizedLender() {
        if (address(this) != lender) {
            revert Exception(0, 0, 0, address(0), address(0));
        }
        _;
    }

    function lend(
        bytes calldata d
    ) external authorizedLender returns (uint256, uint256) {
        // Parse the calldata
        (
            address underlying,
            uint256 maturity,
            address pool,
            uint256 amount,
            uint256 minimum
        ) = abi.decode(d, (address, uint256, address, uint256, uint256));

        address pt = IMarketPlace(marketPlace).markets(underlying, maturity, 0);

        // Receive underlying funds, extract fees
        Safe.transferFrom(
            IERC20(underlying),
            msg.sender,
            address(this),
            amount
        );

        uint256 fee = amount / feenominator;
        fees[underlying] += fee;
        amount = amount - fee;

        // Execute the order
        uint256 starting = IERC20(pt).balanceOf(address(this));
        Safe.transfer(IERC20(underlying), pool, amount);
        IYield(pool).sellBase(address(this), uint128(minimum));
        uint256 received = IERC20(pt).balanceOf(address(this)) - starting;

        return (received, amount + fee);
    }
}
