# Converter
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/7162e4822e4bbebd99b67c43e703ecedf92a2138/src/mocks/Converter.sol)


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

