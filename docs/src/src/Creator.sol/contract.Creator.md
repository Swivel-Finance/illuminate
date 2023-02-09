# Creator
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/7162e4822e4bbebd99b67c43e703ecedf92a2138/src/Creator.sol)


## State Variables
### admin
address that is allowed to create markets and set contracts. It is commonly used in the authorized modifier.


```solidity
address public admin;
```


### marketPlace
the marketplace contract that is allowed to create markets


```solidity
address public marketPlace;
```


## Functions
### authorized

ensures that only a certain address can call the function


```solidity
modifier authorized(address a);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a`|`address`|address that msg.sender must be to be authorized|


### constructor

initializes the Creator contract


```solidity
constructor();
```

### create

creates a new market for the given underlying token and maturity


```solidity
function create(address u, uint256 m, address r, address l, address mp, string calldata n, string calldata s)
    external
    authorized(marketPlace)
    returns (address);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`u`|`address`|address of an underlying asset|
|`m`|`uint256`|maturity (timestamp) of the market|
|`r`|`address`|address of the redeemer contract|
|`l`|`address`|address of the lender contract|
|`mp`|`address`|address of the marketPlace contract|
|`n`|`string`|name for the Illuminate token|
|`s`|`string`|symbol for the Illuminate token|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|address of the new Illuminate principal token|


### setMarketPlace

sets the address of the marketplace contract


```solidity
function setMarketPlace(address m) external authorized(admin) returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`m`|`address`|the address of the marketplace contract|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|bool true if the address was set|


