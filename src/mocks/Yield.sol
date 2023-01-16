// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import 'src/interfaces/IYield.sol';
import 'src/mocks/ERC20.sol';

contract Yield {
    ERC20 token;

    uint32 private maturityReturn;
    uint128 private sellBaseReturn;
    uint128 private sellBasePreviewReturn;
    address private fyTokenReturn;
    address private baseReturn;

    mapping(address => uint256) public sellBaseCalled;
    uint256 public sellBasePreviewCalled;

    constructor(address t) {
        token = ERC20(t);
    }

    function maturityReturns(uint32 m) external {
        maturityReturn = m;
    }

    function maturity() external view returns (uint32) {
        return maturityReturn;
    }

    function sellBaseReturns(uint128 b) external {
        sellBaseReturn = b;
    }

    function sellBase(address t, uint128 a) external returns (uint128) {
        sellBaseCalled[t] = a;
        token.balanceOfReturns(token.balanceOf(address(0)) + a);
        return sellBaseReturn;
    }

    function sellBasePreviewReturns(uint128 b) external {
        sellBasePreviewReturn = b;
    }

    function sellBasePreview(uint128) external view returns (uint128) {
        return sellBasePreviewReturn;
    }

    function fyTokenReturns(address f) external {
        fyTokenReturn = f;
    }

    function fyToken() external view returns (address) {
        return fyTokenReturn;
    }

    function baseReturns(address b) external {
        baseReturn = b;
    }

    function base() external view returns (address) {
        return baseReturn;
    }
}
