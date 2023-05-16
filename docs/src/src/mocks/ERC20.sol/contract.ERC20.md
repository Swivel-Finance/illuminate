# ERC20
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/76b26ef748dc63cf89e3fa660df1bda262dcef15/src/mocks/ERC20.sol)


## State Variables
### approveCalled

```solidity
mapping(address => uint256) public approveCalled;
```


### transferCalled

```solidity
mapping(address => uint256) public transferCalled;
```


### allowanceCalled

```solidity
mapping(address => address) public allowanceCalled;
```


### transferFromCalled

```solidity
mapping(address => TransferFromArgs) public transferFromCalled;
```


### nameReturn

```solidity
string private nameReturn;
```


### symbolReturn

```solidity
string private symbolReturn;
```


### decimalsReturn

```solidity
uint8 private decimalsReturn;
```


### approveReturn

```solidity
bool private approveReturn;
```


### balanceOfReturn

```solidity
uint256 private balanceOfReturn;
```


### allowanceReturn

```solidity
uint256 private allowanceReturn;
```


### transferReturn

```solidity
bool private transferReturn;
```


### transferFromReturn

```solidity
bool private transferFromReturn;
```


### totalSupplyReturn

```solidity
uint256 private totalSupplyReturn;
```


## Functions
### name


```solidity
function name() public view returns (string memory);
```

### nameReturns


```solidity
function nameReturns(string memory s) public;
```

### decimals


```solidity
function decimals() public view returns (uint8);
```

### decimalsReturns


```solidity
function decimalsReturns(uint8 n) public;
```

### symbol


```solidity
function symbol() public view returns (string memory);
```

### symbolReturns


```solidity
function symbolReturns(string memory s) public;
```

### approve


```solidity
function approve(address s, uint256 a) public returns (bool);
```

### approveReturns


```solidity
function approveReturns(bool b) public;
```

### allowance


```solidity
function allowance(address, address) public view returns (uint256);
```

### allowanceReturns


```solidity
function allowanceReturns(uint256 n) public;
```

### balanceOfReturns


```solidity
function balanceOfReturns(uint256 b) public;
```

### balanceOf


```solidity
function balanceOf(address) external view returns (uint256);
```

### transfer


```solidity
function transfer(address t, uint256 a) public returns (bool);
```

### transferReturns


```solidity
function transferReturns(bool b) public;
```

### transferFrom


```solidity
function transferFrom(address f, address t, uint256 a) public returns (bool);
```

### transferFromReturns


```solidity
function transferFromReturns(bool b) public;
```

### totalSupplyReturns


```solidity
function totalSupplyReturns(uint256 t) external;
```

### totalSupply


```solidity
function totalSupply() external view returns (uint256);
```

## Structs
### TransferFromArgs

```solidity
struct TransferFromArgs {
    address to;
    uint256 amount;
}
```

