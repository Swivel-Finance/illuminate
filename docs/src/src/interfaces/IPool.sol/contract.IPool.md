# IPool
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/7162e4822e4bbebd99b67c43e703ecedf92a2138/src/interfaces/IPool.sol)


## Functions
### ts


```solidity
function ts() external view returns (int128);
```

### g1


```solidity
function g1() external view returns (int128);
```

### g2


```solidity
function g2() external view returns (int128);
```

### maturity


```solidity
function maturity() external view returns (uint32);
```

### scaleFactor


```solidity
function scaleFactor() external view returns (uint96);
```

### getCache


```solidity
function getCache() external view returns (uint112, uint112, uint32);
```

### base


```solidity
function base() external view returns (IERC20);
```

### baseToken


```solidity
function baseToken() external view returns (address);
```

### fyToken


```solidity
function fyToken() external view returns (IERC5095);
```

### getBaseBalance


```solidity
function getBaseBalance() external view returns (uint112);
```

### getFYTokenBalance


```solidity
function getFYTokenBalance() external view returns (uint112);
```

### retrieveBase


```solidity
function retrieveBase(address) external returns (uint128 retrieved);
```

### retrieveFYToken


```solidity
function retrieveFYToken(address) external returns (uint128 retrieved);
```

### sellBase


```solidity
function sellBase(address, uint128) external returns (uint128);
```

### buyBase


```solidity
function buyBase(address, uint128, uint128) external returns (uint128);
```

### sellFYToken


```solidity
function sellFYToken(address, uint128) external returns (uint128);
```

### buyFYToken


```solidity
function buyFYToken(address, uint128, uint128) external returns (uint128);
```

### sellBasePreview


```solidity
function sellBasePreview(uint128) external view returns (uint128);
```

### buyBasePreview


```solidity
function buyBasePreview(uint128) external view returns (uint128);
```

### sellFYTokenPreview


```solidity
function sellFYTokenPreview(uint128) external view returns (uint128);
```

### buyFYTokenPreview


```solidity
function buyFYTokenPreview(uint128) external view returns (uint128);
```

### mint


```solidity
function mint(address, address, uint256, uint256) external returns (uint256, uint256, uint256);
```

### mintWithBase


```solidity
function mintWithBase(address, address, uint256, uint256, uint256) external returns (uint256, uint256, uint256);
```

### burn


```solidity
function burn(address, address, uint256, uint256) external returns (uint256, uint256, uint256);
```

### burnForBase


```solidity
function burnForBase(address, uint256, uint256) external returns (uint256, uint256);
```

### cumulativeBalancesRatio


```solidity
function cumulativeBalancesRatio() external view returns (uint256);
```

### sync


```solidity
function sync() external;
```

