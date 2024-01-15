# IYield
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/76b26ef748dc63cf89e3fa660df1bda262dcef15/src/interfaces/IYield.sol)


## Functions
### maturity


```solidity
function maturity() external view returns (uint32);
```

### base


```solidity
function base() external view returns (IERC20);
```

### sellBase


```solidity
function sellBase(address, uint128) external returns (uint128);
```

### sellBasePreview


```solidity
function sellBasePreview(uint128) external view returns (uint128);
```

### fyToken


```solidity
function fyToken() external returns (address);
```

### sellFYToken


```solidity
function sellFYToken(address, uint128) external returns (uint128);
```

### sellFYTokenPreview


```solidity
function sellFYTokenPreview(uint128) external view returns (uint128);
```

### buyBase


```solidity
function buyBase(address, uint128, uint128) external returns (uint128);
```

### buyBasePreview


```solidity
function buyBasePreview(uint128) external view returns (uint128);
```

### buyFYToken


```solidity
function buyFYToken(address, uint128, uint128) external returns (uint128);
```

### buyFYTokenPreview


```solidity
function buyFYTokenPreview(uint128) external view returns (uint128);
```

