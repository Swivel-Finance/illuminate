// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import 'src/mocks/ERC20.sol';

struct Components {
    uint8 v;
    bytes32 r;
    bytes32 s;
}

struct Order {
    bytes32 key;
    uint8 protocol;
    address maker;
    address underlying;
    bool vault;
    bool exit;
    uint256 principal;
    uint256 premium;
    uint256 maturity;
    uint256 expiry;
}

contract Swivel {
    struct RedeemZcTokenArgs {
        uint8 protocol;
        uint256 amount;
        uint256 maturity;
    }

    bool private initateReturn;
    bool private redeemZcTokenReturn;

    mapping(address => uint256) public initiateCalledAmount;
    mapping(address => uint8) public initiateCalledSignature;
    mapping(address => RedeemZcTokenArgs) public redeemZcTokenCalled;

    ERC20 underlying;
    ERC20 zcToken;

    constructor(address u, address z) {
        underlying = ERC20(u);
        zcToken = ERC20(z);
    }

    function initiateReturns(bool i) external {
        initateReturn = i;
    }

    function initiate(
        Order[] calldata o,
        uint256[] calldata a,
        Components[] calldata s
    ) external returns (bool) {
        uint256 amount;
        for (uint256 i = 0; i != o.length; i++) {
            initiateCalledAmount[o[i].maker] += a[i];
            initiateCalledSignature[o[i].maker] = s[i].v;
            amount += a[i];
        }
        zcToken.balanceOfReturns(amount);
        ERC20(o[0].underlying).balanceOfReturns(amount / 2);
        return initateReturn;
    }

    function redeemZcTokenReturns(bool a) external {
        redeemZcTokenReturn = a;
    }

    function redeemZcToken(
        uint8 p,
        address u,
        uint256 m,
        uint256 a
    ) external returns (bool) {
        uint256 starting = underlying.balanceOf(address(0));
        underlying.balanceOfReturns(starting + a);
        redeemZcTokenCalled[u] = RedeemZcTokenArgs(p, a, m);
        return redeemZcTokenReturn;
    }
}
