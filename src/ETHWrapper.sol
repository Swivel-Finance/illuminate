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

    address public eth = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address public stETH = 0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84;
    address public stETHPool = 0xDC24316b9AE028F1497c275EB9192a3Ea0f67022;
    address public frxETH = 0x5E8422345238F34275888049021821E8E08CAa1f;
    address public frxETHPool = 0xa1F8A6807c402E4A15ef4EBa36528A3FED24E577;
    address public admin;

    // authorized modifier
    modifier authorized(address a) {
        require(msg.sender == a, 'Only an authorized address can call this function');
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    // Generically approve a contract to spend tokens
    function approveCurve(address token, address spender) external authorized(admin) {
        IERC20(token).approve(spender, type(uint256).max);
    }

    // Sets admin
    function setAdmin(address a) external authorized(admin) {
        admin = a;
    }

    /// @notice convert using Curve Finance
    /// @notice expects funds already sent to this contract
    /// @param input address of the token to be spent on Curve
    /// @param output address of the token to be recieved from Curve
    /// @param amount amount of input to be spent on Curve
    /// @param minimum minimum amount of output to be recieved from Curve
    function swap(
        address input,
        address output,
        uint256 amount,
        uint256 minimum
    ) external payable returns (uint256, uint256) {
        address pool;
        // if input or output is eth
        if (input == stETH || output == stETH) {
            pool == stETHPool;
        } else {
            pool == frxETHPool;
        }
        // Instantiate Curve and determine Curve pathing
        ICurve curve = ICurve(pool);

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
        uint256 returned = ICurve(pool).exchange(_input, _output, amount, minimum);
        // TODO: Double check this calculation -- I derived it and checked the outputs on chain but worth a double check
        // slippageRatio is the denominator necessary to adjust other values to the same scale as the returned value
        uint256 slippageRatio = 1e18 / ((amount - returned) * 1e18 / amount);

        return (returned, slippageRatio);

    }
}