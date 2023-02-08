# APWineController
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/29a4038ae0d0795d36640f068da3ac5c1dd43806/src/mocks/APWineController.sol)


## State Variables
### getNextPeriodStartReturn

```solidity
uint256 private getNextPeriodStartReturn;
```


### getNextPeriodStartCalled

```solidity
uint256 public getNextPeriodStartCalled;
```


### withdrawCalled

```solidity
mapping(address => uint256) public withdrawCalled;
```


## Functions
### getNextPeriodStartReturns


```solidity
function getNextPeriodStartReturns(uint256 p) external;
```

### getNextPeriodStart


```solidity
function getNextPeriodStart(uint256) external view returns (uint256);
```

### withdraw


```solidity
function withdraw(address f, uint256 a) external;
```

