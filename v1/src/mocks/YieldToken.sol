// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import 'src/interfaces/IYieldToken.sol';
import 'src/mocks/ERC20.sol';

contract YieldToken is IYieldToken, ERC20 {
    uint256 private redeemReturn;
    address private underlyingReturn;
    uint256 private maturityReturn;

    mapping(address => uint256) public redeemCalled;

    function redeemReturns(uint256 a) external {
        redeemReturn = a;
    }

    function redeem(address o, uint256 a) external returns (uint256) {
        redeemCalled[o] = a;
        return redeemReturn;
    }

    function underlyingReturns(address u) external {
        underlyingReturn = u;
    }

    function underlying() external view returns (address) {
        return underlyingReturn;
    }

    function maturityReturns(uint256 m) external {
        maturityReturn = m;
    }

    function maturity() external view returns (uint256) {
        return maturityReturn;
    }
}
