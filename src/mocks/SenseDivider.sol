// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.16;

import 'src/mocks/ERC20.sol';

contract SenseDivider {
    struct RedeemArg {
        uint256 senseMaturity;
        uint256 amount;
    }

    uint256 private redeemReturn;
    address private ptReturn;
    address private adapterAddressesReturn;

    mapping(address => RedeemArg) public redeemCalled;
    mapping(address => uint256) public ptCalled;

    ERC20 token;

    constructor(address p) {
        token = ERC20(p);
    }

    function redeemReturns(uint256 r) external {
        redeemReturn = r;
    }

    function redeem(
        address a,
        uint256 s,
        uint256 amount
    ) external returns (uint256) {
        token.balanceOfReturns(token.balanceOf(address(0)) + amount);
        redeemCalled[a] = RedeemArg(s, amount);
        return redeemReturn;
    }

    function ptReturns(address p) external {
        ptReturn = p;
    }

    function pt(address, uint256) external view returns (address) {
        return ptReturn;
    }

    function adapterAddressesReturns(address a) external {
        adapterAddressesReturn = a;
    }

    function adapterAddresses(uint256) external view returns (address) {
        return adapterAddressesReturn;
    }
}
