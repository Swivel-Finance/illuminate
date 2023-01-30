# APWineFutureVault
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/ddf95dfbaf2df4d82b6652aff5c2effb5fee45f4/src/mocks/APWineFutureVault.sol)


## State Variables
### getControllerAddressReturn

```solidity
address private getControllerAddressReturn;
```


### periodDurationReturn

```solidity
uint256 private periodDurationReturn;
```


### getCurrentPeriodIndexReturn

```solidity
uint256 private getCurrentPeriodIndexReturn;
```


### getFYTofPeriodReturn

```solidity
address private getFYTofPeriodReturn;
```


### getIBTAddressReturn

```solidity
address private getIBTAddressReturn;
```


## Functions
### periodDurationReturns


```solidity
function periodDurationReturns(uint256 p) external;
```

### PERIOD_DURATION


```solidity
function PERIOD_DURATION() external view returns (uint256);
```

### getCurrentPeriodIndexReturns


```solidity
function getCurrentPeriodIndexReturns(uint256 p) external;
```

### getCurrentPeriodIndex


```solidity
function getCurrentPeriodIndex() external view returns (uint256);
```

### getFYTofPeriodReturns


```solidity
function getFYTofPeriodReturns(address f) external;
```

### getFYTofPeriod


```solidity
function getFYTofPeriod(uint256) external view returns (address);
```

### getIBTAddressReturns


```solidity
function getIBTAddressReturns(address i) external;
```

### getIBTAddress


```solidity
function getIBTAddress() external view returns (address);
```

### getControllerAddressReturns


```solidity
function getControllerAddressReturns(address c) external;
```

### getControllerAddress


```solidity
function getControllerAddress() external view returns (address);
```

