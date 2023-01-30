# Yield
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/ddf95dfbaf2df4d82b6652aff5c2effb5fee45f4/src/mocks/Yield.sol)


## State Variables
### token

```solidity
ERC20 token;
```


### maturityReturn

```solidity
uint32 private maturityReturn;
```


### sellBaseReturn

```solidity
uint128 private sellBaseReturn;
```


### sellBasePreviewReturn

```solidity
uint128 private sellBasePreviewReturn;
```


### fyTokenReturn

```solidity
address private fyTokenReturn;
```


### baseReturn

```solidity
address private baseReturn;
```


### sellBaseCalled

```solidity
mapping(address => uint256) public sellBaseCalled;
```


### sellBasePreviewCalled

```solidity
uint256 public sellBasePreviewCalled;
```


## Functions
### constructor


```solidity
constructor(address t);
```

### maturityReturns


```solidity
function maturityReturns(uint32 m) external;
```

### maturity


```solidity
function maturity() external view returns (uint32);
```

### sellBaseReturns


```solidity
function sellBaseReturns(uint128 b) external;
```

### sellBase


```solidity
function sellBase(address t, uint128 a) external returns (uint128);
```

### sellBasePreviewReturns


```solidity
function sellBasePreviewReturns(uint128 b) external;
```

### sellBasePreview


```solidity
function sellBasePreview(uint128) external view returns (uint128);
```

### fyTokenReturns


```solidity
function fyTokenReturns(address f) external;
```

### fyToken


```solidity
function fyToken() external view returns (address);
```

### baseReturns


```solidity
function baseReturns(address b) external;
```

### base


```solidity
function base() external view returns (address);
```

