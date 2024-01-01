// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.20;

import "./lib/Safe.sol";
import "./errors/Exception.sol";

import "./interfaces/IERC20.sol";
import "./interfaces/IERC5095.sol";
import "./interfaces/ICurve.sol";


/// @title ETHWrapper
/// @author Julian Traversa
/// @notice The contract that wraps ETH into a given lst using curve
contract ETHWrapper {

    constructor() {
    }

    event TestEvent(address, address, uint256, uint256, string);

    /// @notice convert using Curve Finance
    /// @notice expects funds already sent to this contract
    /// @param input address of the token to be spent on Curve
    /// @param output address of the token to be recieved from Curve
    /// @param amount amount of input to be spent on Curve
    /// @param minimum minimum amount of output to be recieved from Curve
    function swap(
        address pool,
        address input,
        address output,
        uint256 amount,
        uint256 minimum
    ) external payable returns (uint256, uint256) {

        // Instantiate Curve and determine Curve pathing
        ICurve curve = ICurve(pool);  
        if (curve.coins(0) != input && curve.coins(1) != input) {
            revert('Input token is not supported by provided Curve Pool');
        }
        if (curve.coins(0) != output && curve.coins(1) != output) {
            revert('Output token is not supported by provided Curve Pool');
        }

        int128 _input;
        int128 _output;
        if (curve.coins(0) == input) {
            _input = 0;
            _output = 1;
        } else {
            _input = 1;
            _output = 0;
        }

        // Swap on curve, spending amount of input, expecting minimumCurve of output
        // TODO support for Curve v2?
        uint256 returned;
        if (input == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE) {
            returned = ICurve(pool).exchange{value: amount}(_input, _output, amount, minimum);
        } else {
            returned = ICurve(pool).exchange(_input, _output, amount, minimum);
        }
        // TODO: Double check this calculation -- I derived it and checked the outputs on chain but worth a double check
        // conversionRatio is the denominator necessary to adjust other values to the same scale as the returned value
        uint256 conversionRatio;
        if (returned > amount) {
            conversionRatio = 1e18 / ((returned - amount) * 1e18 / amount);
        }
        else {
            conversionRatio = 1e18 / ((amount - returned) * 1e18 / amount);
        }
        return (returned, conversionRatio);
    }
}