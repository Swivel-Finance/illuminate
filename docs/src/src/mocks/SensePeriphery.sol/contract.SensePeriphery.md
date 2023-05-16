# SensePeriphery
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/76b26ef748dc63cf89e3fa660df1bda262dcef15/src/mocks/SensePeriphery.sol)


## State Variables
### pt

```solidity
ERC20 pt;
```


### swapUnderlyingForPTsReturn

```solidity
uint256 private swapUnderlyingForPTsReturn;
```


### dividerReturn

```solidity
address private dividerReturn;
```


### swapUnderlyingForPTsCalled

```solidity
mapping(address => SwapUnderlyingForPTsArg) public swapUnderlyingForPTsCalled;
```


## Functions
### constructor


```solidity
constructor(address p);
```

### swapUnderlyingForPTsReturns


```solidity
function swapUnderlyingForPTsReturns(uint256 s) external;
```

### swapUnderlyingForPTs


```solidity
function swapUnderlyingForPTs(address a, uint256 s, uint256 l, uint256 m) external returns (uint256);
```

### dividerReturns


```solidity
function dividerReturns(address d) external;
```

### divider


```solidity
function divider() external view returns (address);
```

## Structs
### SwapUnderlyingForPTsArg

```solidity
struct SwapUnderlyingForPTsArg {
    uint256 maturity;
    uint256 lent;
    uint256 minReturn;
}
```

