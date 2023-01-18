# IlluminatePrincipalToken
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/756f41d3de7041d0b83523598284cee2b14c535e/src/mocks/IlluminatePrincipalToken.sol)

**Inherits:**
[ERC20](/src/mocks/ERC20.sol/contract.ERC20.md)


## State Variables
### mintReturn

```solidity
bool private mintReturn;
```


### burnReturn

```solidity
bool private burnReturn;
```


### maturityReturn

```solidity
uint256 private maturityReturn;
```


### mintCalled

```solidity
mapping(address => uint256) public mintCalled;
```


### burnCalled

```solidity
mapping(address => uint256) public burnCalled;
```


## Functions
### mintReturns


```solidity
function mintReturns(bool s) external;
```

### authMint


```solidity
function authMint(address t, uint256 a) external returns (bool);
```

### burnReturns


```solidity
function burnReturns(bool s) external;
```

### authBurn


```solidity
function authBurn(address f, uint256 a) external returns (bool);
```

### maturityReturns


```solidity
function maturityReturns(uint256 m) external;
```

### maturity


```solidity
function maturity() external view returns (uint256);
```

