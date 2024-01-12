# Redeemer
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/76b26ef748dc63cf89e3fa660df1bda262dcef15/src/Redeemer.sol)

**Author:**
Sourabh Marathe, Julian Traversa, Rob Robbins

The Redeemer contract is used to redeem the underlying lent capital of a loan.

Users may redeem their ERC-5095 tokens for the underlying asset represented by that token after maturity.


## State Variables
### HOLD
minimum wait before the admin may withdraw funds or change the fee rate


```solidity
uint256 public constant HOLD = 3 days;
```


### admin
address that is allowed to set fees and contracts, etc. It is commonly used in the authorized modifier.


```solidity
address public admin;
```


### marketPlace
address of the MarketPlace contract, used to access the markets mapping


```solidity
address public marketPlace;
```


### lender
address that custodies principal tokens for all markets


```solidity
address public lender;
```


### converter
address that converts compounding tokens to their underlying


```solidity
address public converter;
```


### swivelAddr
third party contract needed to redeem Swivel PTs


```solidity
address public immutable swivelAddr;
```


### tempusAddr
third party contract needed to redeem Tempus PTs


```solidity
address public immutable tempusAddr;
```


### feenominator
this value determines the amount of fees paid on auto redemptions


```solidity
uint256 public feenominator;
```


### feeChange
represents a point in time where the feenominator may change


```solidity
uint256 public feeChange;
```


### MIN_FEENOMINATOR
represents a minimum that the feenominator must exceed


```solidity
uint256 public MIN_FEENOMINATOR = 500;
```


### holdings
mapping that indicates how much underlying has been redeemed by a market


```solidity
mapping(address => mapping(uint256 => uint256)) public holdings;
```


### paused
mapping that determines if a market's iPT can be redeemed


```solidity
mapping(address => mapping(uint256 => bool)) public paused;
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


### unpaused

reverts on all markets where the paused mapping returns true


```solidity
modifier unpaused(address u, uint256 m);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`u`|`address`|address of an underlying asset|
|`m`|`uint256`|maturity (timestamp) of the market|


### constructor

Initializes the Redeemer contract


```solidity
constructor(address l, address s, address t);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`l`|`address`|the lender contract|
|`s`|`address`|the Swivel contract|
|`t`|`address`|the Tempus contract|


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
|`<none>`|`bool`|bool true if successful|


### setMarketPlace

sets the address of the marketplace contract which contains the addresses of all the fixed rate markets


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


### setConverter

sets the converter address


```solidity
function setConverter(address c, address[] memory i) external authorized(admin) returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`c`|`address`|address of the new converter|
|`i`|`address[]`|a list of interest bearing tokens the redeemer will approve|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|bool true if successful|


### setLender

sets the address of the lender contract which contains the addresses of all the fixed rate markets


```solidity
function setLender(address l) external authorized(admin) returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`l`|`address`|the address of the lender contract|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|bool true if the address was set|


### setFee

sets the feenominator to the given value


```solidity
function setFee(uint256 f) external authorized(admin) returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`f`|`uint256`|the new value of the feenominator, fees are not collected when the feenominator is 0|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|bool true if successful|


### scheduleFeeChange

allows the admin to schedule a change to the fee denominators


```solidity
function scheduleFeeChange() external authorized(admin) returns (bool);
```

### pauseRedemptions

allows admin to stop redemptions of Illuminate PTs for a given market


```solidity
function pauseRedemptions(address u, uint256 m, bool b) external authorized(admin);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`u`|`address`|address of an underlying asset|
|`m`|`uint256`|maturity (timestamp) of the market|
|`b`|`bool`|true to pause, false to unpause|


### approve

approves the converter to spend the compounding asset


```solidity
function approve(address i) external authorized(marketPlace);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`i`|`address`|an interest bearing token that must be approved for conversion|


### redeem

redeem method for Yield, Element, Pendle, APWine, Tempus and Notional protocols


```solidity
function redeem(uint8 p, address u, uint256 m) external unpaused(u, m) returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`p`|`uint8`|principal value according to the MarketPlace's Principals Enum|
|`u`|`address`|address of an underlying asset|
|`m`|`uint256`|maturity (timestamp) of the market|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|bool true if the redemption was successful|


### redeem

redeem method signature for Swivel


```solidity
function redeem(uint8 p, address u, uint256 m, uint8 protocol) external unpaused(u, m) returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`p`|`uint8`|principal value according to the MarketPlace's Principals Enum|
|`u`|`address`|address of an underlying asset|
|`m`|`uint256`|maturity (timestamp) of the market|
|`protocol`|`uint8`||

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|bool true if the redemption was successful|


### redeem

redeem method signature for Sense


```solidity
function redeem(uint8 p, address u, uint256 m, uint256 s, uint256 a, address periphery)
    external
    unpaused(u, m)
    returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`p`|`uint8`|principal value according to the MarketPlace's Principals Enum|
|`u`|`address`|address of an underlying asset|
|`m`|`uint256`|maturity (timestamp) of the market|
|`s`|`uint256`|Sense's maturity is needed to extract the pt address|
|`a`|`uint256`|Sense's adapter index|
|`periphery`|`address`|Sense's periphery contract, used to get the verified adapter|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|bool true if the redemption was successful|


### redeem

burns Illuminate principal tokens and sends underlying to user


```solidity
function redeem(address u, uint256 m) external unpaused(u, m);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`u`|`address`|address of an underlying asset|
|`m`|`uint256`|maturity (timestamp) of the market|


### authRedeem

implements the redeem method for the contract to fulfill the ERC-5095 interface


```solidity
function authRedeem(address u, uint256 m, address f, address t, uint256 a)
    external
    authorized(IMarketPlace(marketPlace).markets(u, m, 0))
    unpaused(u, m)
    returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`u`|`address`|address of an underlying asset|
|`m`|`uint256`|maturity (timestamp) of the market|
|`f`|`address`|address from where the underlying asset will be burned|
|`t`|`address`|address to where the underlying asset will be transferred|
|`a`|`uint256`|amount of the Illuminate PT to be burned and redeemed|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|uint256 amount of the underlying asset that was burned|


### autoRedeem

implements a redeem method to enable third-party redemptions

*expects approvals from owners to redeemer*


```solidity
function autoRedeem(address u, uint256 m, address[] calldata f) external unpaused(u, m) returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`u`|`address`|address of the underlying asset|
|`m`|`uint256`|maturity of the market|
|`f`|`address[]`|address from where the principal token will be burned|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|uint256 amount of underlying yielded as a fee|


### depositHoldings

Allows for external deposit of underlying for a market

This is to be used in emergency situations where the redeem method is not functioning for a market


```solidity
function depositHoldings(address u, uint256 m, uint256 a) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`u`|`address`|address of the underlying asset|
|`m`|`uint256`|maturity of the market|
|`a`|`uint256`|amount of underlying to be deposited|


### apwineWithdraw

Execute the business logic for conducting an APWine redemption


```solidity
function apwineWithdraw(address p, address u, uint256 a) internal;
```

## Events
### Redeem
emitted upon redemption of a loan


```solidity
event Redeem(
    uint8 principal,
    address indexed underlying,
    uint256 indexed maturity,
    uint256 amount,
    uint256 burned,
    address sender
);
```

### SetAdmin
emitted upon changing the admin


```solidity
event SetAdmin(address indexed admin);
```

### SetConverter
emitted upon changing the converter


```solidity
event SetConverter(address indexed converter);
```

### SetFee
emitted upon setting the fee rate


```solidity
event SetFee(uint256 indexed fee);
```

### ScheduleFeeChange
emitted upon scheduling a fee change


```solidity
event ScheduleFeeChange(uint256 when);
```

### PauseRedemptions
emitted upon pausing of Illuminate PTs


```solidity
event PauseRedemptions(address indexed underlying, uint256 maturity, bool state);
```

