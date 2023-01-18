# Converter
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/756f41d3de7041d0b83523598284cee2b14c535e/src/Converter.sol)

**Inherits:**
[IConverter](/src/interfaces/IConverter.sol/contract.IConverter.md)


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


