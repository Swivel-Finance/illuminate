# PendleStandardYieldToken
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/29a4038ae0d0795d36640f068da3ac5c1dd43806/src/mocks/PendleStandardYieldToken.sol)

**Inherits:**
[ERC20](/src/mocks/ERC20.sol/contract.ERC20.md)


## State Variables
### redeemCalled

```solidity
mapping(address => RedeemCalledArgs) public redeemCalled;
```


### redeemReturn

```solidity
uint256 redeemReturn;
```


## Functions
### redeemReturns


```solidity
function redeemReturns(uint256 r) external;
```

### redeem


```solidity
function redeem(address r, uint256 a, address u, uint256 m, bool f) external returns (uint256);
```

## Structs
### RedeemCalledArgs

```solidity
struct RedeemCalledArgs {
    address receiver;
    uint256 amount;
    address asset;
    uint256 minimumOut;
    bool flag;
}
```

