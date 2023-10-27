// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.20;

import "./lib/Safe.sol";
import "./errors/Exception.sol";

import "./interfaces/IConverter.sol";
import "./interfaces/IAaveAToken.sol";
import "./interfaces/IAaveLendingPool.sol";
import "./interfaces/ICompoundToken.sol";
import "./interfaces/ILido.sol";
import "./interfaces/IERC20.sol";

contract Converter is IConverter {
    /// @notice converts the compounding asset to the underlying asset for msg.sender
    /// @dev currently supports Compound, Aave v2 and Lido conversions
    /// @param d bytes object containing (d - the address of the compounding token, u - the address of the underlying token, a - the amount of tokens to convert)
    function convert(bytes memory d) external returns (uint256) {

        // Get the addresses of the underlying and compounding tokens
        (address i, address u) = abi.decode(d, (address, address));

        // First get the balance of intermediate tokens of the caller
        uint256 amount = IERC20(i).balanceOf(msg.sender);
        // Get the balance of underlying assets redeemed
        uint256 balance = IERC20(u).balanceOf(address(this));
        // Get Aave pool
        try IAaveAToken(i).POOL() returns (address pool) {
            // Withdraw from Aave
            IAaveLendingPool(pool).withdraw(u, amount, msg.sender);
            return (amount);
        } catch {
            // Attempt to redeem compound tokens to the underlying asset
            try ICompoundToken(i).redeem(amount) returns (uint256 err) {
                // Error if `redeem` returns non-zero value
                if (err != 0) {
                    revert Exception(28, err, 0, address(0), address(0));
                }
                // Get the balance of underlying assets redeemed
                uint256 returned = IERC20(u).balanceOf(address(this)) - balance;
                return (returned);
            } catch {
                // Unwrap wrapped staked eth
                uint256 unwrapped = ILido(i).unwrap(amount);
                return (unwrapped);
            }
        }
    }
}
