# Element
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/76b26ef748dc63cf89e3fa660df1bda262dcef15/src/lib/Element.sol)


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

