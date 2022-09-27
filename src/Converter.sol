// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.16;

import 'src/interfaces/IConverter.sol';

import 'src/interfaces/IAaveAToken.sol';
import 'src/interfaces/IAaveLendingPool.sol';
import 'src/interfaces/ICompoundToken.sol';
import 'src/interfaces/IUniswap.sol';

import 'src/interfaces/IERC20.sol';

// TODO make an admin for this contract?
contract Converter is IConverter {
    address public ROUTER = 0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F;

    /// @notice converts the compounding asset to the underlying asset for msg.sender
    /// @dev currently only supports Compound and Aave conversions
    /// @param c contract address of the compounding token
    /// @param u contract address of the underlying token
    /// @param a amount of tokens to convert
    /// @param m minimum tokens to be received (only used for swap conversions)
    function convert(
        address c,
        address u,
        uint256 a,
        uint256 m
    ) external {
        // first receive the tokens from msg.sender
        IERC20(c).transferFrom(msg.sender, address(this), a);

        // get Aave pool
        try IAaveAToken(c).POOL() returns (address pool) {
            // Allow the pool to spend the funds
            IERC20(u).approve(pool, a);
            // withdraw from Aave
            IAaveLendingPool(pool).withdraw(u, a, msg.sender);
        } catch {
            // Aave did not work, try compound
            try ICompoundToken(c).redeem(a) {
                // get the balance of tokens to send back
                uint256 balance = IERC20(u).balanceOf(address(this));
                // transfer the underlying back to the user
                IERC20(u).transfer(msg.sender, balance);
            } catch {
                // Create path to swap stETH for wETH
                address[] memory path = new address[](2);
                path[0] = c;
                path[1] = u;
                // Swap wrapped staked eth for wrapped eth via sushi
                // todo why is this not working
                IUniswap(ROUTER).swapExactTokensForTokens(
                    a,
                    m,
                    path,
                    msg.sender,
                    block.timestamp // deadline well into the future
                );
            }
        }
    }
}
