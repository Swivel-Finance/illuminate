# Lender
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/ddf95dfbaf2df4d82b6652aff5c2effb5fee45f4/src/mocks/Lender.sol)


## State Variables
### approveCalled

```solidity
mapping(address => ApproveArgs) public approveCalled;
```


### transferFYTsCalled

```solidity
mapping(address => uint256) public transferFYTsCalled;
```


### transferPremiumCalled

```solidity
mapping(address => uint256) public transferPremiumCalled;
```


### pausedCalled

```solidity
mapping(uint8 => bool) public pausedCalled;
```


### illuminatePausedReturn

```solidity
bool private illuminatePausedReturn;
```


### pausedReturn

```solidity
bool private pausedReturn;
```


## Functions
### approve


```solidity
function approve(address u, address a, address e, address n, address p) external;
```

### transferFYTs


```solidity
function transferFYTs(address f, uint256 a) external;
```

### transferPremium


```solidity
function transferPremium(address u, uint256 m) external;
```

### illuminatePausedReturns


```solidity
function illuminatePausedReturns(bool a) external;
```

### halted


```solidity
function halted() external view returns (bool);
```

### pausedReturns


```solidity
function pausedReturns(bool a) external;
```

### paused


```solidity
function paused(uint8 p) external;
```

## Structs
### ApproveArgs

```solidity
struct ApproveArgs {
    address apwine;
    address element;
    address notional;
    address sense;
}
```

