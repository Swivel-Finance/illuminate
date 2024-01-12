// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import 'src/interfaces/IMarketPlace.sol';
import 'src/mocks/IlluminatePrincipalToken.sol';

contract MarketPlace is IMarketPlace {
    address private marketsReturn;
    address private poolsReturn;
    address private iptReturn;
    uint128 private sellPrincipalTokenReturn;
    uint128 private buyPrincipalTokenReturn;
    uint128 private sellUnderlyingReturn;
    uint128 private buyUnderlyingReturn;
    bool private pausedReturn;
    address private redeemerReturn;

    struct MarketsArgs {
        uint256 maturity;
        uint256 principal;
    }

    struct SwapTokenArgs {
        uint256 maturity;
        uint128 amount;
        uint128 slippage;
    }

    mapping(address => MarketsArgs) public marketsCalled;
    mapping(address => uint256) public poolsCalled;
    mapping(address => MarketsArgs) public iptCalled;
    mapping(address => SwapTokenArgs) public sellPrincipalTokenCalled;
    mapping(address => SwapTokenArgs) public buyPrincipalTokenCalled;
    mapping(address => SwapTokenArgs) public sellUnderlyingCalled;
    mapping(address => SwapTokenArgs) public buyUnderlyingCalled;
    uint256 public pausedCalled;

    function redeemerReturns(address r) external {
        redeemerReturn = r;
    }

    function marketsReturns(address m) external {
        marketsReturn = m;
    }

    function poolsReturns(address p) external {
        poolsReturn = p;
    }

    function iptReturns(address i) external {
        iptReturn = i;
    }

    function sellPrincipalTokenReturns(uint128 s) external {
        sellPrincipalTokenReturn = s;
    }

    function buyPrincipalTokenReturns(uint128 b) external {
        buyPrincipalTokenReturn = b;
    }

    function sellUnderlyingTokenReturns(uint128 s) external {
        sellUnderlyingReturn = s;
    }

    function buyUnderlyingTokenReturns(uint128 b) external {
        buyUnderlyingReturn = b;
    }

    /// @dev we want this to return the ipt when the user passes 0 for p
    function markets(
        address u,
        uint256 m,
        uint256 p
    ) external override returns (address) {
        if (p == 0) {
            iptCalled[u] = MarketsArgs(m, p);
            return iptReturn;
        }
        marketsCalled[u] = MarketsArgs(m, p);
        return marketsReturn;
    }

    function pools(address, uint256) external view returns (address) {
        return poolsReturn;
    }

    function pausedReturns(bool p) public {
        pausedReturn = p;
    }

    function paused(uint8 p) external returns (bool) {
        pausedCalled = p;
        return pausedReturn;
    }

    function sellPrincipalToken(
        address u,
        uint256 m,
        uint128 a,
        uint128 s
    ) external override returns (uint128) {
        sellPrincipalTokenCalled[u] = SwapTokenArgs(m, a, s);
        return sellPrincipalTokenReturn;
    }

    function buyPrincipalToken(
        address u,
        uint256 m,
        uint128 a,
        uint128 s
    ) external override returns (uint128) {
        buyPrincipalTokenCalled[u] = SwapTokenArgs(m, a, s);
        return buyPrincipalTokenReturn;
    }

    function sellUnderlying(
        address u,
        uint256 m,
        uint128 a,
        uint128 s
    ) external override returns (uint128) {
        sellUnderlyingCalled[u] = SwapTokenArgs(m, a, s);
        return sellUnderlyingReturn;
    }

    function buyUnderlying(
        address u,
        uint256 m,
        uint128 a,
        uint128 s
    ) external override returns (uint128) {
        buyUnderlyingCalled[u] = SwapTokenArgs(m, a, s);
        return buyUnderlyingReturn;
    }

    function redeemer() external view returns (address) {
        return redeemerReturn;
    }
}
