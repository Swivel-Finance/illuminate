# TempusPool
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/76b26ef748dc63cf89e3fa660df1bda262dcef15/src/mocks/TempusPool.sol)

**Inherits:**
[ITempusPool](/src/interfaces/ITempusPool.sol/interface.ITempusPool.md)


## State Variables
### maturityTimeReturn

```solidity
uint256 private maturityTimeReturn;
```


### backingTokenReturn

```solidity
address private backingTokenReturn;
```


### principalShareReturn

```solidity
address private principalShareReturn;
```


### currentInterfaceRateReturn

```solidity
uint256 private currentInterfaceRateReturn;
```


### initialInterestRateReturn

```solidity
uint256 private initialInterestRateReturn;
```


### controllerReturn

```solidity
address private controllerReturn;
```


## Functions
### maturityTimeReturns


```solidity
function maturityTimeReturns(uint256 m) external;
```

### maturityTime


```solidity
function maturityTime() external view returns (uint256);
```

### backingTokenReturns


```solidity
function backingTokenReturns(address b) external;
```

### backingToken


```solidity
function backingToken() external view returns (address);
```

### principalShareReturns


```solidity
function principalShareReturns(address p) external;
```

### principalShare


```solidity
function principalShare() external view returns (address);
```

### currentInterestRateReturns


```solidity
function currentInterestRateReturns(uint256 c) external;
```

### currentInterestRate


```solidity
function currentInterestRate() external view returns (uint256);
```

### initialInterestRateReturns


```solidity
function initialInterestRateReturns(uint256 i) external;
```

### initialInterestRate


```solidity
function initialInterestRate() external view returns (uint256);
```

### controllerReturns


```solidity
function controllerReturns(address t) external;
```

### controller


```solidity
function controller() external view returns (address);
```

