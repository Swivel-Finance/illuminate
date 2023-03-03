// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import 'src/mocks/ERC20.sol';

contract PendleStandardYieldToken is ERC20 {
    struct RedeemCalledArgs {
        address receiver;
        uint256 amount;
        address asset;
        uint256 minimumOut;
        bool flag;
    }

    mapping(address => RedeemCalledArgs) public redeemCalled;

    uint256 redeemReturn;

    function redeemReturns(uint256 r) external {
        redeemReturn = r;
    }

    function redeem(
        address r,
        uint256 a,
        address u,
        uint256 m,
        bool f
    ) external returns (uint256) {
        redeemCalled[r] = RedeemCalledArgs(r, a, u, m, f);

        return redeemReturn;
    }
}
