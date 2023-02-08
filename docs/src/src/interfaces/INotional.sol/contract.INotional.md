# INotional
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/29a4038ae0d0795d36640f068da3ac5c1dd43806/src/interfaces/INotional.sol)


## Functions
### getUnderlyingToken


```solidity
function getUnderlyingToken() external view returns (IERC20, int256);
```

### getMaturity


```solidity
function getMaturity() external view returns (uint40);
```

### deposit


```solidity
function deposit(uint256, address) external returns (uint256);
```

### maxRedeem


```solidity
function maxRedeem(address) external returns (uint256);
```

### redeem


```solidity
function redeem(uint256, address, address) external returns (uint256);
```

