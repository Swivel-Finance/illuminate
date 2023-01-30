# Pendle
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/ddf95dfbaf2df4d82b6652aff5c2effb5fee45f4/src/mocks/Pendle.sol)


## State Variables
### pt

```solidity
address pt;
```


### swapFor

```solidity
uint256 swapFor;
```


### swapExactTokensForTokensCalled

```solidity
mapping(address => SwapExactTokensForTokensArgs) public swapExactTokensForTokensCalled;
```


### redeemAfterExpiryCalled

```solidity
mapping(address => RedeemAfterExpiryArgs) public redeemAfterExpiryCalled;
```


## Functions
### constructor


```solidity
constructor(address p);
```

### swapExactTokensForTokensFor


```solidity
function swapExactTokensForTokensFor(uint256 a) external;
```

### swapExactTokensForTokens


```solidity
function swapExactTokensForTokens(uint256 a, uint256 m, address[] calldata p, address t, uint256 d)
    external
    returns (uint256[] memory);
```

### redeemAfterExpiry


```solidity
function redeemAfterExpiry(bytes32 i, address u, uint256 m) external;
```

## Structs
### SwapExactTokensForTokensArgs

```solidity
struct SwapExactTokensForTokensArgs {
    uint256 amount;
    uint256 minimumBought;
    address[] path;
    uint256 deadline;
}
```

### RedeemAfterExpiryArgs

```solidity
struct RedeemAfterExpiryArgs {
    bytes32 forgeId;
    uint256 maturity;
}
```

