// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.20;

import {IAdapter} from "../interfaces/IAdapter.sol";
import {IERC20} from "../interfaces/IERC20.sol";
import {IYield} from "../interfaces/IYield.sol";
import {IMarketPlace} from "../interfaces/IMarketPlace.sol";
import {ILender} from "../interfaces/ILender.sol";

import {Safe} from "../lib/Safe.sol";
import {Exception} from "src/errors/Exception.sol";

contract YieldAdapter is IAdapter { 
    constructor() {}

    address public lender; 

    address public marketplace;

    address public redeemer;

    function underlying(address pt) public view returns (address) {
        return address(IYield(pt).base());
    }

    function maturity(address pt) public view returns (uint256) {
        return IYield(pt).maturity();
    }

    function lend(
        uint256[] memory amount,
        bool internalBalance,
        bytes calldata d
    ) external returns (uint256, uint256, uint256) {
        // Parse the calldata
        (
            address underlying_,
            uint256 maturity,
            uint256 minimum,
            address pool
        ) = abi.decode(d, (address, uint256, uint256, address));

        address pt = IMarketPlace(marketplace).markets(underlying_, maturity).tokens[0];
        if (internalBalance == false){
            // Receive underlying funds, extract fees
            Safe.transferFrom(
                IERC20(underlying_),
                msg.sender,
                address(this),
                amount[0]
            );
        }

        uint256 fee = amount[0] / ILender(lender).feenominator();

        // Execute the order
        uint256 starting = IERC20(pt).balanceOf(address(this));
        Safe.transfer(IERC20(underlying_), pool, amount[0] - fee);
        IYield(pool).sellBase(address(this), uint128(minimum));
        uint256 received = IERC20(pt).balanceOf(address(this)) - starting;

        return (received, amount[0], fee);
    }

    function redeem(
        uint256 amount,
        bool internalBalance,
        bytes calldata d
    ) external returns (uint256, uint256) {
        // Parse the calldata
        (
            address underlying_,
            uint256 maturity
        ) = abi.decode(d, (address, uint256));

        address pt = IMarketPlace(marketplace).markets(underlying_, maturity).tokens[0];
        if (internalBalance == false){
            // Receive underlying funds, extract fees
            Safe.transferFrom(
                IERC20(pt),
                msg.sender,
                address(this),
                amount
            );
        }

        uint256 starting = IERC20(underlying_).balanceOf(address(this));

        IYield(pt).redeem(address(this), uint128(amount));

        uint256 received = IERC20(underlying_).balanceOf(address(this)) - starting;

        Safe.transfer(IERC20(underlying_), msg.sender, received);

        return (received, amount);
    }
}
