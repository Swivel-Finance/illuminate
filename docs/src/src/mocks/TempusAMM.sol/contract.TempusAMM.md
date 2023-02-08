# TempusAMM
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/29a4038ae0d0795d36640f068da3ac5c1dd43806/src/mocks/TempusAMM.sol)

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

