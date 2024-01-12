# ElementToken
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/76b26ef748dc63cf89e3fa660df1bda262dcef15/src/mocks/ElementToken.sol)

**Inherits:**
[ERC20](/src/mocks/ERC20.sol/contract.ERC20.md)


## State Variables
### underlyingReturn

```solidity
address private underlyingReturn;
```


### unlockTimestampReturn

```solidity
uint256 private unlockTimestampReturn;
```


### withdrawPrincipalReturn

```solidity
uint256 private withdrawPrincipalReturn;
```


### withdrawPrincipalCalled

```solidity
mapping(address => uint256) public withdrawPrincipalCalled;
```


## Functions
### unlockTimestampReturns


```solidity
function unlockTimestampReturns(uint256 u) external;
```

### underlyingReturns


```solidity
function underlyingReturns(address a) external;
```

### unlockTimestamp


```solidity
function unlockTimestamp() external view returns (uint256);
```

### underlying


```solidity
function underlying() external view returns (address);
```

### withdrawPrincipalReturns


```solidity
function withdrawPrincipalReturns(uint256 w) external;
```

### withdrawPrincipal


```solidity
function withdrawPrincipal(uint256 a, address d) external returns (uint256);
```

