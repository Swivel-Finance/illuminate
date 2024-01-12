// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.20;

import "../lib/Safe.sol";
import "../errors/Exception.sol";

import "../interfaces/IConverter.sol";
import "../interfaces/IAaveAToken.sol";
import "../interfaces/IAaveLendingPool.sol";
import "../interfaces/ICompoundToken.sol";
import "../interfaces/ILido.sol";
import "../interfaces/IERC20.sol";

contract Converter is IConverter {
    /// @notice converts the intermediate asset to the underlying asset for msg.sender
    /// @dev currently supports Compound, Aave v2 and Lido conversions
    /// @param d bytes object containing (d - the address of the compounding token, u - the address of the underlying token, a - the amount of tokens to convert)
    function convert(bytes memory d) external returns (uint256) {

        // Get the addresses of the underlying and compounding tokens
        // i - intermediate token, 
        // u - underlying token
        (address i, address u) = abi.decode(d, (address, address));

        // First get the balance of intermediate tokens of the caller
        uint256 amount = IERC20(i).balanceOf(address(this));

        // Unwrap wrapped staked eth
        uint256 unwrapped = ILido(i).unwrap(amount);
        return (unwrapped);
    }
}
