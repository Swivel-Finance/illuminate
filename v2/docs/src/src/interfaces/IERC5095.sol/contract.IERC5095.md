# IERC5095
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/7162e4822e4bbebd99b67c43e703ecedf92a2138/src/interfaces/IERC5095.sol)

**Inherits:**
[IERC2612](/src/interfaces/IERC2612.sol/contract.IERC2612.md)


## Functions
### maturity


```solidity
function maturity() external view returns (uint256);
```

### underlying


```solidity
function underlying() external view returns (address);
```

### convertToUnderlying


```solidity
function convertToUnderlying(uint256) external view returns (uint256);
```

### convertToShares


```solidity
function convertToShares(uint256) external view returns (uint256);
```

### maxRedeem


```solidity
function maxRedeem(address) external view returns (uint256);
```

### previewRedeem


```solidity
function previewRedeem(uint256) external view returns (uint256);
```

### maxWithdraw


```solidity
function maxWithdraw(address) external view returns (uint256);
```

### previewWithdraw


```solidity
function previewWithdraw(uint256) external view returns (uint256);
```

### previewDeposit


```solidity
function previewDeposit(uint256) external view returns (uint256);
```

### withdraw


```solidity
function withdraw(uint256, address, address) external returns (uint256);
```

### redeem


```solidity
function redeem(uint256, address, address) external returns (uint256);
```

### deposit


```solidity
function deposit(uint256, address) external returns (uint256);
```

### mint


```solidity
function mint(uint256, address) external returns (uint256);
```

### authMint


```solidity
function authMint(address, uint256) external returns (bool);
```

### authBurn


```solidity
function authBurn(address, uint256) external returns (bool);
```

### authApprove


```solidity
function authApprove(address, address, uint256) external returns (bool);
```

