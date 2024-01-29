// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.20;

import "./lib/Safe.sol";
import "./errors/Exception.sol";

import "./interfaces/IERC20.sol";
import "./interfaces/IERC5095.sol";
import "./interfaces/ICurve.sol";
import "./interfaces/IWETH.sol";
import "./interfaces/IeETH.sol";

/// @title ETHWrapper
/// @author Julian Traversa
/// @notice The contract that wraps ETH into a given lst using curve
contract ETHWrapper {

    constructor() {
    }

    fallback() external payable {}

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
        uint256 returned;
        // Efficient try/catch for CurveV1 vs CurveV2
        (bool success, bytes memory returnData) = pool.staticcall(abi.encodeWithSignature("coins(uint256)", 0));
        if (success && returnData.length == 32) {
            address coin = abi.decode(returnData, (address));
            if (coin != input && curve.coins(1) != input) {
            revert('Input token is not supported by provided Curve Pool');
            }
            if (coin != output && curve.coins(1) != output) {
                revert('Output token is not supported by provided Curve Pool');
            }
            // Map input and output to Curve pool
            int128 _input;
            int128 _output;
            if (coin == input) {
                _input = 0;
                _output = 1;
            } else {
                _input = 1;
                _output = 0;
            }
            // Swap on Curve pool depending on ETH input
            if (input == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE) {
                returned = ICurve(pool).exchange{value: amount}(_input, _output, amount, minimum);
            } else {
                returned = ICurve(pool).exchange(_input, _output, amount, minimum);
            }
        }
        else {
            // Swap on Curve v2 router depending on ETH input
            if (input == 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE) {
                // if eETH, wrap to WETH before swap, unwrap WeETH to eETH after swap
                if (output == 0x35fA164735182de50811E8e2E824cFb9B6118ac2) {
                    // Wrap eth to WETH
                    IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2).deposit{value: amount}();
                    // Override inputs and outputs with WETH and weETH
                    input = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
                    output = 0xCd5fE23C85820F7B72D0926FC9b05b43E359b7ee;
                    emit TestEvent(input, output, amount, minimum, "WETH");
                                // Map input and output to Curve pool
                    pool = 0x13947303F63b363876868D070F14dc865C36463b;
                    curve = ICurve(pool);
                    address coin = curve.coins(0);
                    if (coin != input && curve.coins(1) != input) {
                    revert('Input token is not supported by provided Curve Pool');
                    }
                    if (coin != output && curve.coins(1) != output) {
                        revert('Output token is not supported by provided Curve Pool');
                    }
                    // Map input and output to Curve pool
                    int128 _input;
                    int128 _output;
                    if (coin == input) {
                        _input = 0;
                        _output = 1;
                    } else {
                        _input = 1;
                        _output = 0;
                    }
                    returned = ICurve(pool).exchange(_input, _output, amount, minimum);
                    // unwrap to eETH
                    returned = IeETH(output).unwrap(returned);
                }
                else {
                returned = ICurveV2(pool).exchange_with_best_rate{value: amount}(input, output, amount, minimum);
                }
            } else {
                returned = ICurveV2(pool).exchange_with_best_rate(input, output, amount, minimum);
            }
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