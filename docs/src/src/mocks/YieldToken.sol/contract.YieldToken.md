# YieldToken
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/7162e4822e4bbebd99b67c43e703ecedf92a2138/src/mocks/YieldToken.sol)

**Inherits:**
[IYieldToken](/src/interfaces/IYieldToken.sol/contract.IYieldToken.md), [ERC20](/src/mocks/ERC20.sol/contract.ERC20.md)


## State Variables
### redeemReturn

```solidity
uint256 private redeemReturn;
```


### underlyingReturn

```solidity
address private underlyingReturn;
```


### maturityReturn

```solidity
uint256 private maturityReturn;
```


### redeemCalled

```solidity
mapping(address => uint256) public redeemCalled;
```


## Functions
### redeemReturns


```solidity
function redeemReturns(uint256 a) external;
```

### redeem


```solidity
function redeem(address o, uint256 a) external returns (uint256);
```

### underlyingReturns


```solidity
function underlyingReturns(address u) external;
```

### underlying


```solidity
function underlying() external view returns (address);
```

### maturityReturns


```solidity
function maturityReturns(uint256 m) external;
```

### maturity


```solidity
function maturity() external view returns (uint256);
```

