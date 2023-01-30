# MarketPlace
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/ddf95dfbaf2df4d82b6652aff5c2effb5fee45f4/src/mocks/MarketPlace.sol)

**Inherits:**
[IMarketPlace](/src/interfaces/IMarketPlace.sol/contract.IMarketPlace.md)


## State Variables
### marketsReturn

```solidity
address private marketsReturn;
```


### poolsReturn

```solidity
address private poolsReturn;
```


### iptReturn

```solidity
address private iptReturn;
```


### sellPrincipalTokenReturn

```solidity
uint128 private sellPrincipalTokenReturn;
```


### buyPrincipalTokenReturn

```solidity
uint128 private buyPrincipalTokenReturn;
```


### sellUnderlyingReturn

```solidity
uint128 private sellUnderlyingReturn;
```


### buyUnderlyingReturn

```solidity
uint128 private buyUnderlyingReturn;
```


### pausedReturn

```solidity
bool private pausedReturn;
```


### redeemerReturn

```solidity
address private redeemerReturn;
```


### marketsCalled

```solidity
mapping(address => MarketsArgs) public marketsCalled;
```


### poolsCalled

```solidity
mapping(address => uint256) public poolsCalled;
```


### iptCalled

```solidity
mapping(address => MarketsArgs) public iptCalled;
```


### sellPrincipalTokenCalled

```solidity
mapping(address => SwapTokenArgs) public sellPrincipalTokenCalled;
```


### buyPrincipalTokenCalled

```solidity
mapping(address => SwapTokenArgs) public buyPrincipalTokenCalled;
```


### sellUnderlyingCalled

```solidity
mapping(address => SwapTokenArgs) public sellUnderlyingCalled;
```


### buyUnderlyingCalled

```solidity
mapping(address => SwapTokenArgs) public buyUnderlyingCalled;
```


### pausedCalled

```solidity
uint256 public pausedCalled;
```


## Functions
### redeemerReturns


```solidity
function redeemerReturns(address r) external;
```

### marketsReturns


```solidity
function marketsReturns(address m) external;
```

### poolsReturns


```solidity
function poolsReturns(address p) external;
```

### iptReturns


```solidity
function iptReturns(address i) external;
```

### sellPrincipalTokenReturns


```solidity
function sellPrincipalTokenReturns(uint128 s) external;
```

### buyPrincipalTokenReturns


```solidity
function buyPrincipalTokenReturns(uint128 b) external;
```

### sellUnderlyingTokenReturns


```solidity
function sellUnderlyingTokenReturns(uint128 s) external;
```

### buyUnderlyingTokenReturns


```solidity
function buyUnderlyingTokenReturns(uint128 b) external;
```

### markets

*we want this to return the ipt when the user passes 0 for p*


```solidity
function markets(address u, uint256 m, uint256 p) external override returns (address);
```

### pools


```solidity
function pools(address, uint256) external view returns (address);
```

### pausedReturns


```solidity
function pausedReturns(bool p) public;
```

### paused


```solidity
function paused(uint8 p) external returns (bool);
```

### sellPrincipalToken


```solidity
function sellPrincipalToken(address u, uint256 m, uint128 a, uint128 s) external override returns (uint128);
```

### buyPrincipalToken


```solidity
function buyPrincipalToken(address u, uint256 m, uint128 a, uint128 s) external override returns (uint128);
```

### sellUnderlying


```solidity
function sellUnderlying(address u, uint256 m, uint128 a, uint128 s) external override returns (uint128);
```

### buyUnderlying


```solidity
function buyUnderlying(address u, uint256 m, uint128 a, uint128 s) external override returns (uint128);
```

### redeemer


```solidity
function redeemer() external view returns (address);
```

## Structs
### MarketsArgs

```solidity
struct MarketsArgs {
    uint256 maturity;
    uint256 principal;
}
```

### SwapTokenArgs

```solidity
struct SwapTokenArgs {
    uint256 maturity;
    uint128 amount;
    uint128 slippage;
}
```

