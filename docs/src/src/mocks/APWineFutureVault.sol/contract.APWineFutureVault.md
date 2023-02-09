# APWineFutureVault
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/7162e4822e4bbebd99b67c43e703ecedf92a2138/src/mocks/APWineFutureVault.sol)


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

