# Notional
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/756f41d3de7041d0b83523598284cee2b14c535e/src/mocks/Notional.sol)

**Inherits:**
[INotional](/src/interfaces/INotional.sol/contract.INotional.md), [ERC20](/src/mocks/ERC20.sol/contract.ERC20.md)


## State Variables
### underlyingTokenReturn

```solidity
address private underlyingTokenReturn;
```


### maturityReturn

```solidity
uint40 private maturityReturn;
```


### depositReturn

```solidity
uint256 private depositReturn;
```


### maxRedeemReturn

```solidity
uint256 private maxRedeemReturn;
```


### redeemReturn

```solidity
uint256 private redeemReturn;
```


### depositCalled

```solidity
mapping(address => uint256) public depositCalled;
```


### maxRedeemCalled

```solidity
address public maxRedeemCalled;
```


### redeemCalled

```solidity
mapping(address => RedeemArgs) public redeemCalled;
```


## Functions
### getUnderlyingToken


```solidity
function getUnderlyingToken() external view returns (IERC20, int256);
```

### getUnderlyingTokenReturns


```solidity
function getUnderlyingTokenReturns(address u) external;
```

### getMaturity


```solidity
function getMaturity() external view returns (uint40);
```

### getMaturityReturns


```solidity
function getMaturityReturns(uint256 m) external;
```

### deposit


```solidity
function deposit(uint256 a, address r) external returns (uint256);
```

### depositReturns


```solidity
function depositReturns(uint256 a) external;
```

### maxRedeem


```solidity
function maxRedeem(address o) external returns (uint256);
```

### maxRedeemReturns


```solidity
function maxRedeemReturns(uint256 m) external;
```

### redeem


```solidity
function redeem(uint256 s, address r, address o) external returns (uint256);
```

### redeemReturns


```solidity
function redeemReturns(uint256 r) external;
```

## Structs
### RedeemArgs

```solidity
struct RedeemArgs {
    uint256 shares;
    address receiver;
}
```

