# Swivel
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/756f41d3de7041d0b83523598284cee2b14c535e/src/mocks/Swivel.sol)


## State Variables
### initateReturn

```solidity
bool private initateReturn;
```


### redeemZcTokenReturn

```solidity
bool private redeemZcTokenReturn;
```


### initiateCalledAmount

```solidity
mapping(address => uint256) public initiateCalledAmount;
```


### initiateCalledSignature

```solidity
mapping(address => uint8) public initiateCalledSignature;
```


### redeemZcTokenCalled

```solidity
mapping(address => RedeemZcTokenArgs) public redeemZcTokenCalled;
```


### underlying

```solidity
ERC20 underlying;
```


### zcToken

```solidity
ERC20 zcToken;
```


## Functions
### constructor


```solidity
constructor(address u, address z);
```

### initiateReturns


```solidity
function initiateReturns(bool i) external;
```

### initiate


```solidity
function initiate(Order[] calldata o, uint256[] calldata a, Components[] calldata s) external returns (bool);
```

### redeemZcTokenReturns


```solidity
function redeemZcTokenReturns(bool a) external;
```

### redeemZcToken


```solidity
function redeemZcToken(uint8 p, address u, uint256 m, uint256 a) external returns (bool);
```

## Structs
### RedeemZcTokenArgs

```solidity
struct RedeemZcTokenArgs {
    uint8 protocol;
    uint256 amount;
    uint256 maturity;
}
```

