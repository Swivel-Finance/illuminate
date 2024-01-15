# IMarketPlace
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/76b26ef748dc63cf89e3fa660df1bda262dcef15/src/interfaces/IMarketPlace.sol)


## Functions
### markets


```solidity
function markets(address, uint256, uint256) external returns (address);
```

### pools


```solidity
function pools(address, uint256) external view returns (address);
```

### sellPrincipalToken


```solidity
function sellPrincipalToken(address, uint256, uint128, uint128) external returns (uint128);
```

### buyPrincipalToken


```solidity
function buyPrincipalToken(address, uint256, uint128, uint128) external returns (uint128);
```

### sellUnderlying


```solidity
function sellUnderlying(address, uint256, uint128, uint128) external returns (uint128);
```

### buyUnderlying


```solidity
function buyUnderlying(address, uint256, uint128, uint128) external returns (uint128);
```

### redeemer


```solidity
function redeemer() external view returns (address);
```

