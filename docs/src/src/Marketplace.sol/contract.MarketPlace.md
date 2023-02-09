# MarketPlace
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/7162e4822e4bbebd99b67c43e703ecedf92a2138/src/Marketplace.sol)

**Author:**
Sourabh Marathe, Julian Traversa, Rob Robbins

This contract is in charge of managing the available principals for each loan market.

In addition, this contract routes swap orders between Illuminate PTs and their respective underlying to YieldSpace pools.


## State Variables
### markets
markets are defined by a tuple that points to a fixed length array of principal token addresses.


```solidity
mapping(address => mapping(uint256 => address[9])) public markets;
```


### pools
pools map markets to their respective YieldSpace pools for the MetaPrincipal token


```solidity
mapping(address => mapping(uint256 => address)) public pools;
```


### admin
address that is allowed to create markets, set pools, etc. It is commonly used in the authorized modifier.


```solidity
address public admin;
```


### redeemer
address of the deployed redeemer contract


```solidity
address public immutable redeemer;
```


### lender
address of the deployed lender contract


```solidity
address public immutable lender;
```


### creator
address of the deployed creator contract


```solidity
address public immutable creator;
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

initializes the MarketPlace contract


```solidity
constructor(address r, address l, address c);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`r`|`address`|address of the deployed redeemer contract|
|`l`|`address`|address of the deployed lender contract|
|`c`|`address`|address of the deployed creator contract|


### createMarket

creates a new market for the given underlying token and maturity


```solidity
function createMarket(
    address u,
    uint256 m,
    address[8] calldata t,
    string calldata n,
    string calldata s,
    address a,
    address e,
    address h,
    address sensePeriphery
) external authorized(admin) returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`u`|`address`|address of an underlying asset|
|`m`|`uint256`|maturity (timestamp) of the market|
|`t`|`address[8]`|principal token addresses for this market|
|`n`|`string`|name for the Illuminate token|
|`s`|`string`|symbol for the Illuminate token|
|`a`|`address`|address of the APWine router that corresponds to this market|
|`e`|`address`|address of the Element vault that corresponds to this market|
|`h`|`address`|address of a helper contract, used for Sense approvals if active in the market|
|`sensePeriphery`|`address`|address of the Sense periphery contract that must be approved by the lender|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|bool true if successful|


### setPrincipal

allows the admin to set an individual market


```solidity
function setPrincipal(uint8 p, address u, uint256 m, address a, address h, address sensePeriphery)
    external
    authorized(admin)
    returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`p`|`uint8`|principal value according to the MarketPlace's Principals Enum|
|`u`|`address`|address of an underlying asset|
|`m`|`uint256`|maturity (timestamp) of the market|
|`a`|`address`|address of the new principal token|
|`h`|`address`|a supplementary address (apwine needs a router, element needs a vault, sense needs interest bearing asset)|
|`sensePeriphery`|`address`|address of the Sense periphery contract that must be approved by the lender|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|bool true if the principal set, false otherwise|


### setAdmin

sets the admin address


```solidity
function setAdmin(address a) external authorized(admin) returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a`|`address`|Address of a new admin|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|bool true if the admin set, false otherwise|


### setPool

sets the address for a pool


```solidity
function setPool(address u, uint256 m, address a) external authorized(admin) returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`u`|`address`|address of an underlying asset|
|`m`|`uint256`|maturity (timestamp) of the market|
|`a`|`address`|address of the pool|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|bool true if the pool set, false otherwise|


### sellPrincipalToken

sells the PT for the underlying via the pool


```solidity
function sellPrincipalToken(address u, uint256 m, uint128 a, uint128 s) external returns (uint128);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`u`|`address`|address of an underlying asset|
|`m`|`uint256`|maturity (timestamp) of the market|
|`a`|`uint128`|amount of PTs to sell|
|`s`|`uint128`|slippage cap, minimum amount of underlying that must be received|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint128`|uint128 amount of underlying bought|


### buyPrincipalToken

buys the PT for the underlying via the pool

determines how many underlying to sell by using the preview


```solidity
function buyPrincipalToken(address u, uint256 m, uint128 a, uint128 s) external returns (uint128);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`u`|`address`|address of an underlying asset|
|`m`|`uint256`|maturity (timestamp) of the market|
|`a`|`uint128`|amount of PTs to be purchased|
|`s`|`uint128`|slippage cap, maximum number of underlying that can be sold|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint128`|uint128 amount of underlying sold|


### sellUnderlying

sells the underlying for the PT via the pool


```solidity
function sellUnderlying(address u, uint256 m, uint128 a, uint128 s) external returns (uint128);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`u`|`address`|address of an underlying asset|
|`m`|`uint256`|maturity (timestamp) of the market|
|`a`|`uint128`|amount of underlying to sell|
|`s`|`uint128`|slippage cap, minimum number of PTs that must be received|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint128`|uint128 amount of PT purchased|


### buyUnderlying

buys the underlying for the PT via the pool

determines how many PTs to sell by using the preview


```solidity
function buyUnderlying(address u, uint256 m, uint128 a, uint128 s) external returns (uint128);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`u`|`address`|address of an underlying asset|
|`m`|`uint256`|maturity (timestamp) of the market|
|`a`|`uint128`|amount of underlying to be purchased|
|`s`|`uint128`|slippage cap, maximum number of PTs that can be sold|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint128`|uint128 amount of PTs sold|


### mint

mint liquidity tokens in exchange for adding underlying and PT

*amount of liquidity tokens to mint is calculated from the amount of unaccounted for PT in this contract.*

*A proportional amount of underlying tokens need to be present in this contract, also unaccounted for.*


```solidity
function mint(address u, uint256 m, uint256 b, uint256 p, uint256 minRatio, uint256 maxRatio)
    external
    returns (uint256, uint256, uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`u`|`address`|the address of the underlying token|
|`m`|`uint256`|the maturity of the principal token|
|`b`|`uint256`|number of base tokens|
|`p`|`uint256`|the principal token amount being sent|
|`minRatio`|`uint256`|minimum ratio of LP tokens to PT in the pool.|
|`maxRatio`|`uint256`|maximum ratio of LP tokens to PT in the pool.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|uint256 number of base tokens passed to the method|
|`<none>`|`uint256`|uint256 number of yield tokens passed to the method|
|`<none>`|`uint256`|uint256 the amount of tokens minted.|


### mintWithUnderlying

Mint liquidity tokens in exchange for adding only underlying

*amount of liquidity tokens is calculated from the amount of PT to buy from the pool,
plus the amount of unaccounted for PT in this contract.*


```solidity
function mintWithUnderlying(address u, uint256 m, uint256 a, uint256 p, uint256 minRatio, uint256 maxRatio)
    external
    returns (uint256, uint256, uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`u`|`address`|the address of the underlying token|
|`m`|`uint256`|the maturity of the principal token|
|`a`|`uint256`|the underlying amount being sent|
|`p`|`uint256`|amount of `PT` being bought in the Pool, from this we calculate how much underlying it will be taken in.|
|`minRatio`|`uint256`|minimum ratio of LP tokens to PT in the pool.|
|`maxRatio`|`uint256`|maximum ratio of LP tokens to PT in the pool.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|uint256 number of base tokens passed to the method|
|`<none>`|`uint256`|uint256 number of yield tokens passed to the method|
|`<none>`|`uint256`|uint256 the amount of tokens minted.|


### burn

burn liquidity tokens in exchange for underlying and PT.


```solidity
function burn(address u, uint256 m, uint256 a, uint256 minRatio, uint256 maxRatio)
    external
    returns (uint256, uint256, uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`u`|`address`|the address of the underlying token|
|`m`|`uint256`|the maturity of the principal token|
|`a`|`uint256`|the amount of liquidity tokens to burn|
|`minRatio`|`uint256`|minimum ratio of LP tokens to PT in the pool|
|`maxRatio`|`uint256`|maximum ratio of LP tokens to PT in the pool|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|uint256 amount of LP tokens burned|
|`<none>`|`uint256`|uint256 amount of base tokens received|
|`<none>`|`uint256`|uint256 amount of fyTokens received|


### burnForUnderlying

burn liquidity tokens in exchange for underlying.


```solidity
function burnForUnderlying(address u, uint256 m, uint256 a, uint256 minRatio, uint256 maxRatio)
    external
    returns (uint256, uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`u`|`address`|the address of the underlying token|
|`m`|`uint256`|the maturity of the principal token|
|`a`|`uint256`|the amount of liquidity tokens to burn|
|`minRatio`|`uint256`|minimum ratio of LP tokens to PT in the pool.|
|`maxRatio`|`uint256`|minimum ratio of LP tokens to PT in the pool.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|uint256 amount of PT tokens sent to the pool|
|`<none>`|`uint256`|uint256 amount of underlying tokens returned|


### batch

Allows batched call to self (this contract).


```solidity
function batch(bytes[] calldata c) external payable returns (bytes[] memory results);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`c`|`bytes[]`|An array of inputs for each call.|


## Events
### CreateMarket
emitted upon the creation of a new market


```solidity
event CreateMarket(
    address indexed underlying, uint256 indexed maturity, address[9] tokens, address element, address apwine
);
```

### SetPrincipal
emitted upon setting a principal token


```solidity
event SetPrincipal(address indexed underlying, uint256 indexed maturity, address indexed principal, uint8 protocol);
```

### Swap
emitted upon swapping with the pool


```solidity
event Swap(
    address indexed underlying,
    uint256 indexed maturity,
    address sold,
    address bought,
    uint256 received,
    uint256 spent,
    address spender
);
```

### Mint
emitted upon minting tokens with the pool


```solidity
event Mint(
    address indexed underlying,
    uint256 indexed maturity,
    uint256 underlyingIn,
    uint256 principalTokensIn,
    uint256 minted,
    address minter
);
```

### Burn
emitted upon burning tokens with the pool


```solidity
event Burn(
    address indexed underlying,
    uint256 indexed maturity,
    uint256 tokensBurned,
    uint256 underlyingReceived,
    uint256 principalTokensReceived,
    address burner
);
```

### SetAdmin
emitted upon changing the admin


```solidity
event SetAdmin(address indexed admin);
```

### SetPool
emitted upon setting a pool


```solidity
event SetPool(address indexed underlying, uint256 indexed maturity, address indexed pool);
```

## Enums
### Principals
the available principals

*the order of this enum is used to select principals from the markets
mapping (e.g. Illuminate => 0, Swivel => 1, and so on)*


```solidity
enum Principals {
    Illuminate,
    Swivel,
    Yield,
    Element,
    Pendle,
    Tempus,
    Sense,
    Apwine,
    Notional
}
```

