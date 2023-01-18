# APWineController
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/756f41d3de7041d0b83523598284cee2b14c535e/src/mocks/APWineController.sol)


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

