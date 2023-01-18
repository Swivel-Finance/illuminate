# SenseAdapter
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/756f41d3de7041d0b83523598284cee2b14c535e/src/mocks/SenseAdapter.sol)


## State Variables
### underlyingReturn

```solidity
address private underlyingReturn;
```


### dividerReturn

```solidity
address private dividerReturn;
```


### targetReturn

```solidity
address private targetReturn;
```


### maxmReturn

```solidity
uint256 private maxmReturn;
```


## Functions
### underlyingReturns


```solidity
function underlyingReturns(address u) external;
```

### underlying


```solidity
function underlying() external view returns (address);
```

### dividerReturns


```solidity
function dividerReturns(address d) external;
```

### divider


```solidity
function divider() external view returns (address);
```

### targetReturns


```solidity
function targetReturns(address t) external;
```

### target


```solidity
function target() external view returns (address);
```

### maxmReturns


```solidity
function maxmReturns(uint256 m) external;
```

### maxm


```solidity
function maxm() external view returns (uint256);
```

