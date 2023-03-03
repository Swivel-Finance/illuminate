// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.16;

// Adapted from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/53516bc555a454862470e7860a9b5254db4d00f5/contracts/token/ERC20/ERC20Permit.sol

// Inspired on token.sol from DappHub. Natspec adpated from OpenZeppelin.

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Returns the number of decimals the token uses - e.g. 8, means to
     * divide the token amount by 100000000 to get its user representation.
     */
    function decimals() external view returns (uint8);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of ERC20 applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Calls to {transferFrom} do not check for allowance if the caller is the owner
 * of the funds. This allows to reduce the number of approvals that are necessary.
 *
 * Finally, {transferFrom} does not decrease the allowance if it is set to
 * type(uint256).max. This reduces the gas costs without any likely impact.
 */
contract ERC20 is IERC20Metadata {
    uint256 internal _totalSupply;
    mapping(address => uint256) internal _balanceOf;
    mapping(address => mapping(address => uint256)) internal _allowance;
    string public override name = '???';
    string public override symbol = '???';
    uint8 public override decimals = 18;

    /**
     *  @dev Sets the values for {name}, {symbol} and {decimals}.
     */
    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_
    ) {
        name = name_;
        symbol = symbol_;
        decimals = decimals_;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() external view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address guy)
        external
        view
        virtual
        override
        returns (uint256)
    {
        return _balanceOf[guy];
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender)
        external
        view
        virtual
        override
        returns (uint256)
    {
        return _allowance[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     */
    function approve(address spender, uint256 wad)
        external
        virtual
        override
        returns (bool)
    {
        return _setAllowance(msg.sender, spender, wad);
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - the caller must have a balance of at least `wad`.
     */
    function transfer(address dst, uint256 wad)
        external
        virtual
        override
        returns (bool)
    {
        return _transfer(msg.sender, dst, wad);
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * Requirements:
     *
     * - `src` must have a balance of at least `wad`.
     * - the caller is not `src`, it must have allowance for ``src``'s tokens of at least
     * `wad`.
     */
    /// if_succeeds {:msg "TransferFrom - decrease allowance"} msg.sender != src ==> old(_allowance[src][msg.sender]) >= wad;
    function transferFrom(
        address src,
        address dst,
        uint256 wad
    ) external virtual override returns (bool) {
        _decreaseAllowance(src, wad);

        return _transfer(src, dst, wad);
    }

    /**
     * @dev Moves tokens `wad` from `src` to `dst`.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `src` must have a balance of at least `amount`.
     */
    /// if_succeeds {:msg "Transfer - src decrease"} old(_balanceOf[src]) >= _balanceOf[src];
    /// if_succeeds {:msg "Transfer - dst increase"} _balanceOf[dst] >= old(_balanceOf[dst]);
    /// if_succeeds {:msg "Transfer - supply"} old(_balanceOf[src]) + old(_balanceOf[dst]) == _balanceOf[src] + _balanceOf[dst];
    function _transfer(
        address src,
        address dst,
        uint256 wad
    ) internal virtual returns (bool) {
        require(_balanceOf[src] >= wad, 'ERC20: Insufficient balance');
        unchecked {
            _balanceOf[src] = _balanceOf[src] - wad;
        }
        _balanceOf[dst] = _balanceOf[dst] + wad;

        emit Transfer(src, dst, wad);

        return true;
    }

    /**
     * @dev Sets the allowance granted to `spender` by `owner`.
     *
     * Emits an {Approval} event indicating the updated allowance.
     */
    function _setAllowance(
        address owner,
        address spender,
        uint256 wad
    ) internal virtual returns (bool) {
        _allowance[owner][spender] = wad;
        emit Approval(owner, spender, wad);

        return true;
    }

    /**
     * @dev Decreases the allowance granted to the caller by `src`, unless src == msg.sender or _allowance[src][msg.sender] == MAX
     *
     * Emits an {Approval} event indicating the updated allowance, if the allowance is updated.
     *
     * Requirements:
     *
     * - `spender` must have allowance for the caller of at least
     * `wad`, unless src == msg.sender
     */
    /// if_succeeds {:msg "Decrease allowance - underflow"} old(_allowance[src][msg.sender]) <= _allowance[src][msg.sender];
    function _decreaseAllowance(address src, uint256 wad)
        internal
        virtual
        returns (bool)
    {
        if (src != msg.sender) {
            uint256 allowed = _allowance[src][msg.sender];
            if (allowed != type(uint256).max) {
                require(allowed >= wad, 'ERC20: Insufficient approval');
                unchecked {
                    _setAllowance(src, msg.sender, allowed - wad);
                }
            }
        }

        return true;
    }

    /** @dev Creates `wad` tokens and assigns them to `dst`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     */
    /// if_succeeds {:msg "Mint - balance overflow"} old(_balanceOf[dst]) >= _balanceOf[dst];
    /// if_succeeds {:msg "Mint - supply overflow"} old(_totalSupply) >= _totalSupply;
    function _mint(address dst, uint256 wad) internal virtual returns (bool) {
        _balanceOf[dst] = _balanceOf[dst] + wad;
        _totalSupply = _totalSupply + wad;
        emit Transfer(address(0), dst, wad);

        return true;
    }

    /**
     * @dev Destroys `wad` tokens from `src`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `src` must have at least `wad` tokens.
     */
    /// if_succeeds {:msg "Burn - balance underflow"} old(_balanceOf[src]) <= _balanceOf[src];
    /// if_succeeds {:msg "Burn - supply underflow"} old(_totalSupply) <= _totalSupply;
    function _burn(address src, uint256 wad) internal virtual returns (bool) {
        unchecked {
            require(_balanceOf[src] >= wad, 'ERC20: Insufficient balance');
            _balanceOf[src] = _balanceOf[src] - wad;
            _totalSupply = _totalSupply - wad;
            emit Transfer(src, address(0), wad);
        }

        return true;
    }
}

/**
 * @dev Interface of the ERC2612 standard as defined in the EIP.
 *
 * Adds the {permit} method, which can be used to change one's
 * {IERC20-allowance} without having to send a transaction, by signing a
 * message. This allows users to spend tokens without having to hold Ether.
 *
 * See https://eips.ethereum.org/EIPS/eip-2612.
 */
interface IERC2612 is IERC20Metadata {
    /**
     * @dev Sets `amount` as the allowance of `spender` over `owner`'s tokens,
     * given `owner`'s signed approval.
     *
     * IMPORTANT: The same issues {IERC20-approve} has related to transaction
     * ordering also apply here.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     * - `deadline` must be a timestamp in the future.
     * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
     * over the EIP712-formatted function arguments.
     * - the signature must use ``owner``'s current nonce (see {nonces}).
     *
     * For more information on the signature format, see the
     * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
     * section].
     */
    function permit(
        address owner,
        address spender,
        uint256 amount,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    /**
     * @dev Returns the current ERC2612 nonce for `owner`. This value must be
     * included whenever a signature is generated for {permit}.
     *
     * Every successful call to {permit} increases ``owner``'s nonce by one. This
     * prevents a signature from being used multiple times.
     */
    function nonces(address owner) external view returns (uint256);
}

/**
 * @dev Extension of {ERC20} that allows token holders to use their tokens
 * without sending any transactions by setting {IERC20-allowance} with a
 * signature using the {permit} method, and then spend them via
 * {IERC20-transferFrom}.
 *
 * The {permit} signature mechanism conforms to the {IERC2612} interface.
 */
abstract contract ERC20Permit is ERC20, IERC2612 {
    mapping(address => uint256) public override nonces;

    bytes32 public immutable PERMIT_TYPEHASH =
        keccak256(
            'Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)'
        );
    bytes32 private immutable _DOMAIN_SEPARATOR;
    uint256 public immutable deploymentChainId;

    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_
    ) ERC20(name_, symbol_, decimals_) {
        deploymentChainId = block.chainid;
        _DOMAIN_SEPARATOR = _calculateDomainSeparator(block.chainid);
    }

    /// @dev Calculate the DOMAIN_SEPARATOR.
    function _calculateDomainSeparator(uint256 chainId)
        private
        view
        returns (bytes32)
    {
        return
            keccak256(
                abi.encode(
                    keccak256(
                        'EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'
                    ),
                    keccak256(bytes(name)),
                    keccak256(bytes(version())),
                    chainId,
                    address(this)
                )
            );
    }

    /// @dev Return the DOMAIN_SEPARATOR.
    function DOMAIN_SEPARATOR() external view returns (bytes32) {
        return
            block.chainid == deploymentChainId
                ? _DOMAIN_SEPARATOR
                : _calculateDomainSeparator(block.chainid);
    }

    /// @dev Setting the version as a function so that it can be overriden
    function version() public pure virtual returns (string memory) {
        return '1';
    }

    /**
     * @dev See {IERC2612-permit}.
     *
     * In cases where the free option is not a concern, deadline can simply be
     * set to uint(-1), so it should be seen as an optional parameter
     */
    function permit(
        address owner,
        address spender,
        uint256 amount,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external virtual override {
        require(deadline >= block.timestamp, 'ERC20Permit: expired deadline');

        bytes32 hashStruct = keccak256(
            abi.encode(
                PERMIT_TYPEHASH,
                owner,
                spender,
                amount,
                nonces[owner]++,
                deadline
            )
        );

        bytes32 hash = keccak256(
            abi.encodePacked(
                '\x19\x01',
                block.chainid == deploymentChainId
                    ? _DOMAIN_SEPARATOR
                    : _calculateDomainSeparator(block.chainid),
                hashStruct
            )
        );

        address signer = ecrecover(hash, v, r, s);
        require(
            signer != address(0) && signer == owner,
            'ERC20Permit: invalid signature'
        );

        _setAllowance(owner, spender, amount);
    }
}

interface IERC5095 is IERC2612 {
    function maturity() external view returns (uint256);

    function underlying() external view returns (address);

    function convertToUnderlying(uint256) external view returns (uint256);

    function convertToShares(uint256) external view returns (uint256);

    function maxRedeem(address) external view returns (uint256);

    function previewRedeem(uint256) external view returns (uint256);

    function maxWithdraw(address) external view returns (uint256);

    function previewWithdraw(uint256) external view returns (uint256);

    function previewDeposit(uint256) external view returns (uint256);

    function withdraw(
        uint256,
        address,
        address
    ) external returns (uint256);

    function redeem(
        uint256,
        address,
        address
    ) external returns (uint256);

    function deposit(uint256, address) external returns (uint256);

    function mint(uint256, address) external returns (uint256);

    function authMint(address, uint256) external returns (bool);

    function authBurn(address, uint256) external returns (bool);

    function authApprove(
        address,
        address,
        uint256
    ) external returns (bool);
}

interface IRedeemer {
    function authRedeem(
        address underlying,
        uint256 maturity,
        address from,
        address to,
        uint256 amount
    ) external returns (uint256);

    function approve(address p) external;

    function holdings(address u, uint256 m) external view returns (uint256);
}

interface IMarketPlace {
    function markets(
        address,
        uint256,
        uint256
    ) external returns (address);

    function pools(address, uint256) external view returns (address);

    function sellPrincipalToken(
        address,
        uint256,
        uint128,
        uint128
    ) external returns (uint128);

    function buyPrincipalToken(
        address,
        uint256,
        uint128,
        uint128
    ) external returns (uint128);

    function sellUnderlying(
        address,
        uint256,
        uint128,
        uint128
    ) external returns (uint128);

    function buyUnderlying(
        address,
        uint256,
        uint128,
        uint128
    ) external returns (uint128);

    function redeemer() external view returns (address);
}

interface IYield {
    function maturity() external view returns (uint32);

    function base() external view returns (IERC20);

    function sellBase(address, uint128) external returns (uint128);

    function sellBasePreview(uint128) external view returns (uint128);

    function fyToken() external returns (address);

    function sellFYToken(address, uint128) external returns (uint128);

    function sellFYTokenPreview(uint128) external view returns (uint128);

    function buyBase(
        address,
        uint128,
        uint128
    ) external returns (uint128);

    function buyBasePreview(uint128) external view returns (uint128);

    function buyFYToken(
        address,
        uint128,
        uint128
    ) external returns (uint128);

    function buyFYTokenPreview(uint128) external view returns (uint128);
}

/// @dev A single custom error capable of indicating a wide range of detected errors by providing
/// an error code value whose string representation is documented in errors.txt, and any possible other values
/// that are pertinent to the error.
error Exception(uint8, uint256, uint256, address, address);

library Cast {
    /// @dev Safely cast an uint256 to an uint128
    /// @param n the u256 to cast to u128
    function u128(uint256 n) internal pure returns (uint128) {
        if (n > type(uint128).max) {
            revert();
        }
        return uint128(n);
    }
}

// Adapted from: https://github.com/Rari-Capital/solmate/blob/main/src/utils/SafeTransferLib.sol

/**
  @notice Safe ETH and ERC20 transfer library that gracefully handles missing return values.
  @author Modified from Gnosis (https://github.com/gnosis/gp-v2-contracts/blob/main/src/contracts/libraries/GPv2SafeERC20.sol)
  @dev Use with caution! Some functions in this library knowingly create dirty bits at the destination of the free memory pointer.
*/

library Safe {
    /// @param e Erc20 token to execute the call with
    /// @param t To address
    /// @param a Amount being transferred
    function transfer(
        IERC20 e,
        address t,
        uint256 a
    ) internal {
        bool result;

        assembly {
            // Get a pointer to some free memory.
            let pointer := mload(0x40)

            // Write the abi-encoded calldata to memory piece by piece:
            mstore(
                pointer,
                0xa9059cbb00000000000000000000000000000000000000000000000000000000
            ) // Begin with the function selector.
            mstore(
                add(pointer, 4),
                and(t, 0xffffffffffffffffffffffffffffffffffffffff)
            ) // Mask and append the "to" argument.
            mstore(add(pointer, 36), a) // Finally append the "amount" argument. No mask as it's a full 32 byte value.

            // Call the token and store if it succeeded or not.
            // We use 68 because the calldata length is 4 + 32 * 2.
            result := call(gas(), e, 0, pointer, 68, 0, 0)
        }

        require(success(result), 'transfer failed');
    }

    /// @param e Erc20 token to execute the call with
    /// @param f From address
    /// @param t To address
    /// @param a Amount being transferred
    function transferFrom(
        IERC20 e,
        address f,
        address t,
        uint256 a
    ) internal {
        bool result;

        assembly {
            // Get a pointer to some free memory.
            let pointer := mload(0x40)

            // Write the abi-encoded calldata to memory piece by piece:
            mstore(
                pointer,
                0x23b872dd00000000000000000000000000000000000000000000000000000000
            ) // Begin with the function selector.
            mstore(
                add(pointer, 4),
                and(f, 0xffffffffffffffffffffffffffffffffffffffff)
            ) // Mask and append the "from" argument.
            mstore(
                add(pointer, 36),
                and(t, 0xffffffffffffffffffffffffffffffffffffffff)
            ) // Mask and append the "to" argument.
            mstore(add(pointer, 68), a) // Finally append the "amount" argument. No mask as it's a full 32 byte value.

            // Call the token and store if it succeeded or not.
            // We use 100 because the calldata length is 4 + 32 * 3.
            result := call(gas(), e, 0, pointer, 100, 0, 0)
        }

        require(success(result), 'transfer from failed');
    }

    /// @notice normalize the acceptable values of true or null vs the unacceptable value of false (or something malformed)
    /// @param r Return value from the assembly `call()` to Erc20['selector']
    function success(bool r) private pure returns (bool) {
        bool result;

        assembly {
            // Get how many bytes the call returned.
            let returnDataSize := returndatasize()

            // If the call reverted:
            if iszero(r) {
                // Copy the revert message into memory.
                returndatacopy(0, 0, returnDataSize)

                // Revert with the same message.
                revert(0, returnDataSize)
            }

            switch returnDataSize
            case 32 {
                // Copy the return data into memory.
                returndatacopy(0, 0, returnDataSize)

                // Set success to whether it returned true.
                result := iszero(iszero(mload(0)))
            }
            case 0 {
                // There was no return data.
                result := 1
            }
            default {
                // It returned some malformed input.
                result := 0
            }
        }

        return result;
    }

    function approve(
        IERC20 token,
        address to,
        uint256 amount
    ) internal {
        bool callStatus;

        assembly {
            // Get a pointer to some free memory.
            let freeMemoryPointer := mload(0x40)

            // Write the abi-encoded calldata to memory piece by piece:
            mstore(
                freeMemoryPointer,
                0x095ea7b300000000000000000000000000000000000000000000000000000000
            ) // Begin with the function selector.
            mstore(
                add(freeMemoryPointer, 4),
                and(to, 0xffffffffffffffffffffffffffffffffffffffff)
            ) // Mask and append the "to" argument.
            mstore(add(freeMemoryPointer, 36), amount) // Finally append the "amount" argument. No mask as it's a full 32 byte value.

            // Call the token and store if it succeeded or not.
            // We use 68 because the calldata length is 4 + 32 * 2.
            callStatus := call(gas(), token, 0, freeMemoryPointer, 68, 0, 0)
        }

        require(didLastOptionalReturnCallSucceed(callStatus), 'APPROVE_FAILED');
    }

    /*///////////////////////////////////////////////////////////////
                         INTERNAL HELPER LOGIC
    //////////////////////////////////////////////////////////////*/

    function didLastOptionalReturnCallSucceed(bool callStatus)
        private
        pure
        returns (bool)
    {
        bool result;
        assembly {
            // Get how many bytes the call returned.
            let returnDataSize := returndatasize()

            // If the call reverted:
            if iszero(callStatus) {
                // Copy the revert message into memory.
                returndatacopy(0, 0, returnDataSize)

                // Revert with the same message.
                revert(0, returnDataSize)
            }

            switch returnDataSize
            case 32 {
                // Copy the return data into memory.
                returndatacopy(0, 0, returnDataSize)

                // Set success to whether it returned true.
                result := iszero(iszero(mload(0)))
            }
            case 0 {
                // There was no return data.
                result := 1
            }
            default {
                // It returned some malformed input.
                result := 0
            }
        }

        return result;
    }
}

contract ERC5095 is ERC20Permit, IERC5095 {
    /// @dev unix timestamp when the ERC5095 token can be redeemed
    uint256 public immutable override maturity;
    /// @dev address of the ERC20 token that is returned on ERC5095 redemption
    address public immutable override underlying;
    /// @dev address of the minting authority
    address public immutable lender;
    /// @dev address of the "marketplace" YieldSpace AMM router
    address public immutable marketplace;
    ///@dev Interface to interact with the pool
    address public pool;

    /// @dev address and interface for an external custody contract (necessary for some project's backwards compatability)
    address public immutable redeemer;

    /// @notice ensures that only a certain address can call the function
    /// @param a address that msg.sender must be to be authorized
    modifier authorized(address a) {
        if (msg.sender != a) {
            revert Exception(0, 0, 0, msg.sender, a);
        }
        _;
    }

    constructor(
        address _underlying,
        uint256 _maturity,
        address _redeemer,
        address _lender,
        address _marketplace,
        string memory name_,
        string memory symbol_,
        uint8 decimals_
    ) ERC20Permit(name_, symbol_, decimals_) {
        underlying = _underlying;
        maturity = _maturity;
        redeemer = _redeemer;
        lender = _lender;
        marketplace = _marketplace;
        pool = address(0);
    }

    /// @notice Allows the marketplace to set the pool
    /// @param p Address of the pool
    /// @return bool True if successful
    function setPool(address p)
        external
        authorized(marketplace)
        returns (bool)
    {
        pool = p;
        return true;
    }

    /// @notice Allows the marketplace to spend underlying, principal tokens held by the token
    /// @dev This is necessary when MarketPlace calls pool methods to swap tokens
    /// @return True if successful
    function approveMarketPlace()
        external
        authorized(marketplace)
        returns (bool)
    {
        // Approve the marketplace to spend the token's underlying
        Safe.approve(IERC20(underlying), marketplace, type(uint256).max);

        // Approve the marketplace to spend illuminate PTs
        Safe.approve(IERC20(address(this)), marketplace, type(uint256).max);

        return true;
    }

    /// @notice Post or at maturity, converts an amount of principal tokens to an amount of underlying that would be returned.
    /// @param s The amount of principal tokens to convert
    /// @return uint256 The amount of underlying tokens returned by the conversion
    function convertToUnderlying(uint256 s)
        external
        view
        override
        returns (uint256)
    {
        if (block.timestamp < maturity) {
            return previewRedeem(s);
        }
        return s;
    }

    /// @notice Post or at maturity, converts a desired amount of underlying tokens returned to principal tokens needed.
    /// @param a The amount of underlying tokens to convert
    /// @return uint256 The amount of principal tokens returned by the conversion
    function convertToShares(uint256 a)
        external
        view
        override
        returns (uint256)
    {
        if (block.timestamp < maturity) {
            return previewWithdraw(a);
        }
        return a;
    }

    /// @notice Returns user's PT balance
    /// @param o The address of the owner for which redemption is calculated
    /// @return uint256 The maximum amount of principal tokens that `owner` can redeem.
    function maxRedeem(address o) external view override returns (uint256) {
        return _balanceOf[o];
    }

    /// @notice Post or at maturity, returns user's PT balance. Prior to maturity, returns a previewRedeem for owner's PT balance.
    /// @param  o The address of the owner for which withdrawal is calculated
    /// @return uint256 maximum amount of underlying tokens that `owner` can withdraw.
    function maxWithdraw(address o) external view override returns (uint256) {
        if (block.timestamp < maturity) {
            return previewRedeem(_balanceOf[o]);
        }
        return _balanceOf[o];
    }

    /// @notice After maturity, returns 0. Prior to maturity, returns the amount of `shares` when spending `a` in underlying on a YieldSpace AMM.
    /// @param a The amount of underlying spent
    /// @return uint256 The amount of PT purchased by spending `a` of underlying
    function previewDeposit(uint256 a) public view returns (uint256) {
        if (block.timestamp < maturity) {
            return IYield(pool).sellBasePreview(Cast.u128(a));
        }
        return 0;
    }

    /// @notice After maturity, returns 0. Prior to maturity, returns the amount of `assets` in underlying spent on a purchase of `s` in PT on a YieldSpace AMM.
    /// @param s The amount of principal tokens bought in the simulation
    /// @return uint256 The amount of underlying required to purchase `s` of PT
    function previewMint(uint256 s) public view returns (uint256) {
        if (block.timestamp < maturity) {
            return IYield(pool).buyFYTokenPreview(Cast.u128(s));
        }
        return 0;
    }

    /// @notice Post or at maturity, simulates the effects of redemption. Prior to maturity, returns the amount of `assets` from a sale of `s` PTs on a YieldSpace AMM.
    /// @param s The amount of principal tokens redeemed in the simulation
    /// @return uint256 The amount of underlying returned by `s` of PT redemption
    function previewRedeem(uint256 s) public view override returns (uint256) {
        if (block.timestamp >= maturity) {
            // After maturity, the amount redeemed is based on the Redeemer contract's holdings of the underlying
            return
                Cast.u128(
                    s *
                        Cast.u128(
                            IRedeemer(redeemer).holdings(underlying, maturity)
                        )
                ) / _totalSupply;
        }

        // Prior to maturity, return a a preview of a swap on the pool
        return IYield(pool).sellFYTokenPreview(Cast.u128(s));
    }

    /// @notice Post or at maturity, simulates the effects of withdrawal at the current block. Prior to maturity, simulates the amount of PTs necessary to receive `a` in underlying from the sale of PTs on a YieldSpace AMM.
    /// @param a The amount of underlying tokens withdrawn in the simulation
    /// @return uint256 The amount of principal tokens required for the withdrawal of `a`
    function previewWithdraw(uint256 a) public view override returns (uint256) {
        if (block.timestamp >= maturity) {
            // After maturity, the amount redeemed is based on the Redeemer contract's holdings of the underlying
            return
                (a * _totalSupply) /
                IRedeemer(redeemer).holdings(underlying, maturity);
        }

        // Prior to maturity, return a a preview of a swap on the pool
        return IYield(pool).buyBasePreview(Cast.u128(a));
    }

    /// @notice Before maturity spends `a` of underlying, and sends PTs to `r`. Post or at maturity, reverts.
    /// @param a The amount of underlying tokens deposited
    /// @param r The receiver of the principal tokens
    /// @param m Minimum number of shares that the user will receive
    /// @return uint256 The amount of principal tokens purchased
    function deposit(
        uint256 a,
        address r,
        uint256 m
    ) external returns (uint256) {
        // Execute the deposit
        return _deposit(r, a, m);
    }

    /// @notice Before maturity spends `assets` of underlying, and sends `shares` of PTs to `receiver`. Post or at maturity, reverts.
    /// @param a The amount of underlying tokens deposited
    /// @param r The receiver of the principal tokens
    /// @return uint256 The amount of principal tokens burnt by the withdrawal
    function deposit(uint256 a, address r) external override returns (uint256) {
        // Execute the deposit
        return _deposit(r, a, 0);
    }

    /// @notice Before maturity mints `s` of PTs to `r` by spending underlying. Post or at maturity, reverts.
    /// @param s The amount of shares being minted
    /// @param r The receiver of the underlying tokens being withdrawn
    /// @param m Maximum amount of underlying that the user will spend
    /// @return uint256 The amount of principal tokens purchased
    function mint(
        uint256 s,
        address r,
        uint256 m
    ) external returns (uint256) {
        // Execute the mint
        return _mint(r, s, m);
    }

    /// @notice Before maturity mints `shares` of PTs to `receiver` by spending underlying. Post or at maturity, reverts.
    /// @param s The amount of shares being minted
    /// @param r The receiver of the underlying tokens being withdrawn
    /// @return uint256 The amount of principal tokens purchased
    function mint(uint256 s, address r) external override returns (uint256) {
        // Execute the mint
        return _mint(r, s, type(uint128).max);
    }

    /// @notice At or after maturity, burns PTs from owner and sends `a` underlying to `r`. Before maturity, sends `a` by selling shares of PT on a YieldSpace AMM.
    /// @param a The amount of underlying tokens withdrawn
    /// @param r The receiver of the underlying tokens being withdrawn
    /// @param o The owner of the underlying tokens
    /// @param m Maximum amount of PTs to be sold
    /// @return uint256 The amount of principal tokens burnt by the withdrawal
    function withdraw(
        uint256 a,
        address r,
        address o,
        uint256 m
    ) external returns (uint256) {
        // Execute the withdrawal
        return _withdraw(a, r, o, m);
    }

    /// @notice At or after maturity, burns PTs from owner and sends `a` underlying to `r`. Before maturity, sends `a` by selling shares of PT on a YieldSpace AMM.
    /// @param a The amount of underlying tokens withdrawn
    /// @param r The receiver of the underlying tokens being withdrawn
    /// @param o The owner of the underlying tokens
    /// @return uint256 The amount of principal tokens burnt by the withdrawal
    function withdraw(
        uint256 a,
        address r,
        address o
    ) external override returns (uint256) {
        // Execute the withdrawal
        return _withdraw(a, r, o, type(uint128).max);
    }

    /// @notice At or after maturity, burns exactly `s` of Principal Tokens from `o` and sends underlying tokens to `r`. Before maturity, sends underlying by selling `s` of PT on a YieldSpace AMM.
    /// @param s The number of shares to be burned in exchange for the underlying asset
    /// @param r The receiver of the underlying tokens being withdrawn
    /// @param o Address of the owner of the shares being burned
    /// @param m Minimum amount of underlying that must be received
    /// @return uint256 The amount of underlying tokens distributed by the redemption
    function redeem(
        uint256 s,
        address r,
        address o,
        uint256 m
    ) external returns (uint256) {
        // Execute the redemption
        return _redeem(s, r, o, m);
    }

    /// @notice At or after maturity, burns exactly `shares` of Principal Tokens from `owner` and sends `assets` of underlying tokens to `receiver`. Before maturity, sells `s` of PT on a YieldSpace AMM.
    /// @param s The number of shares to be burned in exchange for the underlying asset
    /// @param r The receiver of the underlying tokens being withdrawn
    /// @param o Address of the owner of the shares being burned
    /// @return uint256 The amount of underlying tokens distributed by the redemption
    function redeem(
        uint256 s,
        address r,
        address o
    ) external override returns (uint256) {
        // Execute the redemption
        return _redeem(s, r, o, 0);
    }

    /// @param f Address to burn from
    /// @param a Amount to burn
    /// @return bool true if successful
    function authBurn(address f, uint256 a)
        external
        authorized(redeemer)
        returns (bool)
    {
        _burn(f, a);
        return true;
    }

    /// @param t Address recieving the minted amount
    /// @param a The amount to mint
    /// @return bool True if successful
    function authMint(address t, uint256 a)
        external
        authorized(lender)
        returns (bool)
    {
        _mint(t, a);
        return true;
    }

    /// @param o Address of the owner of the tokens
    /// @param s Address of the spender
    /// @param a Amount to be approved
    function authApprove(
        address o,
        address s,
        uint256 a
    ) external authorized(redeemer) returns (bool) {
        _allowance[o][s] = a;
        return true;
    }

    function _deposit(
        address r,
        uint256 a,
        uint256 m
    ) internal returns (uint256) {
        // Revert if called at or after maturity
        if (block.timestamp >= maturity) {
            revert Exception(
                21,
                block.timestamp,
                maturity,
                address(0),
                address(0)
            );
        }

        // Receive the funds from the sender
        Safe.transferFrom(IERC20(underlying), msg.sender, address(this), a);

        // Sell the underlying assets for PTs
        uint128 returned = IMarketPlace(marketplace).sellUnderlying(
            underlying,
            maturity,
            Cast.u128(a),
            Cast.u128(m)
        );

        // Pass the received shares onto the intended receiver
        _transfer(address(this), r, returned);

        return returned;
    }

    function _mint(
        address r,
        uint256 s,
        uint256 m
    ) internal returns (uint256) {
        // Revert if called at or after maturity
        if (block.timestamp >= maturity) {
            revert Exception(
                21,
                block.timestamp,
                maturity,
                address(0),
                address(0)
            );
        }

        // Determine how many underlying tokens are needed to mint the shares
        uint256 required = IYield(pool).buyFYTokenPreview(Cast.u128(s));

        // Transfer the underlying to the token
        Safe.transferFrom(
            IERC20(underlying),
            msg.sender,
            address(this),
            required
        );

        // Swap the underlying for principal tokens via the pool
        uint128 sold = IMarketPlace(marketplace).buyPrincipalToken(
            underlying,
            maturity,
            Cast.u128(s),
            Cast.u128(m)
        );

        // Transfer the principal tokens to the desired receiver
        _transfer(address(this), r, s);

        return sold;
    }

    function _withdraw(
        uint256 a,
        address r,
        address o,
        uint256 m
    ) internal returns (uint256) {
        // Determine how many principal tokens are needed to purchase the underlying
        uint256 needed = previewWithdraw(a);

        // Pre maturity
        if (block.timestamp < maturity) {
            // Receive the shares from the caller
            _transfer(o, address(this), needed);

            // If owner is the sender, sell PT without allowance check
            if (o == msg.sender) {
                uint128 returned = IMarketPlace(marketplace).buyUnderlying(
                    underlying,
                    maturity,
                    Cast.u128(a),
                    Cast.u128(m)
                );

                // Transfer the underlying to the desired receiver
                Safe.transfer(IERC20(underlying), r, a);

                return returned;
            } else {
                // Else, sell PT with allowance check
                // Get the allowance of the user spending the tokens
                uint256 allowance = _allowance[o][msg.sender];

                // Check for sufficient allowance
                if (allowance < needed) {
                    revert Exception(20, allowance, a, address(0), address(0));
                }

                // Update the caller's allowance
                _allowance[o][msg.sender] = allowance - needed;

                // Sell the principal tokens for underlying
                uint128 returned = IMarketPlace(marketplace).buyUnderlying(
                    underlying,
                    maturity,
                    Cast.u128(a),
                    Cast.u128(m)
                );

                // Transfer the underlying to the desired receiver
                Safe.transfer(IERC20(underlying), r, returned);

                return returned;
            }
        }
        // Post maturity
        else {
            // If owner is the sender, redeem PT without allowance check
            if (o == msg.sender) {
                // Execute the redemption to the desired receiver
                return
                    IRedeemer(redeemer).authRedeem(
                        underlying,
                        maturity,
                        msg.sender,
                        r,
                        needed
                    );
            } else {
                // Get the allowance of the user spending the tokens
                uint256 allowance = _allowance[o][msg.sender];

                // Check for sufficient allowance
                if (allowance < needed) {
                    revert Exception(
                        20,
                        allowance,
                        needed,
                        address(0),
                        address(0)
                    );
                }

                // Update the callers's allowance
                _allowance[o][msg.sender] = allowance - needed;

                // Execute the redemption to the desired receiver
                return
                    IRedeemer(redeemer).authRedeem(
                        underlying,
                        maturity,
                        o,
                        r,
                        needed
                    );
            }
        }
    }

    function _redeem(
        uint256 s,
        address r,
        address o,
        uint256 m
    ) internal returns (uint256) {
        // Pre-maturity
        if (block.timestamp < maturity) {
            // Receive the funds from the user
            _transfer(o, address(this), s);

            // If owner is the sender, sell PT without allowance check
            if (o == msg.sender) {
                // Swap principal tokens for the underlying asset
                uint128 returned = IMarketPlace(marketplace).sellPrincipalToken(
                    underlying,
                    maturity,
                    Cast.u128(s),
                    Cast.u128(m)
                );

                // Transfer underlying to the desired receiver
                Safe.transfer(IERC20(underlying), r, returned);
                return returned;
                // Else, sell PT with allowance check
            } else {
                // Get the allowance of the user spending the tokens
                uint256 allowance = _allowance[o][msg.sender];

                // Check for sufficient allowance
                if (allowance < s) {
                    revert Exception(20, allowance, s, address(0), address(0));
                }

                // Update the caller's allowance
                _allowance[o][msg.sender] = allowance - s;

                // Sell the principal tokens for the underlying
                uint128 returned = IMarketPlace(marketplace).sellPrincipalToken(
                    underlying,
                    maturity,
                    Cast.u128(s),
                    Cast.u128(m)
                );

                // Transfer the underlying to the desired receiver
                Safe.transfer(IERC20(underlying), r, returned);
                return returned;
            }
            // Post-maturity
        } else {
            // If owner is the sender, redeem PT without allowance check
            if (o == msg.sender) {
                // Execute the redemption to the desired receiver
                return
                    IRedeemer(redeemer).authRedeem(
                        underlying,
                        maturity,
                        msg.sender,
                        r,
                        s
                    );
            } else {
                // Get the allowance of the user spending the tokens
                uint256 allowance = _allowance[o][msg.sender];

                // Check for sufficient allowance
                if (allowance < s) {
                    revert Exception(20, allowance, s, address(0), address(0));
                }

                // Update the caller's allowance
                _allowance[o][msg.sender] = allowance - s;

                // Execute the redemption to the desired receiver
                return
                    IRedeemer(redeemer).authRedeem(
                        underlying,
                        maturity,
                        o,
                        r,
                        s
                    );
            }
        }
    }
}

// Taken from https://github.com/sushiswap/BoringSolidity/blob/441e51c0544cf2451e6116fe00515e71d7c42e2c/contracts/BoringBatchable.sol

library RevertMsgExtractor {
    /// @dev Helper function to extract a useful revert message from a failed call.
    /// If the returned data is malformed or not correctly abi encoded then this call can fail itself.
    function getRevertMsg(bytes memory returnData)
        internal
        pure
        returns (string memory)
    {
        // If the _res length is less than 68, then the transaction failed silently (without a revert message)
        if (returnData.length < 68) return 'Transaction reverted silently';

        assembly {
            // Slice the sighash.
            returnData := add(returnData, 0x04)
        }
        return abi.decode(returnData, (string)); // All that remains is the revert string
    }
}

interface ILender {
    function approve(
        address,
        address,
        address,
        address,
        address
    ) external;

    function transferFYTs(address, uint256) external;

    function transferPremium(address, uint256) external;

    function paused(uint8) external returns (bool);

    function halted() external returns (bool);
}

interface ICreator {
    function create(
        address,
        uint256,
        address,
        address,
        address,
        string calldata,
        string calldata
    ) external returns (address);
}

interface IPool {
    function ts() external view returns (int128);

    function g1() external view returns (int128);

    function g2() external view returns (int128);

    function maturity() external view returns (uint32);

    function scaleFactor() external view returns (uint96);

    function getCache()
        external
        view
        returns (
            uint112,
            uint112,
            uint32
        );

    // NOTE This will be deprecated
    function base() external view returns (IERC20);

    function baseToken() external view returns (address);

    function fyToken() external view returns (IERC5095);

    function getBaseBalance() external view returns (uint112);

    function getFYTokenBalance() external view returns (uint112);

    function retrieveBase(address) external returns (uint128 retrieved);

    function retrieveFYToken(address) external returns (uint128 retrieved);

    function sellBase(address, uint128) external returns (uint128);

    function buyBase(
        address,
        uint128,
        uint128
    ) external returns (uint128);

    function sellFYToken(address, uint128) external returns (uint128);

    function buyFYToken(
        address,
        uint128,
        uint128
    ) external returns (uint128);

    function sellBasePreview(uint128) external view returns (uint128);

    function buyBasePreview(uint128) external view returns (uint128);

    function sellFYTokenPreview(uint128) external view returns (uint128);

    function buyFYTokenPreview(uint128) external view returns (uint128);

    function mint(
        address,
        address,
        uint256,
        uint256
    )
        external
        returns (
            uint256,
            uint256,
            uint256
        );

    function mintWithBase(
        address,
        address,
        uint256,
        uint256,
        uint256
    )
        external
        returns (
            uint256,
            uint256,
            uint256
        );

    function burn(
        address,
        address,
        uint256,
        uint256
    )
        external
        returns (
            uint256,
            uint256,
            uint256
        );

    function burnForBase(
        address,
        uint256,
        uint256
    ) external returns (uint256, uint256);

    function cumulativeBalancesRatio() external view returns (uint256);

    function sync() external;
}

interface IPendleToken {
    function SY() external view returns (address);

    function YT() external view returns (address);

    function expiry() external view returns (uint256);
}

interface IAPWineToken {
    function futureVault() external view returns (address);
}

interface IAPWineFutureVault {
    function PERIOD_DURATION() external view returns (uint256);

    function getControllerAddress() external view returns (address);

    function getCurrentPeriodIndex() external view returns (uint256);

    function getFYTofPeriod(uint256) external view returns (address);

    function getIBTAddress() external view returns (address);

    function startNewPeriod() external;
}

/// @title MarketPlace
/// @author Sourabh Marathe, Julian Traversa, Rob Robbins
/// @notice This contract is in charge of managing the available principals for each loan market.
/// @notice In addition, this contract routes swap orders between Illuminate PTs and their respective underlying to YieldSpace pools.
contract MarketPlace {
    /// @notice the available principals
    /// @dev the order of this enum is used to select principals from the markets
    /// mapping (e.g. Illuminate => 0, Swivel => 1, and so on)
    enum Principals {
        Illuminate, // 0
        Swivel, // 1
        Yield, // 2
        Element, // 3
        Pendle, // 4
        Tempus, // 5
        Sense, // 6
        Apwine, // 7
        Notional // 8
    }

    /// @notice markets are defined by a tuple that points to a fixed length array of principal token addresses.
    mapping(address => mapping(uint256 => address[9])) public markets;

    /// @notice pools map markets to their respective YieldSpace pools for the MetaPrincipal token
    mapping(address => mapping(uint256 => address)) public pools;

    /// @notice address that is allowed to create markets, set pools, etc. It is commonly used in the authorized modifier.
    address public admin;
    /// @notice address of the deployed redeemer contract
    address public immutable redeemer;
    /// @notice address of the deployed lender contract
    address public immutable lender;
    /// @notice address of the deployed creator contract
    address public immutable creator;

    /// @notice emitted upon the creation of a new market
    event CreateMarket(
        address indexed underlying,
        uint256 indexed maturity,
        address[9] tokens,
        address element,
        address apwine
    );
    /// @notice emitted upon setting a principal token
    event SetPrincipal(
        address indexed underlying,
        uint256 indexed maturity,
        address indexed principal,
        uint8 protocol
    );
    /// @notice emitted upon swapping with the pool
    event Swap(
        address indexed underlying,
        uint256 indexed maturity,
        address sold,
        address bought,
        uint256 received,
        uint256 spent,
        address spender
    );
    /// @notice emitted upon minting tokens with the pool
    event Mint(
        address indexed underlying,
        uint256 indexed maturity,
        uint256 underlyingIn,
        uint256 principalTokensIn,
        uint256 minted,
        address minter
    );
    /// @notice emitted upon burning tokens with the pool
    event Burn(
        address indexed underlying,
        uint256 indexed maturity,
        uint256 tokensBurned,
        uint256 underlyingReceived,
        uint256 principalTokensReceived,
        address burner
    );
    /// @notice emitted upon changing the admin
    event SetAdmin(address indexed admin);
    /// @notice emitted upon setting a pool
    event SetPool(
        address indexed underlying,
        uint256 indexed maturity,
        address indexed pool
    );

    /// @notice ensures that only a certain address can call the function
    /// @param a address that msg.sender must be to be authorized
    modifier authorized(address a) {
        if (msg.sender != a) {
            revert Exception(0, 0, 0, msg.sender, a);
        }
        _;
    }

    /// @notice initializes the MarketPlace contract
    /// @param r address of the deployed redeemer contract
    /// @param l address of the deployed lender contract
    /// @param c address of the deployed creator contract
    constructor(
        address r,
        address l,
        address c
    ) {
        admin = msg.sender;
        redeemer = r;
        lender = l;
        creator = c;
    }

    /// @notice creates a new market for the given underlying token and maturity
    /// @param u address of an underlying asset
    /// @param m maturity (timestamp) of the market
    /// @param t principal token addresses for this market
    /// @param n name for the Illuminate token
    /// @param s symbol for the Illuminate token
    /// @param a address of the APWine router that corresponds to this market
    /// @param e address of the Element vault that corresponds to this market
    /// @param h address of a helper contract, used for Sense approvals if active in the market
    /// @param sensePeriphery address of the Sense periphery contract that must be approved by the lender
    /// @return bool true if successful
    function createMarket(
        address u,
        uint256 m,
        address[8] calldata t,
        string calldata n,
        string calldata s,
        address a,
        address e,
        address h,
        address sensePeriphery
    ) external authorized(admin) returns (bool) {
        {
            // Get the Illuminate principal token for this market (if one exists)
            address illuminate = markets[u][m][0];

            // If illuminate PT already exists, a new market cannot be created
            if (illuminate != address(0)) {
                revert Exception(9, 0, 0, illuminate, address(0));
            }
        }

        // Create an Illuminate principal token for the new market
        address illuminateToken = ICreator(creator).create(
            u,
            m,
            redeemer,
            lender,
            address(this),
            n,
            s
        );

        {
            // create the principal tokens array
            address[9] memory market = [
                illuminateToken, // Illuminate
                t[0], // Swivel
                t[1], // Yield
                t[2], // Element
                t[3], // Pendle
                t[4], // Tempus
                t[5], // Sense
                t[6], // APWine
                t[7] // Notional
            ];

            // Set the market
            markets[u][m] = market;

            // Have the lender contract approve the several contracts
            ILender(lender).approve(u, a, e, t[7], sensePeriphery);

            // Allow converter to spend interest bearing asset
            if (t[5] != address(0)) {
                IRedeemer(redeemer).approve(h);
            }

            // Approve interest bearing token conversion to underlying for APWine
            if (t[6] != address(0)) {
                address futureVault = IAPWineToken(t[6]).futureVault();
                address interestBearingToken = IAPWineFutureVault(futureVault)
                    .getIBTAddress();
                IRedeemer(redeemer).approve(interestBearingToken);
            }

            emit CreateMarket(u, m, market, e, a);
        }
        return true;
    }

    /// @notice allows the admin to set an individual market
    /// @param p principal value according to the MarketPlace's Principals Enum
    /// @param u address of an underlying asset
    /// @param m maturity (timestamp) of the market
    /// @param a address of the new principal token
    /// @param h a supplementary address (apwine needs a router, element needs a vault, sense needs interest bearing asset)
    /// @param sensePeriphery address of the Sense periphery contract that must be approved by the lender
    /// @return bool true if the principal set, false otherwise
    function setPrincipal(
        uint8 p,
        address u,
        uint256 m,
        address a,
        address h,
        address sensePeriphery
    ) external authorized(admin) returns (bool) {
        // Set the principal token in the markets mapping
        markets[u][m][p] = a;

        if (p == uint8(Principals.Element)) {
            // Approve Element vault if setting Element's principal token
            ILender(lender).approve(u, address(0), h, address(0), address(0));
        } else if (p == uint8(Principals.Sense)) {
            // Approve converter to transfer yield token for Sense's redeem
            IRedeemer(redeemer).approve(h);

            // Approve Periphery to be used from Lender
            ILender(lender).approve(
                u,
                address(0),
                address(0),
                address(0),
                sensePeriphery
            );
        } else if (p == uint8(Principals.Apwine)) {
            // Approve converter to transfer yield token for APWine's redeem
            address futureVault = IAPWineToken(a).futureVault();
            address interestBearingToken = IAPWineFutureVault(futureVault)
                .getIBTAddress();
            IRedeemer(redeemer).approve(interestBearingToken);

            // Approve APWine's router if setting APWine's principal token
            ILender(lender).approve(u, h, address(0), address(0), address(0));
        } else if (p == uint8(Principals.Notional)) {
            // Principal token must be approved for Notional's lend
            ILender(lender).approve(u, address(0), address(0), a, address(0));
        }

        emit SetPrincipal(u, m, a, p);
        return true;
    }

    /// @notice sets the admin address
    /// @param a Address of a new admin
    /// @return bool true if the admin set, false otherwise
    function setAdmin(address a) external authorized(admin) returns (bool) {
        admin = a;
        emit SetAdmin(a);
        return true;
    }

    /// @notice sets the address for a pool
    /// @param u address of an underlying asset
    /// @param m maturity (timestamp) of the market
    /// @param a address of the pool
    /// @return bool true if the pool set, false otherwise
    function setPool(
        address u,
        uint256 m,
        address a
    ) external authorized(admin) returns (bool) {
        // Verify that the pool has not already been set
        address pool = pools[u][m];

        // Revert if the pool already exists
        if (pool != address(0)) {
            revert Exception(10, 0, 0, pool, address(0));
        }

        // Set the pool
        pools[u][m] = a;

        // Get the principal token
        ERC5095 pt = ERC5095(markets[u][m][uint8(Principals.Illuminate)]);

        // Set the pool for the principal token
        pt.setPool(a);

        // Approve the marketplace to spend the principal and underlying tokens
        pt.approveMarketPlace();

        emit SetPool(u, m, a);
        return true;
    }

    /// @notice sells the PT for the underlying via the pool
    /// @param u address of an underlying asset
    /// @param m maturity (timestamp) of the market
    /// @param a amount of PTs to sell
    /// @param s slippage cap, minimum amount of underlying that must be received
    /// @return uint128 amount of underlying bought
    function sellPrincipalToken(
        address u,
        uint256 m,
        uint128 a,
        uint128 s
    ) external returns (uint128) {
        // Get the pool for the market
        IPool pool = IPool(pools[u][m]);

        // Preview amount of underlying received by selling `a` PTs
        uint256 expected = pool.sellFYTokenPreview(a);

        // Verify that the amount needed does not exceed the slippage parameter
        if (expected < s) {
            revert Exception(16, expected, s, address(0), address(0));
        }

        // Transfer the principal tokens to the pool
        Safe.transferFrom(
            IERC20(address(pool.fyToken())),
            msg.sender,
            address(pool),
            a
        );

        // Execute the swap
        uint128 received = pool.sellFYToken(msg.sender, Cast.u128(expected));
        emit Swap(u, m, address(pool.fyToken()), u, received, a, msg.sender);

        return received;
    }

    /// @notice buys the PT for the underlying via the pool
    /// @notice determines how many underlying to sell by using the preview
    /// @param u address of an underlying asset
    /// @param m maturity (timestamp) of the market
    /// @param a amount of PTs to be purchased
    /// @param s slippage cap, maximum number of underlying that can be sold
    /// @return uint128 amount of underlying sold
    function buyPrincipalToken(
        address u,
        uint256 m,
        uint128 a,
        uint128 s
    ) external returns (uint128) {
        // Get the pool for the market
        IPool pool = IPool(pools[u][m]);

        // Get the amount of base hypothetically required to purchase `a` PTs
        uint128 expected = pool.buyFYTokenPreview(a);

        // Verify that the amount needed does not exceed the slippage parameter
        if (expected > s) {
            revert Exception(16, expected, 0, address(0), address(0));
        }

        // Transfer the underlying tokens to the pool
        Safe.transferFrom(
            IERC20(pool.base()),
            msg.sender,
            address(pool),
            expected
        );

        // Execute the swap to purchase `a` base tokens
        uint128 spent = pool.buyFYToken(msg.sender, a, expected);

        emit Swap(u, m, u, address(pool.fyToken()), a, spent, msg.sender);
        return spent;
    }

    /// @notice sells the underlying for the PT via the pool
    /// @param u address of an underlying asset
    /// @param m maturity (timestamp) of the market
    /// @param a amount of underlying to sell
    /// @param s slippage cap, minimum number of PTs that must be received
    /// @return uint128 amount of PT purchased
    function sellUnderlying(
        address u,
        uint256 m,
        uint128 a,
        uint128 s
    ) external returns (uint128) {
        // Get the pool for the market
        IPool pool = IPool(pools[u][m]);

        // Get the number of PTs received for selling `a` underlying tokens
        uint128 expected = pool.sellBasePreview(a);

        // Verify slippage does not exceed the one set by the user
        if (expected < s) {
            revert Exception(16, expected, 0, address(0), address(0));
        }

        // Transfer the underlying tokens to the pool
        Safe.transferFrom(IERC20(pool.base()), msg.sender, address(pool), a);

        // Execute the swap
        uint128 received = pool.sellBase(msg.sender, expected);

        emit Swap(u, m, u, address(pool.fyToken()), received, a, msg.sender);
        return received;
    }

    /// @notice buys the underlying for the PT via the pool
    /// @notice determines how many PTs to sell by using the preview
    /// @param u address of an underlying asset
    /// @param m maturity (timestamp) of the market
    /// @param a amount of underlying to be purchased
    /// @param s slippage cap, maximum number of PTs that can be sold
    /// @return uint128 amount of PTs sold
    function buyUnderlying(
        address u,
        uint256 m,
        uint128 a,
        uint128 s
    ) external returns (uint128) {
        // Get the pool for the market
        IPool pool = IPool(pools[u][m]);

        // Get the amount of PTs hypothetically required to purchase `a` underlying
        uint256 expected = pool.buyBasePreview(a);

        // Verify that the amount needed does not exceed the slippage parameter
        if (expected > s) {
            revert Exception(16, expected, 0, address(0), address(0));
        }

        // Transfer the principal tokens to the pool
        Safe.transferFrom(
            IERC20(address(pool.fyToken())),
            msg.sender,
            address(pool),
            expected
        );

        // Execute the swap to purchase `a` underlying tokens
        uint128 spent = pool.buyBase(msg.sender, a, Cast.u128(expected));

        emit Swap(u, m, address(pool.fyToken()), u, a, spent, msg.sender);
        return spent;
    }

    /// @notice mint liquidity tokens in exchange for adding underlying and PT
    /// @dev amount of liquidity tokens to mint is calculated from the amount of unaccounted for PT in this contract.
    /// @dev A proportional amount of underlying tokens need to be present in this contract, also unaccounted for.
    /// @param u the address of the underlying token
    /// @param m the maturity of the principal token
    /// @param b number of base tokens
    /// @param p the principal token amount being sent
    /// @param minRatio minimum ratio of LP tokens to PT in the pool.
    /// @param maxRatio maximum ratio of LP tokens to PT in the pool.
    /// @return uint256 number of base tokens passed to the method
    /// @return uint256 number of yield tokens passed to the method
    /// @return uint256 the amount of tokens minted.
    function mint(
        address u,
        uint256 m,
        uint256 b,
        uint256 p,
        uint256 minRatio,
        uint256 maxRatio
    )
        external
        returns (
            uint256,
            uint256,
            uint256
        )
    {
        // Get the pool for the market
        IPool pool = IPool(pools[u][m]);

        // Transfer the underlying tokens to the pool
        Safe.transferFrom(IERC20(pool.base()), msg.sender, address(pool), b);

        // Transfer the principal tokens to the pool
        Safe.transferFrom(
            IERC20(address(pool.fyToken())),
            msg.sender,
            address(pool),
            p
        );

        // Mint the tokens and return the leftover assets to the caller
        (uint256 underlyingIn, uint256 principalTokensIn, uint256 minted) = pool
            .mint(msg.sender, msg.sender, minRatio, maxRatio);

        emit Mint(u, m, underlyingIn, principalTokensIn, minted, msg.sender);
        return (underlyingIn, principalTokensIn, minted);
    }

    /// @notice Mint liquidity tokens in exchange for adding only underlying
    /// @dev amount of liquidity tokens is calculated from the amount of PT to buy from the pool,
    /// plus the amount of unaccounted for PT in this contract.
    /// @param u the address of the underlying token
    /// @param m the maturity of the principal token
    /// @param a the underlying amount being sent
    /// @param p amount of `PT` being bought in the Pool, from this we calculate how much underlying it will be taken in.
    /// @param minRatio minimum ratio of LP tokens to PT in the pool.
    /// @param maxRatio maximum ratio of LP tokens to PT in the pool.
    /// @return uint256 number of base tokens passed to the method
    /// @return uint256 number of yield tokens passed to the method
    /// @return uint256 the amount of tokens minted.
    function mintWithUnderlying(
        address u,
        uint256 m,
        uint256 a,
        uint256 p,
        uint256 minRatio,
        uint256 maxRatio
    )
        external
        returns (
            uint256,
            uint256,
            uint256
        )
    {
        // Get the pool for the market
        IPool pool = IPool(pools[u][m]);

        // Transfer the underlying tokens to the pool
        Safe.transferFrom(IERC20(pool.base()), msg.sender, address(pool), a);

        // Mint the tokens to the user
        (uint256 underlyingIn, , uint256 minted) = pool.mintWithBase(
            msg.sender,
            msg.sender,
            p,
            minRatio,
            maxRatio
        );

        emit Mint(u, m, underlyingIn, 0, minted, msg.sender);
        return (underlyingIn, 0, minted);
    }

    /// @notice burn liquidity tokens in exchange for underlying and PT.
    /// @param u the address of the underlying token
    /// @param m the maturity of the principal token
    /// @param a the amount of liquidity tokens to burn
    /// @param minRatio minimum ratio of LP tokens to PT in the pool
    /// @param maxRatio maximum ratio of LP tokens to PT in the pool
    /// @return uint256 amount of LP tokens burned
    /// @return uint256 amount of base tokens received
    /// @return uint256 amount of fyTokens received
    function burn(
        address u,
        uint256 m,
        uint256 a,
        uint256 minRatio,
        uint256 maxRatio
    )
        external
        returns (
            uint256,
            uint256,
            uint256
        )
    {
        // Get the pool for the market
        IPool pool = IPool(pools[u][m]);

        // Transfer the underlying tokens to the pool
        Safe.transferFrom(IERC20(address(pool)), msg.sender, address(pool), a);

        // Burn the tokens
        (
            uint256 tokensBurned,
            uint256 underlyingReceived,
            uint256 principalTokensReceived
        ) = pool.burn(msg.sender, msg.sender, minRatio, maxRatio);

        emit Burn(
            u,
            m,
            tokensBurned,
            underlyingReceived,
            principalTokensReceived,
            msg.sender
        );
        return (tokensBurned, underlyingReceived, principalTokensReceived);
    }

    /// @notice burn liquidity tokens in exchange for underlying.
    /// @param u the address of the underlying token
    /// @param m the maturity of the principal token
    /// @param a the amount of liquidity tokens to burn
    /// @param minRatio minimum ratio of LP tokens to PT in the pool.
    /// @param maxRatio minimum ratio of LP tokens to PT in the pool.
    /// @return uint256 amount of PT tokens sent to the pool
    /// @return uint256 amount of underlying tokens returned
    function burnForUnderlying(
        address u,
        uint256 m,
        uint256 a,
        uint256 minRatio,
        uint256 maxRatio
    ) external returns (uint256, uint256) {
        // Get the pool for the market
        IPool pool = IPool(pools[u][m]);

        // Transfer the underlying tokens to the pool
        Safe.transferFrom(IERC20(address(pool)), msg.sender, address(pool), a);

        // Burn the tokens in exchange for underlying tokens
        (uint256 tokensBurned, uint256 underlyingReceived) = pool.burnForBase(
            msg.sender,
            minRatio,
            maxRatio
        );

        emit Burn(u, m, tokensBurned, underlyingReceived, 0, msg.sender);
        return (tokensBurned, underlyingReceived);
    }

    /// @notice Allows batched call to self (this contract).
    /// @param c An array of inputs for each call.
    function batch(bytes[] calldata c)
        external
        payable
        returns (bytes[] memory results)
    {
        results = new bytes[](c.length);
        for (uint256 i; i < c.length; i++) {
            (bool success, bytes memory result) = address(this).delegatecall(
                c[i]
            );
            if (!success) revert(RevertMsgExtractor.getRevertMsg(result));
            results[i] = result;
        }
    }
}

library Swivel {
    // the components of a ECDSA signature
    struct Components {
        uint8 v;
        bytes32 r;
        bytes32 s;
    }

    struct Order {
        bytes32 key;
        uint8 protocol;
        address maker;
        address underlying;
        bool vault;
        bool exit;
        uint256 principal;
        uint256 premium;
        uint256 maturity;
        uint256 expiry;
    }
}

library Pendle {
    struct ApproxParams {
        uint256 guessMin;
        uint256 guessMax;
        uint256 guessOffchain;
        uint256 maxIteration;
        uint256 eps;
    }

    struct TokenInput {
        // Token/Sy data
        address tokenIn;
        uint256 netTokenIn;
        address tokenMintSy;
        address bulk;
        // Kyber data
        address kyberRouter;
        bytes kybercall;
    }
}

interface IAny {}

library Element {
    enum SwapKind {
        GIVEN_IN,
        GIVEN_OUT
    }

    struct SingleSwap {
        bytes32 poolId;
        SwapKind kind;
        IAny assetIn;
        IAny assetOut;
        uint256 amount;
        bytes userData;
    }

    struct FundManagement {
        address sender;
        bool fromInternalBalance;
        address payable recipient;
        bool toInternalBalance;
    }
}

interface ISwivelToken {
    function maturity() external view returns (uint256);
}

interface IYieldToken {
    function redeem(address, uint256) external returns (uint256);

    function underlying() external returns (address);

    function maturity() external view returns (uint256);
}

interface IElementToken {
    function unlockTimestamp() external view returns (uint256);

    function underlying() external returns (address);

    function withdrawPrincipal(uint256 amount, address destination)
        external
        returns (uint256);
}

interface ITempusToken {
    function balanceOf(address) external returns (uint256);

    function pool() external view returns (address);
}

interface ITempusPool {
    function maturityTime() external view returns (uint256);

    function backingToken() external view returns (address);

    function controller() external view returns (address);

    // Used for integration testing
    function principalShare() external view returns (address);

    function currentInterestRate() external view returns (uint256);

    function initialInterestRate() external view returns (uint256);
}

interface IAPWineController {
    function getNextPeriodStart(uint256) external view returns (uint256);

    function withdraw(address, uint256) external;

    function createFYTDelegationTo(
        address,
        address,
        uint256
    ) external;
}

interface INotional {
    function getUnderlyingToken() external view returns (IERC20, int256);

    function getMaturity() external view returns (uint40);

    function deposit(uint256, address) external returns (uint256);

    function maxRedeem(address) external returns (uint256);

    function redeem(
        uint256,
        address,
        address
    ) external returns (uint256);
}

library Maturities {
    /// @notice returns the maturity for an Illumiante principal token
    /// @param p address of the principal token contract
    /// @return uint256 maturity of the principal token
    function illuminate(address p) internal view returns (uint256) {
        return IERC5095(p).maturity();
    }

    /// @notice returns the maturity for a Swivel principal token
    /// @param p address of the principal token contract
    /// @return uint256 maturity of the principal token
    function swivel(address p) internal view returns (uint256) {
        return ISwivelToken(p).maturity();
    }

    function yield(address p) internal view returns (uint256) {
        return IYieldToken(p).maturity();
    }

    /// @notice returns the maturity for an Element principal token
    /// @param p address of the principal token contract
    /// @return uint256 maturity of the principal token
    function element(address p) internal view returns (uint256) {
        return IElementToken(p).unlockTimestamp();
    }

    /// @notice returns the maturity for a Pendle principal token
    /// @param p address of the principal token contract
    /// @return uint256 maturity of the principal token
    function pendle(address p) internal view returns (uint256) {
        return IPendleToken(p).expiry();
    }

    /// @notice returns the maturity for a Tempus principal token
    /// @param p address of the principal token contract
    /// @return uint256 maturity of the principal token
    function tempus(address p) internal view returns (uint256) {
        return ITempusPool(ITempusToken(p).pool()).maturityTime();
    }

    /// @notice returns the maturity for a APWine principal token
    /// @param p address of the principal token contract
    /// @return uint256 maturity of the principal token
    function apwine(address p) internal view returns (uint256) {
        address futureVault = IAPWineToken(p).futureVault();

        address controller = IAPWineFutureVault(futureVault)
            .getControllerAddress();

        uint256 duration = IAPWineFutureVault(futureVault).PERIOD_DURATION();

        return IAPWineController(controller).getNextPeriodStart(duration);
    }

    /// @notice returns the maturity for a Notional principal token
    /// @param p address of the principal token contract
    /// @return uint256 maturity of the principal token
    function notional(address p) internal view returns (uint256) {
        return INotional(p).getMaturity();
    }
}

interface ITempus {
    function depositAndFix(
        address,
        uint256,
        bool,
        uint256,
        uint256
    ) external;

    function redeemToBacking(
        address,
        uint256,
        uint256,
        address
    ) external;
}

interface ITempusAMM {
    function balanceOf(address) external view returns (uint256);

    function tempusPool() external view returns (address);
}

interface ISensePeriphery {
    function divider() external view returns (address);

    function swapUnderlyingForPTs(
        address,
        uint256,
        uint256,
        uint256
    ) external returns (uint256);

    function verified(address) external view returns (bool);
}

interface ISenseDivider {
    function redeem(
        address,
        uint256,
        uint256
    ) external returns (uint256);

    function pt(address, uint256) external view returns (address);

    // only used by integration tests
    function settleSeries(address, uint256) external;

    function adapterAddresses(uint256) external view returns (address);
}

interface ISwivel {
    function initiate(
        Swivel.Order[] calldata,
        uint256[] calldata,
        Swivel.Components[] calldata
    ) external returns (bool);

    function redeemZcToken(
        uint8 p,
        address u,
        uint256 m,
        uint256 a
    ) external returns (bool);
}

interface IElementVault {
    function swap(
        Element.SingleSwap memory,
        Element.FundManagement memory,
        uint256,
        uint256
    ) external returns (uint256);
}

interface IAPWineAMMPool {
    function getUnderlyingOfIBTAddress() external view returns (address);

    function getPTAddress() external view returns (address);
}

interface IAPWineRouter {
    function swapExactAmountIn(
        address,
        uint256[] calldata,
        uint256[] calldata,
        uint256,
        uint256,
        address,
        uint256,
        address
    ) external returns (uint256);
}

interface IPendle {
    function swapExactTokenForPt(
        address,
        address,
        uint256,
        Pendle.ApproxParams calldata,
        Pendle.TokenInput calldata
    ) external returns (uint256, uint256);
}

interface IPendleMarket {
    function readTokens()
        external
        view
        returns (
            address,
            address,
            address
        );
}

/// @title Lender
/// @author Sourabh Marathe, Julian Traversa, Rob Robbins
/// @notice The lender contract executes loans on behalf of users
/// @notice The contract holds the principal tokens and mints an ERC-5095 tokens to users to represent their loans
contract Lender {
    /// @notice minimum wait before the admin may withdraw funds or change the fee rate
    uint256 public constant HOLD = 3 days;

    /// @notice address that is allowed to set and withdraw fees, disable principals, etc. It is commonly used in the authorized modifier.
    address public admin;
    /// @notice address of the MarketPlace contract, used to access the markets mapping
    address public marketPlace;
    /// @notice mapping that determines if a principal has been paused by the admin
    mapping(uint8 => bool) public paused;
    /// @notice flag that allows admin to stop all lending and minting across the entire protocol
    bool public halted;

    /// @notice contract used to execute swaps on Swivel's exchange
    address public immutable swivelAddr;
    /// @notice a SushiSwap router used by Pendle to execute swaps
    address public immutable pendleAddr;
    /// @notice a pool router used by APWine to execute swaps
    address public immutable apwineAddr;

    /// @notice a mapping that tracks the amount of unswapped premium by market. This underlying is later transferred to the Redeemer during Swivel's redeem call
    mapping(address => mapping(uint256 => uint256)) public premiums;

    /// @notice this value determines the amount of fees paid on loans
    uint256 public feenominator;
    /// @notice represents a point in time where the feenominator may change
    uint256 public feeChange;
    /// @notice represents a minimum that the feenominator must exceed
    uint256 public constant MIN_FEENOMINATOR = 500;

    /// @notice maps underlying tokens to the amount of fees accumulated for that token
    mapping(address => uint256) public fees;
    /// @notice maps a token address to a point in time, a hold, after which a withdrawal can be made
    mapping(address => uint256) public withdrawals;

    // Reantrancy protection
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;
    uint256 private _status = _NOT_ENTERED;

    // Rate limiting protection
    /// @notice maximum amount of value that can flow through a protocol in a day (in USD)
    uint256 public constant MAX_VALUE = 2_000_000e27;
    /// @notice maps protocols to how much value, in USD, has flowed through each protocol
    mapping(uint8 => uint256) public protocolFlow;
    /// @notice timestamp from which values flowing through protocol has begun
    mapping(uint8 => uint256) public periodStart;
    /// @notice estimated price of ether, set by the admin
    uint256 public etherPrice = 2_500;

    /// @notice emitted upon lending to a protocol
    event Lend(
        uint8 principal,
        address indexed underlying,
        uint256 indexed maturity,
        uint256 returned,
        uint256 spent,
        address sender
    );
    /// @notice emitted upon minting Illuminate principal tokens
    event Mint(
        uint8 principal,
        address indexed underlying,
        uint256 indexed maturity,
        uint256 amount
    );
    /// @notice emitted upon scheduling a withdrawal
    event ScheduleWithdrawal(address indexed token, uint256 hold);
    /// @notice emitted upon blocking a scheduled withdrawal
    event BlockWithdrawal(address indexed token);
    /// @notice emitted upon changing the admin
    event SetAdmin(address indexed admin);
    /// @notice emitted upon setting the fee rate
    event SetFee(uint256 indexed fee);
    /// @notice emitted upon scheduling a fee change
    event ScheduleFeeChange(uint256 when);
    /// @notice emitted upon blocking a scheduled fee change
    event BlockFeeChange();
    /// @notice emitted upon pausing or unpausing of a principal
    event PausePrincipal(uint8 principal, bool indexed state);
    /// @notice emitted upon pausing or unpausing minting, lending and redeeming
    event PauseIlluminate(bool state);

    /// @notice ensures that only a certain address can call the function
    /// @param a address that msg.sender must be to be authorized
    modifier authorized(address a) {
        if (msg.sender != a) {
            revert Exception(0, 0, 0, msg.sender, a);
        }
        _;
    }

    /// @notice reverts on all markets where the paused mapping returns true
    /// @param u address of an underlying asset
    /// @param m maturity (timestamp) of the market
    /// @param p principal value according to the MarketPlace's Principals Enum
    modifier unpaused(
        address u,
        uint256 m,
        uint8 p
    ) {
        if (paused[p] || halted) {
            revert Exception(1, p, 0, address(0), address(0));
        }
        _;
    }

    /// @notice reverts if called after maturity
    /// @param m maturity (timestamp) of the market
    modifier matured(uint256 m) {
        if (block.timestamp > m) {
            revert Exception(2, block.timestamp, m, address(0), address(0));
        }
        _;
    }

    /// @notice prevents users from re-entering contract
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        if (_status == _ENTERED) {
            revert Exception(30, 0, 0, address(0), address(0));
        }

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }

    /// @notice initializes the Lender contract
    /// @param s the Swivel contract
    /// @param p the Pendle contract
    /// @param a the APWine contract
    constructor(
        address s,
        address p,
        address a
    ) {
        admin = msg.sender;
        swivelAddr = s;
        pendleAddr = p;
        apwineAddr = a;
        feenominator = 1000;
    }

    /// @notice approves the redeemer contract to spend the principal tokens held by the lender contract.
    /// @param u address of an underlying asset
    /// @param m maturity (timestamp) of the market
    /// @param r the address being approved, in this case the redeemer contract
    /// @return bool true if the approval was successful
    function approve(
        address u,
        uint256 m,
        address r
    ) external authorized(admin) returns (bool) {
        // approve the underlying for max per given principal
        for (uint8 i; i != 9; ) {
            // get the principal token's address
            address token = IMarketPlace(marketPlace).markets(u, m, i);
            // check that the token is defined for this particular market
            if (token != address(0)) {
                // max approve the token
                Safe.approve(IERC20(token), r, type(uint256).max);
            }
            unchecked {
                ++i;
            }
        }
        // approve the redeemer to receive underlying from the lender
        Safe.approve(IERC20(u), r, type(uint256).max);
        return true;
    }

    /// @notice bulk approves the usage of addresses at the given ERC20 addresses.
    /// @dev the lengths of the inputs must match because the arrays are paired by index
    /// @param u array of ERC20 token addresses that will be approved on
    /// @param a array of addresses that will be approved
    /// @return true if successful
    function approve(address[] calldata u, address[] calldata a)
        external
        authorized(admin)
        returns (bool)
    {
        for (uint256 i; i != u.length; ) {
            IERC20 uToken = IERC20(u[i]);
            if (address(0) != (address(uToken))) {
                Safe.approve(uToken, a[i], type(uint256).max);
            }
            unchecked {
                ++i;
            }
        }
        return true;
    }

    /// @notice approves market contracts that require lender approval
    /// @param u address of an underlying asset
    /// @param a APWine's router contract
    /// @param e Element's vault contract
    /// @param n Notional's token contract
    /// @param p Sense's periphery contract
    function approve(
        address u,
        address a,
        address e,
        address n,
        address p
    ) external authorized(marketPlace) {
        uint256 max = type(uint256).max;
        IERC20 uToken = IERC20(u);
        if (a != address(0)) {
            Safe.approve(uToken, a, max);
        }
        if (e != address(0)) {
            Safe.approve(uToken, e, max);
        }
        if (n != address(0)) {
            Safe.approve(uToken, n, max);
        }
        if (p != address(0)) {
            Safe.approve(uToken, p, max);
        }
        if (IERC20(u).allowance(address(this), swivelAddr) == 0) {
            Safe.approve(uToken, swivelAddr, max);
        }
    }

    /// @notice sets the admin address
    /// @param a address of a new admin
    /// @return bool true if successful
    function setAdmin(address a) external authorized(admin) returns (bool) {
        admin = a;
        emit SetAdmin(a);
        return true;
    }

    /// @notice sets the feenominator to the given value
    /// @param f the new value of the feenominator, fees are not collected when the feenominator is 0
    /// @return bool true if successful
    function setFee(uint256 f) external authorized(admin) returns (bool) {
        uint256 feeTime = feeChange;
        if (feeTime == 0) {
            revert Exception(23, 0, 0, address(0), address(0));
        } else if (block.timestamp < feeTime) {
            revert Exception(
                24,
                block.timestamp,
                feeTime,
                address(0),
                address(0)
            );
        } else if (f < MIN_FEENOMINATOR) {
            revert Exception(25, 0, 0, address(0), address(0));
        }
        feenominator = f;
        delete feeChange;
        emit SetFee(f);
        return true;
    }

    /// @notice sets the address of the marketplace contract which contains the addresses of all the fixed rate markets
    /// @param m the address of the marketplace contract
    /// @return bool true if the address was set
    function setMarketPlace(address m)
        external
        authorized(admin)
        returns (bool)
    {
        if (marketPlace != address(0)) {
            revert Exception(5, 0, 0, marketPlace, address(0));
        }
        marketPlace = m;
        return true;
    }

    /// @notice sets the ethereum price which is used in rate limiting
    /// @param p the new price
    /// @return bool true if the price was set
    function setEtherPrice(uint256 p)
        external
        authorized(admin)
        returns (bool)
    {
        etherPrice = p;
        return true;
    }

    /// @notice mint swaps the sender's principal tokens for Illuminate's ERC5095 tokens in effect, this opens a new fixed rate position for the sender on Illuminate
    /// @param p principal value according to the MarketPlace's Principals Enum
    /// @param u address of an underlying asset
    /// @param m maturity (timestamp) of the market
    /// @param a amount being minted
    /// @return bool true if the mint was successful
    function mint(
        uint8 p,
        address u,
        uint256 m,
        uint256 a
    ) external nonReentrant unpaused(u, m, p) returns (bool) {
        // Fetch the desired principal token
        address principal = IMarketPlace(marketPlace).markets(u, m, p);

        // Disallow mints if market is not initialized
        if (principal == address(0)) {
            revert Exception(26, 0, 0, address(0), address(0));
        }

        // Get the maturity of the principal token
        uint256 maturity;
        if (p == uint8(MarketPlace.Principals.Illuminate)) {
            revert Exception(32, 0, 0, address(0), address(0));
        } else if (p == uint8(MarketPlace.Principals.Swivel)) {
            maturity = Maturities.swivel(principal);
        } else if (p == uint8(MarketPlace.Principals.Yield)) {
            maturity = Maturities.yield(principal);
        } else if (p == uint8(MarketPlace.Principals.Element)) {
            maturity = Maturities.element(principal);
        } else if (p == uint8(MarketPlace.Principals.Pendle)) {
            maturity = Maturities.pendle(principal);
        } else if (p == uint8(MarketPlace.Principals.Tempus)) {
            maturity = Maturities.tempus(principal);
        } else if (p == uint8(MarketPlace.Principals.Apwine)) {
            maturity = Maturities.apwine(principal);
        } else if (p == uint8(MarketPlace.Principals.Notional)) {
            maturity = Maturities.notional(principal);
        }

        // Confirm that the principal token has not matured yet
        if (block.timestamp > maturity || maturity == 0) {
            revert Exception(
                7,
                maturity,
                block.timestamp,
                address(0),
                address(0)
            );
        }

        // Transfer the users principal tokens to the lender contract
        Safe.transferFrom(IERC20(principal), msg.sender, address(this), a);

        // Calculate how much should be minted based on the decimal difference
        uint256 mintable = convertDecimals(u, principal, a);

        // Confirm that minted iPT amount will not exceed rate limit for the protocol
        rateLimit(p, u, mintable);

        // Mint the tokens received from the user
        IERC5095(principalToken(u, m)).authMint(msg.sender, mintable);

        emit Mint(p, u, m, mintable);

        return true;
    }

    /// @notice lend method for the Illuminate and Yield protocols
    /// @param p principal value according to the MarketPlace's Principals Enum
    /// @param u address of an underlying asset
    /// @param m maturity (timestamp) of the market
    /// @param a amount of underlying tokens to lend
    /// @param y Yield Space Pool for the principal token
    /// @param minimum slippage limit, minimum amount to PTs to buy
    /// @return uint256 the amount of principal tokens lent out
    function lend(
        uint8 p,
        address u,
        uint256 m,
        uint256 a,
        address y,
        uint256 minimum
    ) external nonReentrant unpaused(u, m, p) matured(m) returns (uint256) {
        // Get principal token for this market
        address principal = IMarketPlace(marketPlace).markets(u, m, p);

        // Extract fee
        fees[u] = fees[u] + a / feenominator;

        // Transfer underlying from user to the lender contract
        Safe.transferFrom(IERC20(u), msg.sender, address(this), a);

        // Make sure the Yield Space Pool matches the market
        address fyToken = IYield(y).fyToken();
        if (IYield(y).fyToken() != principal) {
            revert Exception(12, 0, 0, fyToken, principal);
        }
        address base = address(IYield(y).base());
        if (base != u) {
            revert Exception(27, 0, 0, base, u);
        }

        // Set who should get the tokens that are swapped for
        address receiver = address(this);

        // If lending on Illuminate, swap directly to the caller
        if (p == uint8(MarketPlace.Principals.Illuminate)) {
            receiver = msg.sender;
        }

        // Swap underlying for PTs to lender
        uint256 returned = yield(
            u,
            y,
            a - a / feenominator,
            receiver,
            principal,
            minimum
        );

        // Convert decimals from principal token to underlying
        returned = convertDecimals(u, principal, returned);

        // Only mint iPTs to user if lending through Yield protocol
        if (p == uint8(MarketPlace.Principals.Yield)) {
            // Confirm that minted iPT amount will not exceed rate limit for the protocol
            rateLimit(p, u, returned);

            // Mint Illuminate PTs to msg.sender
            IERC5095(principalToken(u, m)).authMint(msg.sender, returned);
        }

        emit Lend(p, u, m, returned, a, msg.sender);

        return returned;
    }

    /// @notice lend method signature for Swivel
    /// @param p principal value according to the MarketPlace's Principals Enum
    /// @param u address of an underlying asset
    /// @param m maturity (timestamp) of the market
    /// @param a array of amounts of underlying tokens lent to each order in the orders array
    /// @param y Yield Space Pool for the Illuminate PT in this market
    /// @param o array of Swivel orders being filled
    /// @param s array of signatures for each order in the orders array
    /// @param e flag to indicate if returned funds should be swapped in Yield Space Pool
    /// @param premiumSlippage slippage limit, minimum amount to PTs to buy
    /// @return uint256 the amount of principal tokens lent out
    function lend(
        uint8 p,
        address u,
        uint256 m,
        uint256[] memory a,
        address y,
        Swivel.Order[] calldata o,
        Swivel.Components[] calldata s,
        bool e,
        uint256 premiumSlippage
    ) external nonReentrant unpaused(u, m, p) matured(m) returns (uint256) {
        // Ensure all the orders are for the underlying asset
        swivelVerify(o, u);

        // Lent represents the total amount of underlying to be lent
        uint256 lent = swivelAmount(a);

        // Get the underlying balance prior to calling initiate
        uint256 starting = IERC20(u).balanceOf(address(this));

        // Transfer underlying token from user to Illuminate
        Safe.transferFrom(IERC20(u), msg.sender, address(this), lent);

        // Calculate fee for the total amount to be lent
        uint256 fee = lent / feenominator;

        {
            // Get last order to be processed's index
            uint256 lastIndex = a.length - 1;

            // Add the accumulated fees to the total
            a[lastIndex] = a[lastIndex] - fee; // Revert here if fee not paid

            // Extract fee
            fees[u] += fee;
        }

        uint256 received;
        {
            // Get the starting amount of principal tokens
            uint256 startingZcTokens = IERC20(
                IMarketPlace(marketPlace).markets(u, m, p)
            ).balanceOf(address(this));

            // Fill the given orders on Swivel
            ISwivel(swivelAddr).initiate(o, a, s);

            // Compute how many principal tokens were received
            received = (IERC20(IMarketPlace(marketPlace).markets(u, m, p))
                .balanceOf(address(this)) - startingZcTokens);

            // Calculate the premium
            uint256 premium = (IERC20(u).balanceOf(address(this)) - starting) -
                fee;

            // Calculate the fee on the premium
            uint256 premiumFee = premium / feenominator;

            // Extract fee from premium
            fees[u] += premiumFee;

            // Remove the fee from the premium
            premium = premium - premiumFee;

            // Store how much the user received in exchange for swapping the premium for iPTs
            uint256 swapped;

            if (e) {
                // Swap the premium for Illuminate principal tokens
                swapped += yield(
                    u,
                    y,
                    premium,
                    msg.sender,
                    IMarketPlace(marketPlace).markets(u, m, 0),
                    premiumSlippage
                );
            } else {
                // Send the premium to the redeemer to hold until redemption
                premiums[u][m] = premiums[u][m] + premium;

                // Account for the premium
                received = received + premium;
            }

            // Mint Illuminate principal tokens to the user
            IERC5095(principalToken(u, m)).authMint(msg.sender, received);

            emit Lend(
                uint8(MarketPlace.Principals.Swivel),
                u,
                m,
                received + swapped,
                lent,
                msg.sender
            );
        }

        // Confirm that minted iPT amount will not exceed rate limit for the protocol
        rateLimit(p, u, received);
        return received;
    }

    /// @notice lend method signature for Element
    /// @param p principal value according to the MarketPlace's Principals Enum
    /// @param u address of an underlying asset
    /// @param m maturity (timestamp) of the market
    /// @param a amount of underlying tokens to lend
    /// @param r slippage limit, minimum amount to PTs to buy
    /// @param d deadline is a timestamp by which the swap must be executed
    /// @param e Element pool that is lent to
    /// @param i the id of the pool
    /// @return uint256 the amount of principal tokens lent out
    function lend(
        uint8 p,
        address u,
        uint256 m,
        uint256 a,
        uint256 r,
        uint256 d,
        address e,
        bytes32 i
    ) external nonReentrant unpaused(u, m, p) matured(m) returns (uint256) {
        // Get the principal token for this market for Element
        address principal = IMarketPlace(marketPlace).markets(u, m, p);

        // Transfer underlying token from user to Illuminate
        Safe.transferFrom(IERC20(u), msg.sender, address(this), a);

        // Track the accumulated fees
        fees[u] = fees[u] + a / feenominator;

        uint256 purchased;
        {
            // Calculate the amount to be lent
            uint256 lent = a - a / feenominator;

            // Create the variables needed to execute an Element swap
            Element.FundManagement memory fund = Element.FundManagement({
                sender: address(this),
                recipient: payable(address(this)),
                fromInternalBalance: false,
                toInternalBalance: false
            });

            Element.SingleSwap memory swap = Element.SingleSwap({
                poolId: i,
                amount: lent,
                kind: Element.SwapKind.GIVEN_IN,
                assetIn: IAny(u),
                assetOut: IAny(principal),
                userData: '0x00000000000000000000000000000000000000000000000000000000000000'
            });

            // Conduct the swap on Element
            purchased = elementSwap(e, swap, fund, r, d);

            // Convert decimals from principal token to underlying
            purchased = convertDecimals(u, principal, purchased);
        }

        // Confirm that minted iPT amount will not exceed rate limit for the protocol
        rateLimit(p, u, purchased);

        // Mint tokens to the user
        IERC5095(principalToken(u, m)).authMint(msg.sender, purchased);

        emit Lend(p, u, m, purchased, a, msg.sender);
        return purchased;
    }

    /// @notice lend method signature for Pendle
    /// @param p principal value according to the MarketPlace's Principals Enum
    /// @param u address of an underlying asset
    /// @param m maturity (timestamp) of the market
    /// @param a amount of underlying tokens to lend
    /// @param r slippage limit, minimum amount to PTs to buy
    /// @param g guess parameters for the swap
    /// @param market contract that corresponds to the market for the PT
    /// @return uint256 the amount of principal tokens lent out
    function lend(
        uint8 p,
        address u,
        uint256 m,
        uint256 a,
        uint256 r,
        Pendle.ApproxParams calldata g,
        address market
    ) external nonReentrant unpaused(u, m, p) matured(m) returns (uint256) {
        // Instantiate market and tokens
        address principal = IMarketPlace(marketPlace).markets(u, m, p);

        // Confirm the market corresponds to this Illuminate market
        (, address marketPrincipal, ) = IPendleMarket(market).readTokens();
        if (marketPrincipal != principal) {
            revert Exception(27, 0, 0, market, principal);
        }

        // Transfer funds from user to Illuminate
        Safe.transferFrom(IERC20(u), msg.sender, address(this), a);

        uint256 returned;
        {
            // Add the accumulated fees to the total
            uint256 fee = a / feenominator;
            fees[u] = fees[u] + fee;

            // Setup the token input
            Pendle.TokenInput memory input = Pendle.TokenInput(
                u,
                a - fee,
                u,
                address(0),
                address(0),
                '0x00000000000000000000000000000000000000000000000000000000000000'
            );

            // Swap on the Pendle Router using the provided market and params
            (returned, ) = IPendle(pendleAddr).swapExactTokenForPt(
                address(this),
                market,
                r,
                g,
                input
            );

            // Convert decimals from principal token to underlying
            returned = convertDecimals(u, principal, returned);
        }

        // Confirm that minted iPT amount will not exceed rate limit for the protocol
        rateLimit(p, u, returned);

        // Mint Illuminate zero coupons
        IERC5095(principalToken(u, m)).authMint(msg.sender, returned);

        emit Lend(p, u, m, returned, a, msg.sender);
        return returned;
    }

    /// @notice lend method signature for Tempus and APWine
    /// @param p value of a specific principal according to the Illuminate Principals Enum
    /// @param u address of an underlying asset
    /// @param m maturity (timestamp) of the market
    /// @param a amount of principal tokens to lend
    /// @param r minimum amount to return when executing the swap (sets a limit to slippage)
    /// @param d deadline is a timestamp by which the swap must be executed
    /// @param x Tempus or APWine AMM that executes the swap
    /// @return uint256 the amount of principal tokens lent out
    function lend(
        uint8 p,
        address u,
        uint256 m,
        uint256 a,
        uint256 r,
        uint256 d,
        address x
    ) external nonReentrant unpaused(u, m, p) matured(m) returns (uint256) {
        address principal = IMarketPlace(marketPlace).markets(u, m, p);

        // Transfer funds from user to Illuminate
        Safe.transferFrom(IERC20(u), msg.sender, address(this), a);

        uint256 lent;
        {
            // Add the accumulated fees to the total
            uint256 fee = a / feenominator;
            fees[u] = fees[u] + fee;

            // Calculate amount to be lent out
            lent = a - fee;
        }

        // Get the starting balance of the principal token
        uint256 start = IERC20(principal).balanceOf(address(this));

        if (p == uint8(MarketPlace.Principals.Tempus)) {
            // Get the Tempus pool from the principal token
            ITempusPool pool = ITempusPool(ITempusToken(principal).pool());

            // Get the pool of the contract the user submitted
            address userPool = ITempusAMM(x).tempusPool();

            // Confirm that the pool matches the principal token
            if (address(pool) != userPool) {
                revert Exception(27, 0, 0, address(pool), userPool);
            }

            // Get the Tempus router from the principal token
            address controller = pool.controller();

            // Swap on the Tempus router using the provided market and params
            ITempus(controller).depositAndFix(x, lent, true, 0, d);
        } else if (p == uint8(MarketPlace.Principals.Apwine)) {
            address poolUnderlying = IAPWineAMMPool(x)
                .getUnderlyingOfIBTAddress();
            if (u != poolUnderlying) {
                revert Exception(27, 0, 0, u, poolUnderlying);
            }
            address poolPrincipal = IAPWineAMMPool(x).getPTAddress();
            if (principal != poolPrincipal) {
                revert Exception(27, 0, 0, principal, poolPrincipal);
            }
            // Swap on the APWine Pool using the provided market and params
            IAPWineRouter(apwineAddr).swapExactAmountIn(
                x,
                apwinePairPath(),
                apwineTokenPath(),
                lent,
                r,
                address(this),
                d,
                address(0)
            );
        }

        // Calculate the amount of Tempus principal tokens received after the deposit
        uint256 received = IERC20(principal).balanceOf(address(this)) - start;

        // Convert decimals from principal token to underlying
        received = convertDecimals(u, principal, received);

        // Verify that a minimum number of principal tokens were received
        if (p == uint8(MarketPlace.Principals.Tempus) && received < r) {
            revert Exception(11, received, r, address(0), address(0));
        }

        // Confirm that minted iPT amount will not exceed rate limit for the protocol
        rateLimit(p, u, received);

        // Mint Illuminate zero coupons
        IERC5095(principalToken(u, m)).authMint(msg.sender, received);

        emit Lend(p, u, m, received, a, msg.sender);
        return received;
    }

    /// @notice lend method signature for Sense
    /// @dev this method can be called before maturity to lend to Sense while minting Illuminate tokens
    /// @dev Sense provides a [divider] contract that splits [target] assets (underlying) into PTs and YTs. Each [target] asset has a [series] of contracts, each identifiable by their [maturity].
    /// @param p principal value according to the MarketPlace's Principals Enum
    /// @param u address of an underlying asset
    /// @param m maturity (timestamp) of the market
    /// @param a amount of underlying tokens to lend
    /// @param r slippage limit, minimum amount to PTs to buy
    /// @param x periphery contract that is used to conduct the swap
    /// @param s Sense's maturity for the given market
    /// @param adapter Sense's adapter necessary to facilitate the swap
    /// @return uint256 the amount of principal tokens lent out
    function lend(
        uint8 p,
        address u,
        uint256 m,
        uint128 a,
        uint256 r,
        address x,
        uint256 s,
        address adapter
    ) external nonReentrant unpaused(u, m, p) matured(m) returns (uint256) {
        // Get the periphery's divider contract to verify that it maps to the prinicpal token of the market
        address divider = ISensePeriphery(x).divider();

        // Get the principal token for the user submitted periphery
        address userPrincipal = ISenseDivider(divider).pt(adapter, s);

        // Retrieve the principal token for this market
        IERC20 token = IERC20(IMarketPlace(marketPlace).markets(u, m, p));

        // Verify that the `x` parameter matches the market's Sense principal token
        if (address(token) != userPrincipal) {
            revert Exception(27, 0, 0, address(token), userPrincipal);
        }

        // Transfer funds from user to Illuminate
        Safe.transferFrom(IERC20(u), msg.sender, address(this), a);

        // Determine the fee
        uint256 fee = a / feenominator;

        // Add the accumulated fees to the total
        fees[u] = fees[u] + fee;

        // Determine lent amount after fees
        uint256 lent = a - fee;

        // Stores the amount of principal tokens received in swap for underlying
        uint256 received;
        {
            // Get the starting balance of the principal token
            uint256 starting = token.balanceOf(address(this));

            // Swap those tokens for the principal tokens
            ISensePeriphery(x).swapUnderlyingForPTs(adapter, s, lent, r);

            // Calculate number of principal tokens received in the swap
            received = token.balanceOf(address(this)) - starting;

            // Verify that we received the principal tokens
            if (received < r) {
                revert Exception(11, 0, 0, address(0), address(0));
            }
        }

        // Get the Illuminate PT
        address ipt = principalToken(u, m);

        // Calculate the mintable amount of tokens for Sense due to decimal mismatch
        uint256 mintable = convertDecimals(u, address(token), received);

        // Confirm that minted iPT amount will not exceed rate limit for the protocol
        rateLimit(p, u, mintable);

        // Mint the Illuminate tokens based on the returned amount
        IERC5095(ipt).authMint(msg.sender, mintable);

        emit Lend(p, u, m, mintable, a, msg.sender);
        return mintable;
    }

    /// @dev lend method signature for Notional
    /// @param p principal value according to the MarketPlace's Principals Enum
    /// @param u address of an underlying asset
    /// @param m maturity (timestamp) of the market
    /// @param a amount of underlying tokens to lend
    /// @param r slippage limit, minimum amount to PTs to buy
    /// @return uint256 the amount of principal tokens lent out
    function lend(
        uint8 p,
        address u,
        uint256 m,
        uint256 a,
        uint256 r
    ) external nonReentrant unpaused(u, m, p) matured(m) returns (uint256) {
        // Confirm that we are using Notional's PT to avoid conflicts with other ERC4626 tokens
        if (p != uint8(MarketPlace.Principals.Notional)) {
            revert Exception(6, p, 0, address(0), address(0));
        }

        // Instantiate Notional princpal token
        address token = IMarketPlace(marketPlace).markets(u, m, p);

        // Transfer funds from user to Illuminate
        Safe.transferFrom(IERC20(u), msg.sender, address(this), a);

        // Determine the fee
        uint256 fee = a / feenominator;

        // Add the accumulated fees to the total
        fees[u] = fees[u] + fee;

        // Swap on the Notional Token wrapper
        uint256 received = INotional(token).deposit(a - fee, address(this));

        // Convert decimals from principal token to underlying
        received = convertDecimals(u, token, received);

        // Verify that we received the principal tokens
        if (received < r) {
            revert Exception(16, received, r, address(0), address(0));
        }

        // Confirm that minted iPT amount will not exceed rate limit for the protocol
        rateLimit(p, u, received);

        // Mint Illuminate zero coupons
        IERC5095(principalToken(u, m)).authMint(msg.sender, received);

        emit Lend(p, u, m, received, a, msg.sender);
        return received;
    }

    /// @notice allows the admin to schedule the withdrawal of tokens
    /// @param e address of (erc20) token to withdraw
    /// @return bool true if successful
    function scheduleWithdrawal(address e)
        external
        authorized(admin)
        returns (bool)
    {
        // Calculate the timestamp that must be passed prior to withdrawal
        uint256 when = block.timestamp + HOLD;

        // Set the timestamp threshold for the token being withdrawn
        withdrawals[e] = when;

        emit ScheduleWithdrawal(e, when);
        return true;
    }

    /// @notice emergency function to block unplanned withdrawals
    /// @param e address of token withdrawal to block
    /// @return bool true if successful
    function blockWithdrawal(address e)
        external
        authorized(admin)
        returns (bool)
    {
        // Resets threshold to 0 for the token, stopping withdrawl of the token
        delete withdrawals[e];

        emit BlockWithdrawal(e);
        return true;
    }

    /// @notice allows the admin to schedule a change to the fee denominators
    function scheduleFeeChange() external authorized(admin) returns (bool) {
        // Calculate the timestamp that must be passed prior to setting thew new fee
        uint256 when = block.timestamp + HOLD;

        // Store the timestamp that must be passed to update the fee rate
        feeChange = when;

        emit ScheduleFeeChange(when);
        return true;
    }

    /// @notice Emergency function to block unplanned changes to fee structure
    function blockFeeChange() external authorized(admin) returns (bool) {
        // Resets threshold to 0 for the token, stopping the scheduling of a fee rate change
        delete feeChange;

        emit BlockFeeChange();
        return true;
    }

    /// @notice allows the admin to withdraw the given token, provided the holding period has been observed
    /// @param e Address of token to withdraw
    /// @return bool true if successful
    function withdraw(address e) external authorized(admin) returns (bool) {
        // Get the minimum timestamp to withdraw the token
        uint256 when = withdrawals[e];

        // Check that the withdrawal was scheduled for the token
        if (when == 0) {
            revert Exception(18, 0, 0, address(0), address(0));
        }

        // Check that it is now past the scheduled timestamp for withdrawing the token
        if (block.timestamp < when) {
            revert Exception(19, 0, 0, address(0), address(0));
        }

        // Reset the scheduled withdrawal
        delete withdrawals[e];

        // Reset the fees for the token (relevant when withdrawing underlying for markets)
        delete fees[e];

        // Send the token to the admin
        IERC20 token = IERC20(e);
        Safe.transfer(token, admin, token.balanceOf(address(this)));

        return true;
    }

    /// @notice withdraws accumulated lending fees of the underlying token
    /// @param e address of the underlying token to withdraw
    /// @return bool true if successful
    function withdrawFee(address e) external authorized(admin) returns (bool) {
        // Get the token to be withdrawn
        IERC20 token = IERC20(e);

        // Get the balance to be transferred
        uint256 balance = fees[e];

        // Reset accumulated fees of the token to 0
        fees[e] = 0;

        // Transfer the accumulated fees to the admin
        Safe.transfer(token, admin, balance);

        return true;
    }

    /// @notice pauses a market and prevents execution of all lending for that principal
    /// @param p principal value according to the MarketPlace's Principals Enum
    /// @param b bool representing whether to pause or unpause
    /// @return bool true if successful
    function pause(uint8 p, bool b) external authorized(admin) returns (bool) {
        // Set the paused state for the principal token in the market
        paused[p] = b;

        emit PausePrincipal(p, b);
        return true;
    }

    /// @notice pauses Illuminate's redeem, mint and lend methods from being used
    /// @param b bool representing whether to pause or unpause Illuminate
    /// @return bool true if successfully set
    function pauseIlluminate(bool b) external authorized(admin) returns (bool) {
        halted = b;
        emit PauseIlluminate(b);
        return true;
    }

    /// @notice Tranfers FYTs to Redeemer (used specifically for APWine redemptions)
    /// @param f FYT contract address
    /// @param a amount of tokens to send to the redeemer
    function transferFYTs(address f, uint256 a)
        external
        authorized(IMarketPlace(marketPlace).redeemer())
    {
        // Transfer the Lender's FYT tokens to the Redeemer
        Safe.transfer(IERC20(f), IMarketPlace(marketPlace).redeemer(), a);
    }

    /// @notice Transfers premium from the market to Redeemer (used specifically for Swivel redemptions)
    /// @param u address of an underlying asset
    /// @param m maturity (timestamp) of the market
    function transferPremium(address u, uint256 m)
        external
        authorized(IMarketPlace(marketPlace).redeemer())
    {
        Safe.transfer(
            IERC20(u),
            IMarketPlace(marketPlace).redeemer(),
            premiums[u][m]
        );

        premiums[u][m] = 0;
    }

    /// @notice Allows batched call to self (this contract).
    /// @param c An array of inputs for each call.
    function batch(bytes[] calldata c)
        external
        payable
        returns (bytes[] memory results)
    {
        results = new bytes[](c.length);

        for (uint256 i; i < c.length; i++) {
            (bool success, bytes memory result) = address(this).delegatecall(
                c[i]
            );

            if (!success) revert(RevertMsgExtractor.getRevertMsg(result));
            results[i] = result;
        }
    }

    /// @notice swaps underlying premium via a Yield Space Pool
    /// @dev this method is only used by the Yield, Illuminate and Swivel protocols
    /// @param u address of an underlying asset
    /// @param y Yield Space Pool for the principal token
    /// @param a amount of underlying tokens to lend
    /// @param r the receiving address for PTs
    /// @param p the principal token in the Yield Space Pool
    /// @param m the minimum amount to purchase
    /// @return uint256 the amount of tokens sent to the Yield Space Pool
    function yield(
        address u,
        address y,
        uint256 a,
        address r,
        address p,
        uint256 m
    ) internal returns (uint256) {
        // Get the starting balance (to verify receipt of tokens)
        uint256 starting = IERC20(p).balanceOf(r);

        // Get the amount of tokens received for swapping underlying
        uint128 returned = IYield(y).sellBasePreview(Cast.u128(a));

        // Send the remaining amount to the Yield pool
        Safe.transfer(IERC20(u), y, a);

        // Lend out the remaining tokens in the Yield pool
        IYield(y).sellBase(r, returned);

        // Get the ending balance of principal tokens (must be at least starting + returned)
        uint256 received = IERC20(p).balanceOf(r) - starting;

        // Verify receipt of PTs from Yield Space Pool
        if (received < m) {
            revert Exception(11, received, m, address(0), address(0));
        }

        return received;
    }

    /// @notice returns the amount of underlying tokens to be used in a Swivel lend
    function swivelAmount(uint256[] memory a) internal pure returns (uint256) {
        uint256 lent;

        // Iterate through each order a calculate the total lent and returned
        for (uint256 i; i != a.length; ) {
            {
                // Sum the total amount lent to Swivel
                lent = lent + a[i];
            }

            unchecked {
                ++i;
            }
        }

        return lent;
    }

    /// @notice reverts if any orders are not for the market
    function swivelVerify(Swivel.Order[] memory o, address u) internal pure {
        for (uint256 i; i != o.length; ) {
            address orderUnderlying = o[i].underlying;
            if (u != orderUnderlying) {
                revert Exception(3, 0, 0, u, orderUnderlying);
            }
            unchecked {
                ++i;
            }
        }
    }

    /// @notice executes a swap for and verifies receipt of Element PTs
    function elementSwap(
        address e,
        Element.SingleSwap memory s,
        Element.FundManagement memory f,
        uint256 r,
        uint256 d
    ) internal returns (uint256) {
        // Get the principal token
        address principal = address(s.assetOut);

        // Get the intial balance
        uint256 starting = IERC20(principal).balanceOf(address(this));

        // Conduct the swap on Element
        IElementVault(e).swap(s, f, r, d);

        // Get how many PTs were purchased by the swap call
        uint256 purchased = IERC20(principal).balanceOf(address(this)) -
            starting;

        // Verify that a minimum amount was received
        if (purchased < r) {
            revert Exception(11, 0, 0, address(0), address(0));
        }

        // Return the net amount of principal tokens acquired after the swap
        return purchased;
    }

    /// @notice returns array token path required for APWine's swap method
    /// @return array of uint256[] as laid out in APWine's docs
    function apwineTokenPath() internal pure returns (uint256[] memory) {
        uint256[] memory tokenPath = new uint256[](2);
        tokenPath[0] = 1;
        tokenPath[1] = 0;
        return tokenPath;
    }

    /// @notice returns array pair path required for APWine's swap method
    /// @return array of uint256[] as laid out in APWine's docs
    function apwinePairPath() internal pure returns (uint256[] memory) {
        uint256[] memory pairPath = new uint256[](1);
        pairPath[0] = 0;
        return pairPath;
    }

    /// @notice retrieves the ERC5095 token for the given market
    /// @param u address of an underlying asset
    /// @param m maturity (timestamp) of the market
    /// @return address of the ERC5095 token for the market
    function principalToken(address u, uint256 m) internal returns (address) {
        return IMarketPlace(marketPlace).markets(u, m, 0);
    }

    /// @notice converts principal decimal amount to underlying's decimal amount
    /// @param u address of an underlying asset
    /// @param p address of a principal token
    /// @param a amount denominated in principal token's decimals
    /// @return uint256 in underlying decimals
    function convertDecimals(
        address u,
        address p,
        uint256 a
    ) internal view returns (uint256) {
        // Get the decimals of the underlying asset
        uint8 underlyingDecimals = IERC20(u).decimals();

        // Get the decimals of the principal token
        uint8 principalDecimals = IERC20(p).decimals();

        // Determine which asset has more decimals
        if (underlyingDecimals > principalDecimals) {
            // Shift decimals accordingly
            return a * 10**(underlyingDecimals - principalDecimals);
        }
        return a / 10**(principalDecimals - underlyingDecimals);
    }

    /// @notice limits the amount of funds (in USD value) that can flow through a principal in a day
    /// @param p principal value according to the MarketPlace's Principals Enum
    /// @param u address of an underlying asset
    /// @param a amount being minted which is normalized to 18 decimals prior to check
    /// @return bool true if successful, reverts otherwise
    function rateLimit(
        uint8 p,
        address u,
        uint256 a
    ) internal returns (bool) {
        // Get amount in USD to be minted
        uint256 valueToMint = a;

        // In case of stETH, we will calculate an approximate USD value
        // 0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84 (stETH address)
        if (u == 0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84) {
            valueToMint = etherPrice * valueToMint;
        }

        // Normalize the value to be minted to 27 decimals
        valueToMint = valueToMint * 10**(27 - IERC20(u).decimals());

        // Cache max value
        uint256 maxValue = MAX_VALUE;

        // Transactions of greater than ~2M USD are rate limited
        if (valueToMint > maxValue) {
            revert Exception(31, protocolFlow[p], p, address(0), address(0));
        }

        // Cache protocol flow value
        uint256 flow = protocolFlow[p] + valueToMint;

        // Update the amount of USD value flowing through the protocol
        protocolFlow[p] = flow;

        // If more than one day has passed, do not rate limit
        if (block.timestamp - periodStart[p] > 1 days) {
            // Reset the flow amount
            protocolFlow[p] = valueToMint;

            // Reset the period
            periodStart[p] = block.timestamp;
        }
        // If more than 2M USD has flowed through the protocol, revert
        else if (flow > maxValue) {
            revert Exception(31, protocolFlow[p], p, address(0), address(0));
        }

        return true;
    }
}
