# Converter
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/ddf95dfbaf2df4d82b6652aff5c2effb5fee45f4/src/mocks/Converter.sol)


## State Variables
### convertCalled

```solidity
mapping(address => ConvertArg) public convertCalled;
```


## Functions
### convert


```solidity
function convert(address c, address u, uint256 a) external;
```

## Structs
### ConvertArg

```solidity
struct ConvertArg {
    address underling;
    uint256 amount;
}
```

