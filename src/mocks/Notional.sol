// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import 'src/interfaces/INotional.sol';
import 'src/interfaces/IERC20.sol';
import 'src/mocks/ERC20.sol';

contract Notional is INotional, ERC20 {
    struct RedeemArgs {
        uint256 shares;
        address receiver;
    }

    address private underlyingTokenReturn;
    uint40 private maturityReturn;
    uint256 private depositReturn;
    uint256 private maxRedeemReturn;
    uint256 private redeemReturn;

    mapping(address => uint256) public depositCalled;
    address public maxRedeemCalled;
    mapping(address => RedeemArgs) public redeemCalled;

    function getUnderlyingToken() external view returns (IERC20, int256) {
        return (IERC20(underlyingTokenReturn), 0);
    }

    function getUnderlyingTokenReturns(address u) external {
        underlyingTokenReturn = u;
    }

    function getMaturity() external view returns (uint40) {
        return maturityReturn;
    }

    function getMaturityReturns(uint256 m) external {
        maturityReturn = uint40(m);
    }

    function deposit(uint256 a, address r) external returns (uint256) {
        depositCalled[r] = a;
        uint256 current = this.balanceOf(address(0));
        balanceOfReturns(current + a);
        return depositReturn;
    }

    function depositReturns(uint256 a) external {
        depositReturn = a;
    }

    function maxRedeem(address o) external returns (uint256) {
        maxRedeemCalled = o;
        return maxRedeemReturn;
    }

    function maxRedeemReturns(uint256 m) external {
        maxRedeemReturn = m;
    }

    function redeem(
        uint256 s,
        address r,
        address o
    ) external returns (uint256) {
        redeemCalled[o] = RedeemArgs(s, r);
        return redeemReturn;
    }

    function redeemReturns(uint256 r) external {
        redeemReturn = r;
    }
}
