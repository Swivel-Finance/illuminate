// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.4;

interface IAPWinePool {
     function swapExactAmountIn(uint256 _pairID, uint256 _tokenIn, uint256 _tokenAmountIn, uint256 _tokenOut, uint256 _minAmountOut, address _to) external returns (uint256 tokenAmountOut, uint256 spotPriceAfter);
}
