# Converter
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/756f41d3de7041d0b83523598284cee2b14c535e/src/mocks/Converter.sol)


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

