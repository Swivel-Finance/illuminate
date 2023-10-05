// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.20;

import {IAdapter} from "src/interfaces/IAdapter.sol";
import {ISwivel} from "src/interfaces/ISwivel.sol";
import {IERC20} from "src/interfaces/IERC20.sol";
import {IYield} from "src/interfaces/IYield.sol";
import {IMarketPlace} from "src/interfaces/IMarketPlace.sol";
import {IERC5095} from "src/interfaces/IERC5095.sol";
import {Lender} from "src/Lender.sol";

import {Swivel} from "src/lib/Swivel.sol";
import {Exception} from "src/errors/Exception.sol";
import {Safe} from "src/lib/Safe.sol";

contract SwivelAdapter is IAdapter, Lender {
    constructor() Lender(address(0), address(0), address(0)) {}

    address public lender = address(0);

    function underlying(address pt) public view returns (address) {
        return address(IERC5095(pt).underlying());
    }

    function lend(
        uint256[] memory amount,
        bool internalBalance,
        bytes calldata d
    ) external authorized(lender) returns (uint256, uint256) {
        // Parse the calldata into the arguments
        (
            Swivel.Order[] memory orders,
            Swivel.Components[] memory components,
            address pool,
            uint256 slippage,
            bool swapFlag
        ) = abi.decode(
                d,
                (
                    Swivel.Order[],
                    Swivel.Components[],
                    address,
                    uint256,
                    bool
                )
            );

        // Cache a couple oft-referenced variables
        address underlying_ = orders[0].underlying;
        uint256 maturity = orders[0].maturity;
        address pt = IMarketPlace(marketPlace).markets(underlying_, maturity).tokens[1];

        // Verify orders are for the same underlying
        {
            for (uint256 i = 0; i < orders.length; ) {
                if (
                    underlying_ != orders[i].underlying ||
                    maturity != orders[i].maturity
                ) {
                    revert Exception(0, 0, 0, address(0), address(0)); // TODO: assign exception code
                }

                unchecked {
                    i++;
                }
            }
        }

        // Get the amount of the orders
        uint256 total;
        uint256 fee;
        {
            for (uint256 i = 0; i < amount.length; ) {
                total += amount[i];

                // extract fee
                if (i == amount.length - 1) {
                    fee = total / feenominator;
                    amount[i] = amount[i] - fee;
                    total = total - fee;
                    fees[underlying_] += fee;
                }

                unchecked {
                    i++;
                }
            }
        }
        if (internalBalance == false) {
            // Receive underlying funds, extract fees
            Safe.transferFrom(
                IERC20(underlying_),
                msg.sender,
                address(this),
                total + fee
            );
        }
        // Store amount of iPTs to be minted to user
        uint256 received = IERC20(pt).balanceOf(address(this));

        // Execute the orders
        uint256 premium = IERC20(underlying_).balanceOf(address(this));
        ISwivel(protocolRouters[0]).initiate(orders, amount, components);
        premium = IERC20(underlying_).balanceOf(address(this)) - premium;
        received = IERC20(pt).balanceOf(address(this)) - received;

        // Swap the premium for iPTs or return premium to the sender
        if (swapFlag) {
            received += swap(pool, underlying_, premium, slippage);
        } else {
            premiums[underlying_][maturity] += premium;
            received += premium;
        }

        return (received, total);
    }

    /// @notice facilitates a swap for Illuminate's principal tokens
    /// @param p Yield Space pool for the market
    /// @param u underlying asset being sold for PTs
    /// @param a amount of underlying to be swapped
    /// @param m minimum number of tokens to receive
    /// @return received amount of PTs received in swap
    function swap(
        address p,
        address u,
        uint256 a,
        uint256 m
    ) internal returns (uint256) {
        // transfer funds to the pool
        Safe.transfer(IERC20(u), p, a);

        uint256 received = IYield(p).sellBase(address(this), uint128(a));
        if (received < m) {
            revert Exception(0, 0, 0, address(0), address(0)); // TODO: add exception code
        }

        return received;
    }
}
