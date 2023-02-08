# Converter
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/29a4038ae0d0795d36640f068da3ac5c1dd43806/src/mocks/Converter.sol)


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

