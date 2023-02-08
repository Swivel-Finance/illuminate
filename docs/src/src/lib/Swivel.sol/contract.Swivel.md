# Swivel
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/29a4038ae0d0795d36640f068da3ac5c1dd43806/src/lib/Swivel.sol)


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

