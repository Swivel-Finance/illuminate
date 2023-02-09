# Creator
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/7162e4822e4bbebd99b67c43e703ecedf92a2138/src/mocks/Creator.sol)


## State Variables
### createReturn

```solidity
address private createReturn;
```


### createCalled

```solidity
mapping(address => CreateArgs) public createCalled;
```


## Functions
### createReturns


```solidity
function createReturns(address c) external;
```

### create


```solidity
function create(address u, uint256 m, address r, address l, address mp, string calldata n, string calldata s)
    external
    returns (address);
```

## Structs
### CreateArgs

```solidity
struct CreateArgs {
    uint256 maturity;
    address redeemer;
    address lender;
    address marketPlace;
    string name;
    string symbol;
}
```

