// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

contract Pool {
    struct BuyFYTokenArg {
        uint128 fyTokenOut;
        uint128 max;
    }

    struct BuyBaseArg {
        uint128 baseOut;
        uint128 max;
    }

    struct MintArg {
        address remainder;
        uint256 minRatio;
        uint256 maxRatio;
    }

    struct MintWithBaseArg {
        address remainder;
        uint256 fyTokenToBuy;
        uint256 minRatio;
        uint256 maxRatio;
    }

    struct BurnArg {
        address fyTokenTo;
        uint256 minRatio;
        uint256 maxRatio;
    }

    struct BurnForBaseArg {
        uint256 minRatio;
        uint256 maxRatio;
    }

    struct TransferFromArgs {
        address to;
        uint256 amount;
    }

    address private fyTokenReturn;
    address private baseReturn;
    address private baseTokenReturn;
    uint128 private sellFYTokenReturn;
    uint128 private sellFYTokenPreviewReturn;
    uint128 private buyFYTokenReturn;
    uint128 private buyFYTokenPreviewReturn;
    uint128 private sellBaseReturn;
    uint128 private sellBasePreviewReturn;
    uint128 private buyBaseReturn;
    uint128 private buyBasePreviewReturn;
    uint256 private mintReturn0;
    uint256 private mintReturn1;
    uint256 private mintReturn2;
    uint256 private mintWithBaseIn;
    uint256 private mintWithBaseFyTokenIn;
    uint256 private mintWithBaseTokensMinted;
    uint256 private burnTokens;
    uint256 private burnTokenOut;
    uint256 private burnFyTokenOut;
    uint256 private burnForBaseTokensBurned;
    uint256 private burnForBaseOut;

    mapping(address => uint256) public sellFYTokenCalled;
    uint128 public sellFYTokenPreviewCalled;
    mapping(address => BuyFYTokenArg) public buyFYTokenCalled;
    uint128 public buyFYTokenPreviewCalled;
    mapping(address => uint128) public sellBaseCalled;
    uint128 public sellBasePreviewCalled;
    mapping(address => BuyBaseArg) public buyBaseCalled;
    uint128 public buyBasePreviewCalled;
    mapping(address => MintArg) public mintCalled;
    mapping(address => MintWithBaseArg) public mintWithBaseCalled;
    mapping(address => BurnArg) public burnCalled;
    mapping(address => BurnForBaseArg) public burnForBaseCalled;
    mapping(address => TransferFromArgs) public transferFromCalled;

    function fyTokenReturns(address f) external {
        fyTokenReturn = f;
    }

    function fyToken() external view returns (address f) {
        return fyTokenReturn;
    }

    function sellFYTokenReturns(uint128 s) external {
        sellFYTokenReturn = s;
    }

    function sellFYToken(address t, uint128 m) external returns (uint128) {
        sellFYTokenCalled[t] = m;
        return sellFYTokenReturn;
    }

    function sellFYTokenPreviewReturns(uint128 s) external {
        sellFYTokenPreviewReturn = s;
    }

    // todo update called (not possible due to view right now)
    function sellFYTokenPreview(uint128) external view returns (uint128) {
        return sellFYTokenPreviewReturn;
    }

    function buyFYTokenReturns(uint128 b) external {
        buyFYTokenReturn = b;
    }

    function buyFYToken(
        address t,
        uint128 f,
        uint128 m
    ) external returns (uint128) {
        buyFYTokenCalled[t] = BuyFYTokenArg(f, m);
        return buyFYTokenReturn;
    }

    function buyFYTokenPreviewReturns(uint128 b) external {
        buyFYTokenPreviewReturn = b;
    }

    // todo update called (not possible due to view right now)
    function buyFYTokenPreview(uint128) external view returns (uint128) {
        return buyFYTokenPreviewReturn;
    }

    function baseReturns(address b) external {
        baseReturn = b;
    }

    function base() external view returns (address) {
        return baseReturn;
    }

    function baseTokenReturns(address b) external {
        baseTokenReturn = b;
    }

    function baseToken() external view returns (address) {
        return baseTokenReturn;
    }

    function sellBaseReturns(uint128 s) external {
        sellBaseReturn = s;
    }

    function sellBase(address t, uint128 m) external returns (uint128) {
        sellBaseCalled[t] = m;
        return sellBaseReturn;
    }

    function sellBasePreviewReturns(uint128 b) external {
        sellBasePreviewReturn = b;
    }

    // todo update called (not possible due to view right now)
    function sellBasePreview(uint128) external view returns (uint128) {
        return sellBasePreviewReturn;
    }

    function buyBaseReturns(uint128 b) external {
        buyBaseReturn = b;
    }

    function buyBase(
        address t,
        uint128 b,
        uint128 m
    ) external returns (uint128) {
        buyBaseCalled[t] = BuyBaseArg(b, m);
        return buyBaseReturn;
    }

    function buyBasePreviewReturns(uint128 b) external {
        buyBasePreviewReturn = b;
    }

    // todo update called (not possible due to view right now)
    function buyBasePreview(uint128) external view returns (uint128) {
        return buyBasePreviewReturn;
    }

    function mintReturns(
        uint256 m0,
        uint256 m1,
        uint256 m2
    ) external {
        mintReturn0 = m0;
        mintReturn1 = m1;
        mintReturn2 = m2;
    }

    function mint(
        address t,
        address r,
        uint256 minRatio,
        uint256 maxRatio
    )
        external
        returns (
            uint256,
            uint256,
            uint256
        )
    {
        mintCalled[t] = MintArg(r, minRatio, maxRatio);
        return (mintReturn0, mintReturn1, mintReturn1);
    }

    function mintWithBaseReturns(
        uint256 b,
        uint256 f,
        uint256 t
    ) external {
        mintWithBaseIn = b;
        mintWithBaseFyTokenIn = f;
        mintWithBaseTokensMinted = t;
    }

    function mintWithBase(
        address t,
        address r,
        uint256 f,
        uint256 minRatio,
        uint256 maxRatio
    )
        external
        returns (
            uint256,
            uint256,
            uint256
        )
    {
        mintWithBaseCalled[t] = MintWithBaseArg(r, f, minRatio, maxRatio);

        return (
            mintWithBaseIn,
            mintWithBaseFyTokenIn,
            mintWithBaseTokensMinted
        );
    }

    function burnReturns(
        uint256 n,
        uint256 t,
        uint256 f
    ) external {
        burnTokens = n;
        burnTokenOut = t;
        burnFyTokenOut = f;
    }

    function burn(
        address b,
        address f,
        uint256 minRatio,
        uint256 maxRatio
    )
        external
        returns (
            uint256,
            uint256,
            uint256
        )
    {
        burnCalled[b] = BurnArg(f, minRatio, maxRatio);

        return (burnTokens, burnTokenOut, burnFyTokenOut);
    }

    function burnForBaseReturns(uint256 t, uint256 o) external {
        burnForBaseTokensBurned = t;
        burnForBaseOut = o;
    }

    function burnForBase(
        address t,
        uint256 minRatio,
        uint256 maxRatio
    ) external returns (uint256, uint256) {
        burnForBaseCalled[t] = BurnForBaseArg(minRatio, maxRatio);
        return (burnForBaseTokensBurned, burnForBaseOut);
    }

    function transferFrom(
        address f,
        address t,
        uint256 a
    ) public returns (bool) {
        TransferFromArgs memory args;
        args.to = t;
        args.amount = a;
        transferFromCalled[f] = args;
        return true;
    }
}
