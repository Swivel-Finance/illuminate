// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.20;

import {IAdapter} from "../interfaces/IAdapter.sol";
import {IERC20} from "../interfaces/IERC20.sol";
import {INotional} from "../interfaces/INotional.sol";
import {IMarketPlace} from "../interfaces/IMarketPlace.sol";
import {ILender} from "../interfaces/ILender.sol";

import {Exception} from "../errors/Exception.sol";

import {Safe} from "../lib/Safe.sol";

contract NotionalAdapter is IAdapter { 
    constructor() {}

    address public lender; 

    address public marketplace;

    address public redeemer;

    mapping (address => bool) private isTokenValid;

    error TestException(address, address, uint256, uint256, string);

    // @notice returns the address of the underlying token for the PT
    // @param pt The address of the PT
    function underlying(address pt) public view returns (address) {
        (IERC20 _underlying,) = INotional(pt).getUnderlyingToken();
        return address(_underlying);
    }

    // @notice returns the maturity of the underlying token for the PT
    // @param pt The address of the PT
    function maturity(address pt) public view returns (uint256) {
        return INotional(pt).getMaturity();
    }

    // @notice returns the protocol enum of this given adapter
    function protocol() public view returns (uint8) {
        return (5);
    }

    // @notice lendABI "returns" the arguments required in the bytes `d` for the lend function
    function lendABI(
    ) public pure {
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

    // @notice lends `amount` to yield protocol by spending `amount-fee` on PTs from `pool`
    // @param amount The amount of the underlying token to lend (amount[0] is used for this adapter)
    // @param internalBalance Whether or not to use the internal balance or if a transfer is necessary
    // @param d The calldata for the lend function -- described above in lendABI
    // @returns received The amount of the PTs received from the lend
    // @returns spent The amount of the underlying token spent on the lend
    // @returns fee The amount of the underlying token spent on the fee
    function lend(
        address underlying_,
        uint256 maturity_,
        uint256[] calldata amount,
        bool internalBalance,
        bytes calldata d
    ) external payable returns (uint256, uint256, uint256) {

        address pt = IMarketPlace(marketplace).markets(underlying_, maturity_).tokens[protocol()]; // TODO: get yield PT enum
        if (internalBalance == false){
            // Receive underlying funds, extract fees
            Safe.transferFrom(
                IERC20(underlying_),
                msg.sender,
                address(this),
                amount[0]
            );
        }

        uint256 fee = amount[0] / ILender(lender).feenominator(maturity_);

        // Execute the order
        uint256 starting = IERC20(pt).balanceOf(address(this));
        INotional(pt).deposit(amount[0]-fee, address(this));
        uint256 received = IERC20(pt).balanceOf(address(this)) - starting;

        return (received, amount[0], fee);
    }

    // @notice After maturity, redeem `amount` of the underlying token from the X protocol
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
        // TODO: Double check protocol enum
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

        uint256 starting = IERC20(underlying_).balanceOf(address(this));

        INotional(pt).redeem(amount, address(this), address(this));

        uint256 received = IERC20(underlying_).balanceOf(address(this)) - starting;

        Safe.transfer(IERC20(underlying_), msg.sender, received);

        return (received, amount);
    }
}