// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.20;

import {IAdapter} from "../interfaces/IAdapter.sol";
import {ISwivel} from "../interfaces/ISwivel.sol";
import {IERC20} from "../interfaces/IERC20.sol";
import {IMarketPlace} from "../interfaces/IMarketPlace.sol";
import {IERC5095} from "../interfaces/IERC5095.sol";
import {ILender} from "../interfaces/ILender.sol";
import {IYield} from "../interfaces/IYield.sol";

import {Exception} from "../errors/Exception.sol";

import {Swivel} from "../lib/Swivel.sol";
import {Safe} from "../lib/Safe.sol";


contract SwivelAdapter is IAdapter {
    constructor() {}

    address public lender; 

    address public marketplace;

    address public redeemer;

    mapping (address => bool) private isTokenValid;

    // @notice returns the address of the underlying token for the PT
    // @param pt The address of the PT
    function underlying(address pt) public view returns (address) {
        return address(IERC5095(pt).underlying());
    }

    // @notice returns the maturity of the underlying token for the PT
    // @param pt The address of the PT
    function maturity(address pt) public view returns (uint256) {
        return IERC5095(pt).maturity();
    }

    // @notice returns the protocol enum of this given adapter
    function protocol() public view returns (uint8) {
        return (1);
    }

    // @notice lendABI "returns" the arguments required in the bytes `d` for the lend function
    // @returns orders The orders to be executed -- see Swivel for more info -- https://github.com/Swivel-Finance/swivel/blob/main/contracts/v4/src/lib/Hash.sol#L14
    // @returns components The components of the orders -- see Swivel for more info -- https://github.com/Swivel-Finance/swivel/blob/main/contracts/v4/src/lib/Sig.sol#L7
    // @returns pool The address of the pool to lend to (buy PTs from) with the excess premium generated by Swivel
    // @returns swapMinimum The minimum amount of the underlying token to receive from the swap (when spending excess premium)
    // @returns swapFlag Whether or not to swap the premium for more PTs (sometimes it is not beneficial to do so)
    function lendABI() public pure returns (
        Swivel.Order[] memory orders,
        Swivel.Components[] memory components,
        address pool,
        uint256 swapMinimum,
        bool swapFlag) {
    }

    // @notice redeemABI "returns" the arguments required in the bytes `d` for the redeem function
    function redeemABI(
    ) public pure {
    }

    // @notice verifies that the provided underlying and maturity align with the provided PT address, enabling minting
    // @param underlying_ The address of the underlying token
    // @param maturity_ The maturity of the iPT 
    // @param targetToken The address of the token to be deposited -- note: If the market PT is not the same as the targetToken, underlying and maturity are validated
    // @param amount The amount of the targetToken to be deposited
    // @returns bool returns the amount of mintable iPTs
    function mint(
        address underlying_, 
        uint256 maturity_, 
        address targetToken, 
        uint256 amount
    ) external returns (uint256) {
        // Fetch the desired principal token
        address pt = IMarketPlace(marketplace).markets(underlying_, maturity_).tokens[protocol()];

        // Disallow mints if market is not initialized (verifying the input underlying and maturity are valid)
        if (pt == address(0)) {
            revert Exception(26, 0, 0, address(0), address(0));
        }
        // Confirm that the principal token has not matured yet
        if (block.timestamp > maturity_ || maturity_ == 0) {
            revert Exception(
                7,
                maturity_,
                block.timestamp,
                address(0),
                address(0)
            );
        }
        // If the targetToken is not the same as the market PT, validate the underlying and maturity
        if (targetToken != pt) {
            if (underlying(targetToken) != underlying_ || maturity(targetToken) > maturity_ || ILender(lender).validToken(targetToken) == false) {
                revert Exception(
                    8,
                    maturity(targetToken),
                    maturity_,
                    underlying(targetToken),
                    underlying_
                );
            }
        }
        // Transfer the targetToken to the lender contract
        Safe.transferFrom(IERC20(targetToken), msg.sender, address(this), amount);
        // Return the amount of iPTs to mint 
        return (ILender(lender).convertDecimals(underlying_, pt, amount));
    }

    // @notice lends `amount` to Swivel protocol by spending `Sum(amount)-Totalfee` on PTs
    // @param amount The amount of the underlying token to lend (an array of amounts that corrosponds with the array of orders in `d`)
    // @param internalBalance Whether or not to use the internal balance or if a transfer is necessary
    // @param d The calldata for the lend function -- described above in lendABI
    // @returns received The amount of the PTs received from the lend
    // @returns spent The amount of the underlying token spent on the lend
    // @returns fee The amount of the underlying token spent on the fee
    function lend(
        address underlying_,
        uint256 maturity_,
        uint256[] memory amount,
        bool internalBalance,
        bytes calldata d
    ) external payable returns (uint256, uint256, uint256) {
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

        address pt = IMarketPlace(marketplace).markets(underlying_, maturity_).tokens[protocol()]; // TODO: Get Swivel PT enum

        address _underlying = IERC5095(pt).underlying();

        uint256 _maturity = IERC5095(pt).maturity();

        // Verify orders are for the same underlying
        {
            for (uint256 i = 0; i < orders.length; ) {
                if (
                    _underlying != orders[i].underlying ||
                    _maturity != orders[i].maturity
                ) {
                    revert Exception(0, orders[i].maturity, _maturity, orders[i].underlying, _underlying); // TODO: assign exception code
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

                // Extract fee from the "last" (assuming the least optimal) order
                if (i == amount.length - 1) {
                    fee = total / ILender(lender).feenominator(maturity_);
                    amount[i] = amount[i] - fee;
                }
                unchecked {
                    i++;
                }
            }
        }
        // Store amount of starting Underlying before transfers
        uint256 premium = IERC20(underlying_).balanceOf(address(this));

        if (internalBalance == false) {
            // Receive underlying funds
            Safe.transferFrom(
                IERC20(underlying_),
                msg.sender,
                address(this),
                total
            );
        }

        // Store amount of external PTs before minting
        uint256 received = IERC20(pt).balanceOf(address(this));
        // Execute the orders
        ISwivel(ILender(lender).protocolRouters(0)).initiate(orders, amount, components);
        // Calculate premium & recieved using diffs
        premium = IERC20(underlying_).balanceOf(address(this)) - premium - fee;
        received = IERC20(pt).balanceOf(address(this)) - received;

        // Swap the premium for iPTs or return premium to the sender
        if (swapFlag) {
            received += swap(pool, underlying_, premium, swapMinimum);
        } else {
            received += premium;
        }

        return (received, total, fee);
    }

    // @notice After maturity, redeem `amount` of the underlying token from the Swivel protocol
    // @param underlying_ The address of the underlying token
    // @param maturity_ The maturity of the underlying token
    // @param amount The amount of the PTs to redeem
    // @param internalBalance Whether or not to use the internal balance or if a transfer is necessary
    // @param d The calldata for the redeem function -- described above in redeemABI
    function redeem(
        address underlying_,
        uint256 maturity_,
        uint256 amount,
        bool internalBalance,
        bytes calldata d
    ) external returns (uint256, uint256) {

        address pt = IMarketPlace(marketplace).markets(underlying_, maturity_).tokens[protocol()];
        if (internalBalance == false){
            // Receive underlying funds, extract fees
            Safe.transferFrom(
                IERC20(pt),
                lender,
                address(this),
                amount
            );
        }

        // Retrieve unswapped premium from the Lender contract
        ILender(lender).transferPremium(underlying_, maturity_);

        uint256 starting = IERC20(underlying_).balanceOf(address(this));

        IERC5095(pt).redeem( uint128(amount), address(this), address(this));

        uint256 received = IERC20(underlying_).balanceOf(address(this)) - starting;

        return (received, amount);
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
