# Swivel
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/7162e4822e4bbebd99b67c43e703ecedf92a2138/src/lib/Swivel.sol)


## Structs
### Components

```solidity
struct Components {
    uint8 v;
    bytes32 r;
    bytes32 s;
}
```

### Order

```solidity
struct Order {
    bytes32 key;
    uint8 protocol;
    address maker;
    address underlying;
    bool vault;
    bool exit;
    uint256 principal;
    uint256 premium;
    uint256 maturity;
    uint256 expiry;
}
```

