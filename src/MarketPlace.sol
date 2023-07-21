// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.20;

import 'src/tokens/ERC5095.sol';
import 'src/lib/Safe.sol';
import 'src/lib/RevertMsgExtractor.sol';
import 'src/errors/Exception.sol';

import 'src/interfaces/ICreator.sol';
import 'src/interfaces/IPool.sol';

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

    /// @notice markets are defined by a maturity and underlying tuple that points to an array of principal token addresses.
    mapping(address => mapping(uint256 => address[])) public markets;

    /// @notice adapters are defined by a maturity and underlying tuple that points to an array of adapter contracts
    mapping(address => mapping(uint256 => address[])) public adapters;

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
        address[] tokens,
        address[] adapters
    );
    /// @notice emitted upon setting a principal token
    event SetPrincipal(
        address indexed underlying,
        uint256 indexed maturity,
        address indexed principal,
        address adapter,
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
    constructor(address r, address l, address c) {
        admin = msg.sender;
        redeemer = r;
        lender = l;
        creator = c;
    }

    /// @notice creates a new market for the given underlying token and maturity
    /// @param u address of an underlying asset
    /// @param m maturity (timestamp) of the market
    /// @param t principal token addresses for this market
    /// @param a adapter addresses for this market
    /// @param n name for the Illuminate token
    /// @param s symbol for the Illuminate token
    /// @return bool true if successful
    function createMarket(
        address u,
        uint256 m,
        address[] calldata t,
        address[] calldata a,
        string calldata n,
        string calldata s
    ) external authorized(admin) returns (bool) {
        // Create an Illuminate principal token for the new market
        markets[u][m][0] = ICreator(creator).create(
            u,
            m,
            redeemer,
            lender,
            address(this),
            n,
            s
        );

        {
            // assign values for the principal tokens and adapters array
            for (uint i = 0; i < t.length; i++) {
                markets[u][m][i + 1] = t[i];
                adapters[u][m][i + 1] = a[i];
            }
        }

        {
            address underlying = u;
            uint256 maturity = m;
            emit CreateMarket(
                underlying,
                maturity,
                markets[underlying][maturity],
                adapters[underlying][maturity]
            );
        }
        return true;
    }

    /// @notice allows the admin to set an individual market
    /// @param p principal value according to the MarketPlace's Principals Enum
    /// @param u address of an underlying asset
    /// @param m maturity (timestamp) of the market
    /// @param a address of the new principal token
    /// @param adapter address of the protocol's adapter contract
    /// @return bool true if the principal set, false otherwise
    function setPrincipal(
        uint8 p,
        address u,
        uint256 m,
        address a,
        address adapter
    ) external authorized(admin) returns (bool) {
        // Set the principal token in the markets mapping
        markets[u][m][p] = a;

        // Set the adapter contract in the adapters mapping
        adapters[u][m][p] = adapter;

        emit SetPrincipal(u, m, a, adapter, p);
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
        uint128 received = pool.sellFYToken(msg.sender, s);
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
        uint128 spent = pool.buyFYToken(msg.sender, a, s);

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
        uint128 received = pool.sellBase(msg.sender, s);

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
        uint128 spent = pool.buyBase(msg.sender, a, s);

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
    ) external returns (uint256, uint256, uint256) {
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
    ) external returns (uint256, uint256, uint256) {
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
    ) external returns (uint256, uint256, uint256) {
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
    function batch(
        bytes[] calldata c
    ) external payable returns (bytes[] memory results) {
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