# APWineRouter
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/7162e4822e4bbebd99b67c43e703ecedf92a2138/src/mocks/APWineRouter.sol)


## State Variables
### pt

```solidity
ERC20 pt;
```


### swapExactAmountInReturn

```solidity
uint256 private swapExactAmountInReturn;
```


### swapExactAmountInCalled

```solidity
mapping(address => SwapExactAmountInArg) public swapExactAmountInCalled;
```


## Functions
### constructor


```solidity
constructor(address p);
```

### swapExactAmountInReturns


```solidity
function swapExactAmountInReturns(uint256 s) external;
```

### swapExactAmountIn


```solidity
function swapExactAmountIn(
    address principalToken,
    uint256[] calldata pairPath,
    uint256[] calldata tokenPath,
    uint256 lent,
    uint256 minReturn,
    address recipient,
    uint256 deadline,
    address refCode
) external returns (uint256);
```

## Structs
### SwapExactAmountInArg

```solidity
struct SwapExactAmountInArg {
    address principalToken;
    uint256[] pairPath;
    uint256[] tokenPath;
    uint256 lent;
    uint256 minReturn;
    uint256 deadline;
    address refCode;
}
```

