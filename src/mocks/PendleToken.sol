// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import 'src/mocks/ERC20.sol';

contract PendleToken is ERC20 {
    address private underlyingAssetReturn;
    uint256 private expiryReturn;
    address private forgeReturn;
    address private underlyingYieldTokenReturn;

    function underlyingAssetReturns(address a) external {
        underlyingAssetReturn = a;
    }

    function underlyingAsset() external view returns (address) {
        return underlyingAssetReturn;
    }

    function expiryReturns(uint256 m) external {
        expiryReturn = m;
    }

    function expiry() external view returns (uint256) {
        return expiryReturn;
    }

    function forgeReturns(address f) external {
        forgeReturn = f;
    }

    function forge() external view returns (address) {
        return forgeReturn;
    }

    function underlyingYieldTokenReturns(address u) external {
        underlyingYieldTokenReturn = u;
    }

    function underlyingYieldToken() external view returns (address) {
        return underlyingYieldTokenReturn;
    }
}
