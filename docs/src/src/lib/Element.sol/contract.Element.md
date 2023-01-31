# Element
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/ddf95dfbaf2df4d82b6652aff5c2effb5fee45f4/src/lib/Element.sol)


## Structs
### SingleSwap

```solidity
struct SingleSwap {
    bytes32 poolId;
    SwapKind kind;
    IAny assetIn;
    IAny assetOut;
    uint256 amount;
    bytes userData;
}
```

### FundManagement

```solidity
struct FundManagement {
    address sender;
    bool fromInternalBalance;
    address payable recipient;
    bool toInternalBalance;
}
```

## Enums
### SwapKind

```solidity
enum SwapKind {
    GIVEN_IN,
    GIVEN_OUT
}
```

