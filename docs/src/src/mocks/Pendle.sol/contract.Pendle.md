# Pendle
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/29a4038ae0d0795d36640f068da3ac5c1dd43806/src/mocks/Pendle.sol)


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

