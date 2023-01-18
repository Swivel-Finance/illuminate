# Element
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/756f41d3de7041d0b83523598284cee2b14c535e/src/lib/Element.sol)


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

