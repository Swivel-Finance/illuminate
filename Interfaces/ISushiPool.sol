 // SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.4;

interface ISushiPool {
    function swapExactTokensForTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory);
}