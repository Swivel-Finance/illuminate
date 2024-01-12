# Converter
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/76b26ef748dc63cf89e3fa660df1bda262dcef15/src/Converter.sol)

**Inherits:**
[IConverter](/src/interfaces/IConverter.sol/interface.IConverter.md)


## Functions
### convert

converts the compounding asset to the underlying asset for msg.sender

*currently supports Compound, Aave and Lido conversions*


```solidity
function convert(address c, address u, uint256 a) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`c`|`address`|address of the compounding token|
|`u`|`address`|address of the underlying token|
|`a`|`uint256`|amount of tokens to convert|


