# ElementVault
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/76b26ef748dc63cf89e3fa660df1bda262dcef15/src/mocks/ElementVault.sol)


## State Variables
### pt

```solidity
ERC20 pt;
```


### swapReturn

```solidity
uint256 private swapReturn;
```


### swapCalled

```solidity
mapping(address => SwapArgs) public swapCalled;
```


### withdrawPrincipalCalled

```solidity
mapping(address => uint256) public withdrawPrincipalCalled;
```


## Functions
### constructor


```solidity
constructor(address p);
```

### swapReturns


```solidity
function swapReturns(uint256 s) external;
```

### swap


```solidity
function swap(Element.SingleSwap memory s, Element.FundManagement memory f, uint256 l, uint256 d)
    external
    returns (uint256);
```

### withdrawPrincipal


```solidity
function withdrawPrincipal(uint256 a, address d) external;
```

## Structs
### SwapArgs

```solidity
struct SwapArgs {
    address recipient;
    uint256 swapAmount;
    uint256 limit;
    uint256 deadline;
}
```

