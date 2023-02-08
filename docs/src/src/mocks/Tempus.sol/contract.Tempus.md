# Tempus
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/29a4038ae0d0795d36640f068da3ac5c1dd43806/src/mocks/Tempus.sol)

**Inherits:**
[ITempus](/src/interfaces/ITempus.sol/contract.ITempus.md)


## State Variables
### pt

```solidity
ERC20 pt;
```


### redeemToBackingCalled

```solidity
mapping(address => RedeemToBackingArgs) public redeemToBackingCalled;
```


### depositAndFixCalled

```solidity
mapping(uint256 => DepositAndFixArgs) public depositAndFixCalled;
```


## Functions
### constructor


```solidity
constructor(address p);
```

### depositAndFix


```solidity
function depositAndFix(address x, uint256 a, bool bt, uint256 mr, uint256 d) external;
```

### redeemToBacking


```solidity
function redeemToBacking(address o, uint256 a, uint256 y, address r) external;
```

## Structs
### RedeemToBackingArgs

```solidity
struct RedeemToBackingArgs {
    uint256 amount;
    uint256 yield;
    address recipient;
}
```

### DepositAndFixArgs

```solidity
struct DepositAndFixArgs {
    address amm;
    bool bt;
    uint256 minimumReturned;
    uint256 deadline;
}
```

