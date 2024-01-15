// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import 'src/mocks/ERC20.sol';

contract PendleYieldToken is ERC20 {
    address public redeemPYCalled;

    uint256 redeemPYReturn;

    function redeemPYReturns(uint256 r) external {
        redeemPYReturn = r;
    }

    function redeemPY(address a) external returns (uint256) {
        redeemPYCalled = a;

        return redeemPYReturn;
    }
}
