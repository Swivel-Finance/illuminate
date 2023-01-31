# Safe
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/ddf95dfbaf2df4d82b6652aff5c2effb5fee45f4/src/lib/Safe.sol)

**Author:**
Modified from Gnosis (https://github.com/gnosis/gp-v2-contracts/blob/main/src/contracts/libraries/GPv2SafeERC20.sol)

Safe ETH and ERC20 transfer library that gracefully handles missing return values.

*Use with caution! Some functions in this library knowingly create dirty bits at the destination of the free memory pointer.*


## Functions
### transfer


```solidity
function transfer(IERC20 e, address t, uint256 a) internal;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`e`|`IERC20`|Erc20 token to execute the call with|
|`t`|`address`|To address|
|`a`|`uint256`|Amount being transferred|


### transferFrom


```solidity
function transferFrom(IERC20 e, address f, address t, uint256 a) internal;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`e`|`IERC20`|Erc20 token to execute the call with|
|`f`|`address`|From address|
|`t`|`address`|To address|
|`a`|`uint256`|Amount being transferred|


### success

normalize the acceptable values of true or null vs the unacceptable value of false (or something malformed)


```solidity
function success(bool r) private pure returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`r`|`bool`|Return value from the assembly `call()` to Erc20['selector']|


### approve


```solidity
function approve(IERC20 token, address to, uint256 amount) internal;
```

### didLastOptionalReturnCallSucceed


```solidity
function didLastOptionalReturnCallSucceed(bool callStatus) private pure returns (bool);
```

