# ERC5095
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/76b26ef748dc63cf89e3fa660df1bda262dcef15/src/mocks/ERC5095.sol)

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


### approveMarketPlaceReturn

```solidity
bool private approveMarketPlaceReturn;
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

### approveMarketPlaceReturns


```solidity
function approveMarketPlaceReturns(bool p) external;
```

### approveMarketPlace


```solidity
function approveMarketPlace() external view returns (bool);
```

