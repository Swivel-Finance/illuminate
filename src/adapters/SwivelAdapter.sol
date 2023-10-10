// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.20;

import {IAdapter} from "src/interfaces/IAdapter.sol";
import {ISwivel} from "src/interfaces/ISwivel.sol";
import {IERC20} from "src/interfaces/IERC20.sol";
import {IMarketPlace} from "src/interfaces/IMarketPlace.sol";
import {IERC5095} from "src/interfaces/IERC5095.sol";

import {Swivel} from "src/lib/Swivel.sol";
import {Exception} from "src/errors/Exception.sol";
import {Safe} from "src/lib/Safe.sol";

contract SwivelAdapter is IAdapter {
    constructor() {}

    address public lender; 

    address public marketplace;

    address public redeemer;

    function underlying(address pt) public view returns (address) {
        return address(IERC5095(pt).underlying());
    }

    function maturity() public view returns (uint256) {
        return IERC5095(pt).maturity();
    }

    function lend(
        uint256[] memory amount,
        bool internalBalance,
        bytes calldata d
    ) external returns (uint256, uint256, uint256) {
        // Parse the calldata into the arguments
        (
            Swivel.Order[] memory orders,
            Swivel.Components[] memory components,
            address pool,
            uint256 swapMinimum,
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
        uint256 totalFee;
        uint256 fee;
        {
            for (uint256 i = 0; i < amount.length; ) {
                total += amount[i];

                // extract fee
                if (i == amount.length - 1) {
                    fee = total / feenominator;
                    amount[i] = amount[i] - fee;
                    total = total - fee;
                    totalFee += fee;
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
                total + totalFee
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
            received += swap(pool, underlying_, premium, swapMinimum);
        } else {
            premiums[underlying_][maturity] += premium;
            received += premium;
        }

        return (received, total, totalFee);
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

        address pt = IMarketPlace(marketPlace).markets(underlying_, maturity).tokens[0];
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

        IERC5095(pt).redeem(address(this), uint128(amount));

        uint256 received = IERC20(underlying_).balanceOf(address(this)) - starting;

        Safe.transfer(IERC20(underlying_), msg.sender, received);

        return (received, amount);
    }
}
