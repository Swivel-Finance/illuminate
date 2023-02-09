# Pendle
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/7162e4822e4bbebd99b67c43e703ecedf92a2138/src/lib/Pendle.sol)


## Structs
### ApproxParams

```solidity
struct ApproxParams {
    uint256 guessMin;
    uint256 guessMax;
    uint256 guessOffchain;
    uint256 maxIteration;
    uint256 eps;
}
```

### TokenInput

```solidity
struct TokenInput {
    address tokenIn;
    uint256 netTokenIn;
    address tokenMintSy;
    address bulk;
    address kyberRouter;
    bytes kybercall;
}
```

