# Pool
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/ddf95dfbaf2df4d82b6652aff5c2effb5fee45f4/src/mocks/Pool.sol)


## State Variables
### fyTokenReturn

```solidity
address private fyTokenReturn;
```


### baseReturn

```solidity
address private baseReturn;
```


### baseTokenReturn

```solidity
address private baseTokenReturn;
```


### sellFYTokenReturn

```solidity
uint128 private sellFYTokenReturn;
```


### sellFYTokenPreviewReturn

```solidity
uint128 private sellFYTokenPreviewReturn;
```


### buyFYTokenReturn

```solidity
uint128 private buyFYTokenReturn;
```


### buyFYTokenPreviewReturn

```solidity
uint128 private buyFYTokenPreviewReturn;
```


### sellBaseReturn

```solidity
uint128 private sellBaseReturn;
```


### sellBasePreviewReturn

```solidity
uint128 private sellBasePreviewReturn;
```


### buyBaseReturn

```solidity
uint128 private buyBaseReturn;
```


### buyBasePreviewReturn

```solidity
uint128 private buyBasePreviewReturn;
```


### mintReturn0

```solidity
uint256 private mintReturn0;
```


### mintReturn1

```solidity
uint256 private mintReturn1;
```


### mintReturn2

```solidity
uint256 private mintReturn2;
```


### mintWithBaseIn

```solidity
uint256 private mintWithBaseIn;
```


### mintWithBaseFyTokenIn

```solidity
uint256 private mintWithBaseFyTokenIn;
```


### mintWithBaseTokensMinted

```solidity
uint256 private mintWithBaseTokensMinted;
```


### burnTokens

```solidity
uint256 private burnTokens;
```


### burnTokenOut

```solidity
uint256 private burnTokenOut;
```


### burnFyTokenOut

```solidity
uint256 private burnFyTokenOut;
```


### burnForBaseTokensBurned

```solidity
uint256 private burnForBaseTokensBurned;
```


### burnForBaseOut

```solidity
uint256 private burnForBaseOut;
```


### sellFYTokenCalled

```solidity
mapping(address => uint256) public sellFYTokenCalled;
```


### sellFYTokenPreviewCalled

```solidity
uint128 public sellFYTokenPreviewCalled;
```


### buyFYTokenCalled

```solidity
mapping(address => BuyFYTokenArg) public buyFYTokenCalled;
```


### buyFYTokenPreviewCalled

```solidity
uint128 public buyFYTokenPreviewCalled;
```


### sellBaseCalled

```solidity
mapping(address => uint128) public sellBaseCalled;
```


### sellBasePreviewCalled

```solidity
uint128 public sellBasePreviewCalled;
```


### buyBaseCalled

```solidity
mapping(address => BuyBaseArg) public buyBaseCalled;
```


### buyBasePreviewCalled

```solidity
uint128 public buyBasePreviewCalled;
```


### mintCalled

```solidity
mapping(address => MintArg) public mintCalled;
```


### mintWithBaseCalled

```solidity
mapping(address => MintWithBaseArg) public mintWithBaseCalled;
```


### burnCalled

```solidity
mapping(address => BurnArg) public burnCalled;
```


### burnForBaseCalled

```solidity
mapping(address => BurnForBaseArg) public burnForBaseCalled;
```


### transferFromCalled

```solidity
mapping(address => TransferFromArgs) public transferFromCalled;
```


## Functions
### fyTokenReturns


```solidity
function fyTokenReturns(address f) external;
```

### fyToken


```solidity
function fyToken() external view returns (address f);
```

### sellFYTokenReturns


```solidity
function sellFYTokenReturns(uint128 s) external;
```

### sellFYToken


```solidity
function sellFYToken(address t, uint128 m) external returns (uint128);
```

### sellFYTokenPreviewReturns


```solidity
function sellFYTokenPreviewReturns(uint128 s) external;
```

### sellFYTokenPreview


```solidity
function sellFYTokenPreview(uint128) external view returns (uint128);
```

### buyFYTokenReturns


```solidity
function buyFYTokenReturns(uint128 b) external;
```

### buyFYToken


```solidity
function buyFYToken(address t, uint128 f, uint128 m) external returns (uint128);
```

### buyFYTokenPreviewReturns


```solidity
function buyFYTokenPreviewReturns(uint128 b) external;
```

### buyFYTokenPreview


```solidity
function buyFYTokenPreview(uint128) external view returns (uint128);
```

### baseReturns


```solidity
function baseReturns(address b) external;
```

### base


```solidity
function base() external view returns (address);
```

### baseTokenReturns


```solidity
function baseTokenReturns(address b) external;
```

### baseToken


```solidity
function baseToken() external view returns (address);
```

### sellBaseReturns


```solidity
function sellBaseReturns(uint128 s) external;
```

### sellBase


```solidity
function sellBase(address t, uint128 m) external returns (uint128);
```

### sellBasePreviewReturns


```solidity
function sellBasePreviewReturns(uint128 b) external;
```

### sellBasePreview


```solidity
function sellBasePreview(uint128) external view returns (uint128);
```

### buyBaseReturns


```solidity
function buyBaseReturns(uint128 b) external;
```

### buyBase


```solidity
function buyBase(address t, uint128 b, uint128 m) external returns (uint128);
```

### buyBasePreviewReturns


```solidity
function buyBasePreviewReturns(uint128 b) external;
```

### buyBasePreview


```solidity
function buyBasePreview(uint128) external view returns (uint128);
```

### mintReturns


```solidity
function mintReturns(uint256 m0, uint256 m1, uint256 m2) external;
```

### mint


```solidity
function mint(address t, address r, uint256 minRatio, uint256 maxRatio) external returns (uint256, uint256, uint256);
```

### mintWithBaseReturns


```solidity
function mintWithBaseReturns(uint256 b, uint256 f, uint256 t) external;
```

### mintWithBase


```solidity
function mintWithBase(address t, address r, uint256 f, uint256 minRatio, uint256 maxRatio)
    external
    returns (uint256, uint256, uint256);
```

### burnReturns


```solidity
function burnReturns(uint256 n, uint256 t, uint256 f) external;
```

### burn


```solidity
function burn(address b, address f, uint256 minRatio, uint256 maxRatio) external returns (uint256, uint256, uint256);
```

### burnForBaseReturns


```solidity
function burnForBaseReturns(uint256 t, uint256 o) external;
```

### burnForBase


```solidity
function burnForBase(address t, uint256 minRatio, uint256 maxRatio) external returns (uint256, uint256);
```

### transferFrom


```solidity
function transferFrom(address f, address t, uint256 a) public returns (bool);
```

## Structs
### BuyFYTokenArg

```solidity
struct BuyFYTokenArg {
    uint128 fyTokenOut;
    uint128 max;
}
```

### BuyBaseArg

```solidity
struct BuyBaseArg {
    uint128 baseOut;
    uint128 max;
}
```

### MintArg

```solidity
struct MintArg {
    address remainder;
    uint256 minRatio;
    uint256 maxRatio;
}
```

### MintWithBaseArg

```solidity
struct MintWithBaseArg {
    address remainder;
    uint256 fyTokenToBuy;
    uint256 minRatio;
    uint256 maxRatio;
}
```

### BurnArg

```solidity
struct BurnArg {
    address fyTokenTo;
    uint256 minRatio;
    uint256 maxRatio;
}
```

### BurnForBaseArg

```solidity
struct BurnForBaseArg {
    uint256 minRatio;
    uint256 maxRatio;
}
```

### TransferFromArgs

```solidity
struct TransferFromArgs {
    address to;
    uint256 amount;
}
```

