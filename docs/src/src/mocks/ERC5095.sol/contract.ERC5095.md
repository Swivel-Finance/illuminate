# ERC5095
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/756f41d3de7041d0b83523598284cee2b14c535e/src/mocks/ERC5095.sol)

**Inherits:**
[ERC20](/src/mocks/ERC20.sol/contract.ERC20.md)


## State Variables
### poolReturn

```solidity
address private poolReturn;
```


### setPoolReturn

```solidity
bool private setPoolReturn;
```


### setPoolCalled

```solidity
address public setPoolCalled;
```


## Functions
### poolReturns


```solidity
function poolReturns(address p) external;
```

### pool


```solidity
function pool() external view returns (address);
```

### setPoolReturns


```solidity
function setPoolReturns(bool p) external;
```

### setPool


```solidity
function setPool(address p) external returns (bool);
```

