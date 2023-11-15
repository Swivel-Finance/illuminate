// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.20;

import {IAdapter} from "../interfaces/IAdapter.sol";
import {IERC20} from "../interfaces/IERC20.sol";
import {IERC5095} from "../interfaces/IERC5095.sol";
import {IMarketPlace} from "../interfaces/IMarketPlace.sol";
import {ILender} from "../interfaces/ILender.sol";
import {IExactly} from "../interfaces/IExactly.sol";

import {Safe} from "../lib/Safe.sol";

contract ExactlyAdapter is IAdapter { 
    constructor() {}

    address public lender; 

    address public marketplace;

    address public redeemer;

    event TestEvent(address, address, uint256, uint256, string);

    error TestException(address, address, uint256, uint256, string);

    // @notice returns the address of the underlying token for the PT
    // @param pt The address of the PT
    function underlying(address pt) public view returns (address) {
        return address(IExactly(pt).asset());
    }

    // @notice returns the maturity of the underlying token for the PT
    // @param pt The address of the PT
    function maturity(address pt) public view returns (uint256) {
        return IERC5095(pt).maturity();
    }

    // @notice lendABI "returns" the arguments required in the bytes `d` for the lend function
    // @returns underlying_ The address of the underlying token
    // @returns maturity The maturity of the underlying token
    // @returns minimum The minimum amount of the PTs to receive when spending (amount - fee)
    // @returns pool The address of the pool to lend to (buy PTs from)
    function lendABI(
    ) public pure returns (
        uint256 exactlyMaturity,
        address exactlyToken,
        uint256 minimumAssets) {
    }

    // @notice redeemABI "returns" the arguments required in the bytes `d` for the redeem function
    // @returns underlying_ The address of the underlying token
    // @returns maturity The maturity of the underlying token
    function redeemABI(
    ) public pure returns (
        address exactlyToken,
        uint256 exactlyMaturity) {
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
    ) external returns (uint256, uint256, uint256) {
        // TODO: Consider validation of the `exactlyMaturity` parameter -- on lends, if exactlyMaturity < maturity_ were fine, 
        // on redeem it may need to be validated within a certain range of our maturity
        // Parse the calldata
        (
            uint256 exactlyMaturity,
            uint256 minimumAssets // note: This could be removed and just calculated at near par? should be 1:1 or more at maturity and this accounts for prematurity redeems
        ) = abi.decode(d, (uint256, uint256));
        
        address exactlyToken = IMarketPlace(marketplace).markets(underlying_, maturity_).tokens[1];

        if (internalBalance == false){
            // Receive underlying funds, extract fees
            Safe.transferFrom(
                IERC20(underlying_),
                msg.sender,
                address(this),
                amount[0]
            );
        }
        (uint256 returned) = IExactly(exactlyToken).depositAtMaturity(exactlyMaturity, amount[0], (amount[0]-amount[0]/25), address(this));
        // TODO: consider changing address(this) to the redeemer if transfer isnt possible 

        emit TestEvent(exactlyToken, IExactly(exactlyToken).asset(), returned, amount[0], "test Lend");

        return (returned, amount[0], amount[0] / ILender(lender).feenominator());
    }

    // @notice After maturity, redeem `amount` of the underlying token from the X protocol
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
        // Parse the calldata
        (
            address exactlyToken,
            uint256 exactlyMaturity
        ) = abi.decode(d, (address, uint256));

        require(IExactly(exactlyToken).asset() == underlying_, "exactly input token mismatch");
        
        if (internalBalance == false){
            // Receive underlying funds, extract fees
            Safe.transferFrom(
                IERC20(exactlyToken),
                lender,
                address(this),
                amount
            );
        }

        uint256 starting = IERC20(underlying_).balanceOf(address(this));

        IExactly(exactlyToken).withdrawAtMaturity(exactlyMaturity, amount, amount, address(this), address(this));

        uint256 received = IERC20(underlying_).balanceOf(address(this)) - starting;

        return (received, amount);
    }
}
