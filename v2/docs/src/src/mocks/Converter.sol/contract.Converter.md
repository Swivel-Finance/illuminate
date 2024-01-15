# Converter
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/76b26ef748dc63cf89e3fa660df1bda262dcef15/src/mocks/Converter.sol)


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

