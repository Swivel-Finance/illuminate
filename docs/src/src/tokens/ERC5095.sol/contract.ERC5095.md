# ERC5095
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/756f41d3de7041d0b83523598284cee2b14c535e/src/tokens/ERC5095.sol)

**Inherits:**
[ERC20Permit](/src/tokens/ERC20Permit.sol/contract.ERC20Permit.md), [IERC5095](/src/interfaces/IERC5095.sol/contract.IERC5095.md)


## State Variables
### maturity
*unix timestamp when the ERC5095 token can be redeemed*


```solidity
uint256 public immutable override maturity;
```


### underlying
*address of the ERC20 token that is returned on ERC5095 redemption*


```solidity
address public immutable override underlying;
```


### lender
*address of the minting authority*


```solidity
address public immutable lender;
```


### marketplace
*address of the "marketplace" YieldSpace AMM router*


```solidity
address public immutable marketplace;
```


### pool
*Interface to interact with the pool*


```solidity
address public pool;
```


### redeemer
*address and interface for an external custody contract (necessary for some project's backwards compatability)*


```solidity
address public immutable redeemer;
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


```solidity
constructor(
    address _underlying,
    uint256 _maturity,
    address _redeemer,
    address _lender,
    address _marketplace,
    string memory name_,
    string memory symbol_,
    uint8 decimals_
) ERC20Permit(name_, symbol_, decimals_);
```

### setPool

Allows the marketplace to set the pool


```solidity
function setPool(address p) external authorized(marketplace) returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`p`|`address`|Address of the pool|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|bool True if successful|


### convertToUnderlying

Post or at maturity, converts an amount of principal tokens to an amount of underlying that would be returned.


```solidity
function convertToUnderlying(uint256 s) external view override returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`s`|`uint256`|The amount of principal tokens to convert|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|uint256 The amount of underlying tokens returned by the conversion|


### convertToShares

Post or at maturity, converts a desired amount of underlying tokens returned to principal tokens needed.


```solidity
function convertToShares(uint256 a) external view override returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a`|`uint256`|The amount of underlying tokens to convert|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|uint256 The amount of principal tokens returned by the conversion|


### maxRedeem

Returns user's PT balance


```solidity
function maxRedeem(address o) external view override returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`o`|`address`|The address of the owner for which redemption is calculated|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|uint256 The maximum amount of principal tokens that `owner` can redeem.|


### maxWithdraw

Post or at maturity, returns user's PT balance. Prior to maturity, returns a previewRedeem for owner's PT balance.


```solidity
function maxWithdraw(address o) external view override returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`o`|`address`|The address of the owner for which withdrawal is calculated|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|uint256 maximum amount of underlying tokens that `owner` can withdraw.|


### previewDeposit

Post or at maturity, returns 0. Prior to maturity, returns the amount of `shares` when spending `assets` in underlying on a YieldSpace AMM.


```solidity
function previewDeposit(uint256 a) public view returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a`|`uint256`|The amount of underlying spent|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|uint256 The amount of PT purchased by spending `assets` of underlying|


### previewMint

Post or at maturity, returns 0. Prior to maturity, returns the amount of `assets` in underlying spent on a purchase of `shares` in PT on a YieldSpace AMM.


```solidity
function previewMint(uint256 s) public view returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`s`|`uint256`|The amount of principal tokens bought in the simulation|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|uint256 The amount of underlying spent to purchase `shares` of PT|


### previewRedeem

Post or at maturity, simulates the effects of redeemption at the current block. Prior to maturity, returns the amount of `assets from a sale of `shares` in PT from a sale of PT on a YieldSpace AMM.


```solidity
function previewRedeem(uint256 s) public view override returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`s`|`uint256`|The amount of principal tokens redeemed in the simulation|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|uint256 The amount of underlying returned by `shares` of PT redemption|


### previewWithdraw

Post or at maturity, simulates the effects of withdrawal at the current block. Prior to maturity, simulates the amount of PTs necessary to receive `assets` in underlying from the sale of PTs on a YieldSpace AMM.


```solidity
function previewWithdraw(uint256 a) public view override returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a`|`uint256`|The amount of underlying tokens withdrawn in the simulation|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|uint256 The amount of principal tokens required for the withdrawal of `assets`|


### deposit

Before maturity spends `assets` of underlying, and sends `shares` of PTs to `receiver`. Post or at maturity, reverts.


```solidity
function deposit(address r, uint256 a) external override returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`r`|`address`|The receiver of the principal tokens|
|`a`|`uint256`|The amount of underlying tokens deposited|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|uint256 The amount of principal tokens burnt by the withdrawal|


### mint

Before maturity mints `shares` of PTs to `receiver` by spending underlying. Post or at maturity, reverts.


```solidity
function mint(address r, uint256 s) external override returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`r`|`address`|The receiver of the underlying tokens being withdrawn|
|`s`|`uint256`|The amount of underlying tokens withdrawn|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|uint256 The amount of principal tokens burnt by the withdrawal|


### withdraw

At or after maturity, burns `a` PTs from owner and sends underlying to `receiver`. Before maturity, sends `assets` by selling shares of PT on a YieldSpace AMM.


```solidity
function withdraw(uint256 a, address r, address o) external override returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a`|`uint256`|The amount of underlying tokens withdrawn|
|`r`|`address`|The receiver of the underlying tokens being withdrawn|
|`o`|`address`|The owner of the underlying tokens|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|uint256 The amount of principal tokens burnt by the withdrawal|


### redeem

At or after maturity, burns exactly `shares` of Principal Tokens from `owner` and sends `assets` of underlying tokens to `receiver`. Before maturity, sends `assets` by selling `shares` of PT on a YieldSpace AMM.


```solidity
function redeem(uint256 s, address r, address o) external override returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`s`|`uint256`|The number of shares to be burned in exchange for the underlying asset|
|`r`|`address`|The receiver of the underlying tokens being withdrawn|
|`o`|`address`|Address of the owner of the shares being burned|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|uint256 The amount of underlying tokens distributed by the redemption|


### authBurn


```solidity
function authBurn(address f, uint256 a) external authorized(redeemer) returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`f`|`address`|Address to burn from|
|`a`|`uint256`|Amount to burn|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|bool true if successful|


### authMint


```solidity
function authMint(address t, uint256 a) external authorized(lender) returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`t`|`address`|Address recieving the minted amount|
|`a`|`uint256`|The amount to mint|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|bool True if successful|


### authApprove


```solidity
function authApprove(address o, address s, uint256 a) external authorized(redeemer) returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`o`|`address`|Address of the owner of the tokens|
|`s`|`address`|Address of the spender|
|`a`|`uint256`|Amount to be approved|


