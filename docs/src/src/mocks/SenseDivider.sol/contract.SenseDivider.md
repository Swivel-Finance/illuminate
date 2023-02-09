# SenseDivider
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/7162e4822e4bbebd99b67c43e703ecedf92a2138/src/mocks/SenseDivider.sol)


## State Variables
### redeemReturn

```solidity
uint256 private redeemReturn;
```


### ptReturn

```solidity
address private ptReturn;
```


### adapterAddressesReturn

```solidity
address private adapterAddressesReturn;
```


### redeemCalled

```solidity
mapping(address => RedeemArg) public redeemCalled;
```


### ptCalled

```solidity
mapping(address => uint256) public ptCalled;
```


### token

```solidity
ERC20 token;
```


## Functions
### constructor


```solidity
constructor(address p);
```

### redeemReturns


```solidity
function redeemReturns(uint256 r) external;
```

### redeem


```solidity
function redeem(address a, uint256 s, uint256 amount) external returns (uint256);
```

### ptReturns


```solidity
function ptReturns(address p) external;
```

### pt


```solidity
function pt(address, uint256) external view returns (address);
```

### adapterAddressesReturns


```solidity
function adapterAddressesReturns(address a) external;
```

### adapterAddresses


```solidity
function adapterAddresses(uint256) external view returns (address);
```

## Structs
### RedeemArg

```solidity
struct RedeemArg {
    uint256 senseMaturity;
    uint256 amount;
}
```

