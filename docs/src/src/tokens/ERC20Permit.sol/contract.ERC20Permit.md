# ERC20Permit
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/756f41d3de7041d0b83523598284cee2b14c535e/src/tokens/ERC20Permit.sol)

**Inherits:**
[ERC20](/src/mocks/ERC20.sol/contract.ERC20.md), [IERC2612](/src/interfaces/IERC2612.sol/contract.IERC2612.md)

*Extension of {ERC20} that allows token holders to use their tokens
without sending any transactions by setting {IERC20-allowance} with a
signature using the {permit} method, and then spend them via
{IERC20-transferFrom}.
The {permit} signature mechanism conforms to the {IERC2612} interface.*


## State Variables
### nonces

```solidity
mapping(address => uint256) public override nonces;
```


### PERMIT_TYPEHASH

```solidity
bytes32 public immutable PERMIT_TYPEHASH =
    keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
```


### _DOMAIN_SEPARATOR

```solidity
bytes32 private immutable _DOMAIN_SEPARATOR;
```


### deploymentChainId

```solidity
uint256 public immutable deploymentChainId;
```


## Functions
### constructor


```solidity
constructor(string memory name_, string memory symbol_, uint8 decimals_) ERC20(name_, symbol_, decimals_);
```

### _calculateDomainSeparator

*Calculate the DOMAIN_SEPARATOR.*


```solidity
function _calculateDomainSeparator(uint256 chainId) private view returns (bytes32);
```

### DOMAIN_SEPARATOR

*Return the DOMAIN_SEPARATOR.*


```solidity
function DOMAIN_SEPARATOR() external view returns (bytes32);
```

### version

*Setting the version as a function so that it can be overriden*


```solidity
function version() public pure virtual returns (string memory);
```

### permit

*See {IERC2612-permit}.
In cases where the free option is not a concern, deadline can simply be
set to uint(-1), so it should be seen as an optional parameter*


```solidity
function permit(address owner, address spender, uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s)
    external
    virtual
    override;
```

