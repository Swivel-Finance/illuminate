# PendleToken
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/ddf95dfbaf2df4d82b6652aff5c2effb5fee45f4/src/mocks/PendleToken.sol)

**Inherits:**
[ERC20](/src/mocks/ERC20.sol/contract.ERC20.md)


## State Variables
### underlyingAssetReturn

```solidity
address private underlyingAssetReturn;
```


### expiryReturn

```solidity
uint256 private expiryReturn;
```


### forgeReturn

```solidity
address private forgeReturn;
```


### underlyingYieldTokenReturn

```solidity
address private underlyingYieldTokenReturn;
```


## Functions
### underlyingAssetReturns


```solidity
function underlyingAssetReturns(address a) external;
```

### underlyingAsset


```solidity
function underlyingAsset() external view returns (address);
```

### expiryReturns


```solidity
function expiryReturns(uint256 m) external;
```

### expiry


```solidity
function expiry() external view returns (uint256);
```

### forgeReturns


```solidity
function forgeReturns(address f) external;
```

### forge


```solidity
function forge() external view returns (address);
```

### underlyingYieldTokenReturns


```solidity
function underlyingYieldTokenReturns(address u) external;
```

### underlyingYieldToken


```solidity
function underlyingYieldToken() external view returns (address);
```

