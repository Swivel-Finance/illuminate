# TempusAMM
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/756f41d3de7041d0b83523598284cee2b14c535e/src/mocks/TempusAMM.sol)

**Inherits:**
[ITempusAMM](/src/interfaces/ITempusAMM.sol/contract.ITempusAMM.md)


## State Variables
### balanceOfReturn

```solidity
uint256 private balanceOfReturn;
```


### tempusPoolReturn

```solidity
address private tempusPoolReturn;
```


## Functions
### balanceOfReturns


```solidity
function balanceOfReturns(uint256 b) external;
```

### balanceOf


```solidity
function balanceOf(address) external view returns (uint256);
```

### tempusPoolReturns


```solidity
function tempusPoolReturns(address p) external;
```

### tempusPool


```solidity
function tempusPool() external view returns (address);
```

