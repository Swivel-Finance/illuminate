# Lender
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/76b26ef748dc63cf89e3fa660df1bda262dcef15/src/Lender.sol)

**Author:**
Sourabh Marathe, Julian Traversa, Rob Robbins

The lender contract executes loans on behalf of users

The contract holds the principal tokens and mints an ERC-5095 tokens to users to represent their loans


## State Variables
### HOLD
minimum wait before the admin may withdraw funds or change the fee rate


```solidity
uint256 public constant HOLD = 3 days;
```


### admin
address that is allowed to set and withdraw fees, disable principals, etc. It is commonly used in the authorized modifier.


```solidity
address public admin;
```


### marketPlace
address of the MarketPlace contract, used to access the markets mapping


```solidity
address public marketPlace;
```


### paused
mapping that determines if a principal has been paused by the admin


```solidity
mapping(uint8 => bool) public paused;
```


### halted
flag that allows admin to stop all lending and minting across the entire protocol


```solidity
bool public halted;
```


### swivelAddr
contract used to execute swaps on Swivel's exchange


```solidity
address public immutable swivelAddr;
```


### pendleAddr
a SushiSwap router used by Pendle to execute swaps


```solidity
address public immutable pendleAddr;
```


### apwineAddr
a pool router used by APWine to execute swaps


```solidity
address public immutable apwineAddr;
```


### premiums
a mapping that tracks the amount of unswapped premium by market. This underlying is later transferred to the Redeemer during Swivel's redeem call


```solidity
mapping(address => mapping(uint256 => uint256)) public premiums;
```


### feenominator
this value determines the amount of fees paid on loans


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
uint256 public constant MIN_FEENOMINATOR = 500;
```


### fees
maps underlying tokens to the amount of fees accumulated for that token


```solidity
mapping(address => uint256) public fees;
```


### withdrawals
maps a token address to a point in time, a hold, after which a withdrawal can be made


```solidity
mapping(address => uint256) public withdrawals;
```


### _NOT_ENTERED

```solidity
uint256 private constant _NOT_ENTERED = 1;
```


### _ENTERED

```solidity
uint256 private constant _ENTERED = 2;
```


### _status

```solidity
uint256 private _status = _NOT_ENTERED;
```


### maximumValue
maximum amount of value that can flow through a protocol in a day (in USD)


```solidity
uint256 public maximumValue = 250_000e27;
```


### protocolFlow
maps protocols to how much value, in USD, has flowed through each protocol


```solidity
mapping(uint8 => uint256) public protocolFlow;
```


### periodStart
timestamp from which values flowing through protocol has begun


```solidity
mapping(uint8 => uint256) public periodStart;
```


### etherPrice
estimated price of ether, set by the admin


```solidity
uint256 public etherPrice = 2_500;
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
modifier unpaused(address u, uint256 m, uint8 p);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`u`|`address`|address of an underlying asset|
|`m`|`uint256`|maturity (timestamp) of the market|
|`p`|`uint8`|principal value according to the MarketPlace's Principals Enum|


### matured

reverts if called after maturity


```solidity
modifier matured(uint256 m);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`m`|`uint256`|maturity (timestamp) of the market|


### nonReentrant

prevents users from re-entering contract


```solidity
modifier nonReentrant();
```

### constructor

initializes the Lender contract


```solidity
constructor(address s, address p, address a);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`s`|`address`|the Swivel contract|
|`p`|`address`|the Pendle contract|
|`a`|`address`|the APWine contract|


### approve

approves the redeemer contract to spend the principal tokens held by the lender contract.


```solidity
function approve(address u, uint256 m, address r) external authorized(admin) returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`u`|`address`|address of an underlying asset|
|`m`|`uint256`|maturity (timestamp) of the market|
|`r`|`address`|the address being approved, in this case the redeemer contract|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|bool true if the approval was successful|


### approve

bulk approves the usage of addresses at the given ERC20 addresses.

*the lengths of the inputs must match because the arrays are paired by index*


```solidity
function approve(address[] calldata u, address[] calldata a) external authorized(admin) returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`u`|`address[]`|array of ERC20 token addresses that will be approved on|
|`a`|`address[]`|array of addresses that will be approved|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|true if successful|


### approve

approves market contracts that require lender approval


```solidity
function approve(address u, address a, address e, address n, address p) external authorized(marketPlace);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`u`|`address`|address of an underlying asset|
|`a`|`address`|APWine's router contract|
|`e`|`address`|Element's vault contract|
|`n`|`address`|Notional's token contract|
|`p`|`address`|Sense's periphery contract|


### setAdmin

sets the admin address


```solidity
function setAdmin(address a) external authorized(admin) returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a`|`address`|address of a new admin|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|bool true if successful|


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


### setEtherPrice

sets the ethereum price which is used in rate limiting


```solidity
function setEtherPrice(uint256 p) external authorized(admin) returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`p`|`uint256`|the new price|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|bool true if the price was set|


### setMaxValue

sets the maximum value that can flow through a protocol


```solidity
function setMaxValue(uint256 m) external authorized(admin) returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`m`|`uint256`|the maximum value by protocol|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|bool true if the price was set|


### mint

mint swaps the sender's principal tokens for Illuminate's ERC5095 tokens in effect, this opens a new fixed rate position for the sender on Illuminate


```solidity
function mint(uint8 p, address u, uint256 m, uint256 a) external nonReentrant unpaused(u, m, p) returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`p`|`uint8`|principal value according to the MarketPlace's Principals Enum|
|`u`|`address`|address of an underlying asset|
|`m`|`uint256`|maturity (timestamp) of the market|
|`a`|`uint256`|amount being minted|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|bool true if the mint was successful|


### lend

lend method for the Illuminate and Yield protocols


```solidity
function lend(uint8 p, address u, uint256 m, uint256 a, address y, uint256 minimum)
    external
    nonReentrant
    unpaused(u, m, p)
    matured(m)
    returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`p`|`uint8`|principal value according to the MarketPlace's Principals Enum|
|`u`|`address`|address of an underlying asset|
|`m`|`uint256`|maturity (timestamp) of the market|
|`a`|`uint256`|amount of underlying tokens to lend|
|`y`|`address`|Yield Space Pool for the principal token|
|`minimum`|`uint256`|slippage limit, minimum amount to PTs to buy|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|uint256 the amount of principal tokens lent out|


### lend

lend method signature for Swivel


```solidity
function lend(
    uint8 p,
    address u,
    uint256 m,
    uint256[] memory a,
    address y,
    Swivel.Order[] calldata o,
    Swivel.Components[] calldata s,
    bool e,
    uint256 premiumSlippage
) external nonReentrant unpaused(u, m, p) matured(m) returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`p`|`uint8`|principal value according to the MarketPlace's Principals Enum|
|`u`|`address`|address of an underlying asset|
|`m`|`uint256`|maturity (timestamp) of the market|
|`a`|`uint256[]`|array of amounts of underlying tokens lent to each order in the orders array|
|`y`|`address`|Yield Space Pool for the Illuminate PT in this market|
|`o`|`Swivel.Order[]`|array of Swivel orders being filled|
|`s`|`Swivel.Components[]`|array of signatures for each order in the orders array|
|`e`|`bool`|flag to indicate if returned funds should be swapped in Yield Space Pool|
|`premiumSlippage`|`uint256`|slippage limit, minimum amount to PTs to buy|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|uint256 the amount of principal tokens lent out|


### lend

lend method signature for Element


```solidity
function lend(uint8 p, address u, uint256 m, uint256 a, uint256 r, uint256 d, address e, bytes32 i)
    external
    nonReentrant
    unpaused(u, m, p)
    matured(m)
    returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`p`|`uint8`|principal value according to the MarketPlace's Principals Enum|
|`u`|`address`|address of an underlying asset|
|`m`|`uint256`|maturity (timestamp) of the market|
|`a`|`uint256`|amount of underlying tokens to lend|
|`r`|`uint256`|slippage limit, minimum amount to PTs to buy|
|`d`|`uint256`|deadline is a timestamp by which the swap must be executed|
|`e`|`address`|Element pool that is lent to|
|`i`|`bytes32`|the id of the pool|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|uint256 the amount of principal tokens lent out|


### lend

lend method signature for Pendle


```solidity
function lend(uint8 p, address u, uint256 m, uint256 a, uint256 r, Pendle.ApproxParams calldata g, address market)
    external
    nonReentrant
    unpaused(u, m, p)
    matured(m)
    returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`p`|`uint8`|principal value according to the MarketPlace's Principals Enum|
|`u`|`address`|address of an underlying asset|
|`m`|`uint256`|maturity (timestamp) of the market|
|`a`|`uint256`|amount of underlying tokens to lend|
|`r`|`uint256`|slippage limit, minimum amount to PTs to buy|
|`g`|`Pendle.ApproxParams`|guess parameters for the swap|
|`market`|`address`|contract that corresponds to the market for the PT|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|uint256 the amount of principal tokens lent out|


### lend

lend method signature for Tempus and APWine


```solidity
function lend(uint8 p, address u, uint256 m, uint256 a, uint256 r, uint256 d, address x)
    external
    nonReentrant
    unpaused(u, m, p)
    matured(m)
    returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`p`|`uint8`|value of a specific principal according to the Illuminate Principals Enum|
|`u`|`address`|address of an underlying asset|
|`m`|`uint256`|maturity (timestamp) of the market|
|`a`|`uint256`|amount of principal tokens to lend|
|`r`|`uint256`|minimum amount to return when executing the swap (sets a limit to slippage)|
|`d`|`uint256`|deadline is a timestamp by which the swap must be executed|
|`x`|`address`|Tempus or APWine AMM that executes the swap|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|uint256 the amount of principal tokens lent out|


### lend

lend method signature for Sense

*this method can be called before maturity to lend to Sense while minting Illuminate tokens*

*Sense provides a [divider] contract that splits [target] assets (underlying) into PTs and YTs. Each [target] asset has a [series] of contracts, each identifiable by their [maturity].*


```solidity
function lend(uint8 p, address u, uint256 m, uint128 a, uint256 r, address x, uint256 s, address adapter)
    external
    nonReentrant
    unpaused(u, m, p)
    matured(m)
    returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`p`|`uint8`|principal value according to the MarketPlace's Principals Enum|
|`u`|`address`|address of an underlying asset|
|`m`|`uint256`|maturity (timestamp) of the market|
|`a`|`uint128`|amount of underlying tokens to lend|
|`r`|`uint256`|slippage limit, minimum amount to PTs to buy|
|`x`|`address`|periphery contract that is used to conduct the swap|
|`s`|`uint256`|Sense's maturity for the given market|
|`adapter`|`address`|Sense's adapter necessary to facilitate the swap|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|uint256 the amount of principal tokens lent out|


### lend

*lend method signature for Notional*


```solidity
function lend(uint8 p, address u, uint256 m, uint256 a, uint256 r)
    external
    nonReentrant
    unpaused(u, m, p)
    matured(m)
    returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`p`|`uint8`|principal value according to the MarketPlace's Principals Enum|
|`u`|`address`|address of an underlying asset|
|`m`|`uint256`|maturity (timestamp) of the market|
|`a`|`uint256`|amount of underlying tokens to lend|
|`r`|`uint256`|slippage limit, minimum amount to PTs to buy|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|uint256 the amount of principal tokens lent out|


### scheduleWithdrawal

allows the admin to schedule the withdrawal of tokens


```solidity
function scheduleWithdrawal(address e) external authorized(admin) returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`e`|`address`|address of (erc20) token to withdraw|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|bool true if successful|


### blockWithdrawal

emergency function to block unplanned withdrawals


```solidity
function blockWithdrawal(address e) external authorized(admin) returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`e`|`address`|address of token withdrawal to block|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|bool true if successful|


### scheduleFeeChange

allows the admin to schedule a change to the fee denominators


```solidity
function scheduleFeeChange() external authorized(admin) returns (bool);
```

### blockFeeChange

Emergency function to block unplanned changes to fee structure


```solidity
function blockFeeChange() external authorized(admin) returns (bool);
```

### withdraw

allows the admin to withdraw the given token, provided the holding period has been observed


```solidity
function withdraw(address e) external authorized(admin) returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`e`|`address`|Address of token to withdraw|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|bool true if successful|


### withdrawFee

withdraws accumulated lending fees of the underlying token


```solidity
function withdrawFee(address e) external authorized(admin) returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`e`|`address`|address of the underlying token to withdraw|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|bool true if successful|


### pause

pauses a market and prevents execution of all lending for that principal


```solidity
function pause(uint8 p, bool b) external authorized(admin) returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`p`|`uint8`|principal value according to the MarketPlace's Principals Enum|
|`b`|`bool`|bool representing whether to pause or unpause|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|bool true if successful|


### pauseIlluminate

pauses Illuminate's redeem, mint and lend methods from being used


```solidity
function pauseIlluminate(bool b) external authorized(admin) returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`b`|`bool`|bool representing whether to pause or unpause Illuminate|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|bool true if successfully set|


### transferFYTs

Tranfers FYTs to Redeemer (used specifically for APWine redemptions)


```solidity
function transferFYTs(address f, uint256 a) external authorized(IMarketPlace(marketPlace).redeemer());
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`f`|`address`|FYT contract address|
|`a`|`uint256`|amount of tokens to send to the redeemer|


### transferPremium

Transfers premium from the market to Redeemer (used specifically for Swivel redemptions)


```solidity
function transferPremium(address u, uint256 m) external authorized(IMarketPlace(marketPlace).redeemer());
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`u`|`address`|address of an underlying asset|
|`m`|`uint256`|maturity (timestamp) of the market|


### batch

Allows batched call to self (this contract).


```solidity
function batch(bytes[] calldata c) external payable returns (bytes[] memory results);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`c`|`bytes[]`|An array of inputs for each call.|


### yield

swaps underlying premium via a Yield Space Pool

*this method is only used by the Yield, Illuminate and Swivel protocols*


```solidity
function yield(address u, address y, uint256 a, address r, address p, uint256 m) internal returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`u`|`address`|address of an underlying asset|
|`y`|`address`|Yield Space Pool for the principal token|
|`a`|`uint256`|amount of underlying tokens to lend|
|`r`|`address`|the receiving address for PTs|
|`p`|`address`|the principal token in the Yield Space Pool|
|`m`|`uint256`|the minimum amount to purchase|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|uint256 the amount of tokens sent to the Yield Space Pool|


### swivelAmount

returns the amount of underlying tokens to be used in a Swivel lend


```solidity
function swivelAmount(uint256[] memory a) internal pure returns (uint256);
```

### swivelVerify

reverts if any orders are not for the market


```solidity
function swivelVerify(Swivel.Order[] memory o, address u) internal pure;
```

### elementSwap

executes a swap for and verifies receipt of Element PTs


```solidity
function elementSwap(address e, Element.SingleSwap memory s, Element.FundManagement memory f, uint256 r, uint256 d)
    internal
    returns (uint256);
```

### apwineTokenPath

returns array token path required for APWine's swap method


```solidity
function apwineTokenPath() internal pure returns (uint256[] memory);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256[]`|array of uint256[] as laid out in APWine's docs|


### apwinePairPath

returns array pair path required for APWine's swap method


```solidity
function apwinePairPath() internal pure returns (uint256[] memory);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256[]`|array of uint256[] as laid out in APWine's docs|


### principalToken

retrieves the ERC5095 token for the given market


```solidity
function principalToken(address u, uint256 m) internal returns (address);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`u`|`address`|address of an underlying asset|
|`m`|`uint256`|maturity (timestamp) of the market|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address`|address of the ERC5095 token for the market|


### convertDecimals

converts principal decimal amount to underlying's decimal amount


```solidity
function convertDecimals(address u, address p, uint256 a) internal view returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`u`|`address`|address of an underlying asset|
|`p`|`address`|address of a principal token|
|`a`|`uint256`|amount denominated in principal token's decimals|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|uint256 in underlying decimals|


### rateLimit

limits the amount of funds (in USD value) that can flow through a principal in a day


```solidity
function rateLimit(uint8 p, address u, uint256 a) internal returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`p`|`uint8`|principal value according to the MarketPlace's Principals Enum|
|`u`|`address`|address of an underlying asset|
|`a`|`uint256`|amount being minted which is normalized to 18 decimals prior to check|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|bool true if successful, reverts otherwise|


## Events
### Lend
emitted upon lending to a protocol


```solidity
event Lend(
    uint8 principal,
    address indexed underlying,
    uint256 indexed maturity,
    uint256 returned,
    uint256 spent,
    address sender
);
```

### Mint
emitted upon minting Illuminate principal tokens


```solidity
event Mint(uint8 principal, address indexed underlying, uint256 indexed maturity, uint256 amount);
```

### ScheduleWithdrawal
emitted upon scheduling a withdrawal


```solidity
event ScheduleWithdrawal(address indexed token, uint256 hold);
```

### BlockWithdrawal
emitted upon blocking a scheduled withdrawal


```solidity
event BlockWithdrawal(address indexed token);
```

### SetAdmin
emitted upon changing the admin


```solidity
event SetAdmin(address indexed admin);
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

### BlockFeeChange
emitted upon blocking a scheduled fee change


```solidity
event BlockFeeChange();
```

### PausePrincipal
emitted upon pausing or unpausing of a principal


```solidity
event PausePrincipal(uint8 principal, bool indexed state);
```

### PauseIlluminate
emitted upon pausing or unpausing minting, lending and redeeming


```solidity
event PauseIlluminate(bool state);
```

