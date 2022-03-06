// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.4;

interface IPendleRouter {
    function swapExactIn(address _tokenIn, address _tokenOut, uint256 _inAmount, uint256 _minOutAmount, bytes32 _marketFactoryId) external returns (uint256);
    function redeemAfterExpiry(bytes32 _forgeId, address _underlyingAsset, uint256 _expiry) external returns (uint256);
}