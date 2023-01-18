# IMarketPlace
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/756f41d3de7041d0b83523598284cee2b14c535e/src/interfaces/IMarketPlace.sol)


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

