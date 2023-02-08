# Converter
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/29a4038ae0d0795d36640f068da3ac5c1dd43806/src/Converter.sol)

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


