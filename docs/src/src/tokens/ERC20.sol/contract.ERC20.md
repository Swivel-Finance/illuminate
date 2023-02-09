# ERC20
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/7162e4822e4bbebd99b67c43e703ecedf92a2138/src/tokens/ERC20.sol)

**Inherits:**
[IERC20Metadata](/src/interfaces/IERC20Metadata.sol/contract.IERC20Metadata.md)

*Implementation of the {IERC20} interface.
This implementation is agnostic to the way tokens are created. This means
that a supply mechanism has to be added in a derived contract using {_mint}.
We have followed general OpenZeppelin guidelines: functions revert instead
of returning `false` on failure. This behavior is nonetheless conventional
and does not conflict with the expectations of ERC20 applications.
Additionally, an {Approval} event is emitted on calls to {transferFrom}.
This allows applications to reconstruct the allowance for all accounts just
by listening to said events. Other implementations of the EIP may not emit
these events, as it isn't required by the specification.
Calls to {transferFrom} do not check for allowance if the caller is the owner
of the funds. This allows to reduce the number of approvals that are necessary.
Finally, {transferFrom} does not decrease the allowance if it is set to
type(uint256).max. This reduces the gas costs without any likely impact.*


## State Variables
### _totalSupply

```solidity
uint256 internal _totalSupply;
```


### _balanceOf

```solidity
mapping(address => uint256) internal _balanceOf;
```


### _allowance

```solidity
mapping(address => mapping(address => uint256)) internal _allowance;
```


### name

```solidity
string public override name = "???";
```


### symbol

```solidity
string public override symbol = "???";
```


### decimals

```solidity
uint8 public override decimals = 18;
```


## Functions
### constructor

*Sets the values for {name}, {symbol} and {decimals}.*


```solidity
constructor(string memory name_, string memory symbol_, uint8 decimals_);
```

### totalSupply

*See {IERC20-totalSupply}.*


```solidity
function totalSupply() external view virtual override returns (uint256);
```

### balanceOf

*See {IERC20-balanceOf}.*


```solidity
function balanceOf(address guy) external view virtual override returns (uint256);
```

### allowance

*See {IERC20-allowance}.*


```solidity
function allowance(address owner, address spender) external view virtual override returns (uint256);
```

### approve

*See {IERC20-approve}.*


```solidity
function approve(address spender, uint256 wad) external virtual override returns (bool);
```

### transfer

*See {IERC20-transfer}.
Requirements:
- the caller must have a balance of at least `wad`.*


```solidity
function transfer(address dst, uint256 wad) external virtual override returns (bool);
```

### transferFrom

*See {IERC20-transferFrom}.
Emits an {Approval} event indicating the updated allowance. This is not
required by the EIP. See the note at the beginning of {ERC20}.
Requirements:
- `src` must have a balance of at least `wad`.
- the caller is not `src`, it must have allowance for ``src``'s tokens of at least
`wad`.
if_succeeds {:msg "TransferFrom - decrease allowance"} msg.sender != src ==> old(_allowance[src][msg.sender]) >= wad;*


```solidity
function transferFrom(address src, address dst, uint256 wad) external virtual override returns (bool);
```

### _transfer

*Moves tokens `wad` from `src` to `dst`.
Emits a {Transfer} event.
Requirements:
- `src` must have a balance of at least `amount`.
if_succeeds {:msg "Transfer - src decrease"} old(_balanceOf[src]) >= _balanceOf[src];
if_succeeds {:msg "Transfer - dst increase"} _balanceOf[dst] >= old(_balanceOf[dst]);
if_succeeds {:msg "Transfer - supply"} old(_balanceOf[src]) + old(_balanceOf[dst]) == _balanceOf[src] + _balanceOf[dst];*


```solidity
function _transfer(address src, address dst, uint256 wad) internal virtual returns (bool);
```

### _setAllowance

*Sets the allowance granted to `spender` by `owner`.
Emits an {Approval} event indicating the updated allowance.*


```solidity
function _setAllowance(address owner, address spender, uint256 wad) internal virtual returns (bool);
```

### _decreaseAllowance

*Decreases the allowance granted to the caller by `src`, unless src == msg.sender or _allowance[src][msg.sender] == MAX
Emits an {Approval} event indicating the updated allowance, if the allowance is updated.
Requirements:
- `spender` must have allowance for the caller of at least
`wad`, unless src == msg.sender
if_succeeds {:msg "Decrease allowance - underflow"} old(_allowance[src][msg.sender]) <= _allowance[src][msg.sender];*


```solidity
function _decreaseAllowance(address src, uint256 wad) internal virtual returns (bool);
```

### _mint

*Creates `wad` tokens and assigns them to `dst`, increasing
the total supply.
Emits a {Transfer} event with `from` set to the zero address.
if_succeeds {:msg "Mint - balance overflow"} old(_balanceOf[dst]) >= _balanceOf[dst];
if_succeeds {:msg "Mint - supply overflow"} old(_totalSupply) >= _totalSupply;*


```solidity
function _mint(address dst, uint256 wad) internal virtual returns (bool);
```

### _burn

*Destroys `wad` tokens from `src`, reducing the
total supply.
Emits a {Transfer} event with `to` set to the zero address.
Requirements:
- `src` must have at least `wad` tokens.
if_succeeds {:msg "Burn - balance underflow"} old(_balanceOf[src]) <= _balanceOf[src];
if_succeeds {:msg "Burn - supply underflow"} old(_totalSupply) <= _totalSupply;*


```solidity
function _burn(address src, uint256 wad) internal virtual returns (bool);
```

