# Swivel
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/756f41d3de7041d0b83523598284cee2b14c535e/src/lib/Swivel.sol)


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

