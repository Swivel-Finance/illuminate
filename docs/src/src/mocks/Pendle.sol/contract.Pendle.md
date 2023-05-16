# Pendle
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/76b26ef748dc63cf89e3fa660df1bda262dcef15/src/mocks/Pendle.sol)


## State Variables
### pt

```solidity
address pt;
```


### swapFor

```solidity
uint256 swapFor;
```


### swapExactTokenForPtCalled

```solidity
mapping(address => SwapExactTokenForPtArgs) public swapExactTokenForPtCalled;
```


## Functions
### constructor


```solidity
constructor(address p);
```

### swapExactTokensForTokensFor


```solidity
function swapExactTokensForTokensFor(uint256 a) external;
```

### swapExactTokenForPt


```solidity
function swapExactTokenForPt(
    address r,
    address m,
    uint256 minimum,
    plib.Pendle.ApproxParams calldata g,
    plib.Pendle.TokenInput calldata t
) external returns (uint256, uint256);
```

## Structs
### SwapExactTokenForPtArgs

```solidity
struct SwapExactTokenForPtArgs {
    address receiver;
    address market;
    uint256 minimum;
    plib.Pendle.ApproxParams guess;
    plib.Pendle.TokenInput input;
}
```

