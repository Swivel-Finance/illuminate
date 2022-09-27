// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.16;

import 'src/tokens/ERC5095.sol';
import 'src/lib/Safe.sol';

import 'src/interfaces/ILender.sol';
import 'src/interfaces/IPool.sol';

import 'src/errors/Exception.sol';

/// @title MarketPlace
/// @author Sourabh Marathe, Julian Traversa, Rob Robbins
/// @notice This contract is in charge of managing the available principals for each loan market.
/// @notice In addition, this contract routes swap orders between metaprincipal tokens and their respective underlying to YieldSpace pools.
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
    /// @notice The principal tokens whose addresses correspond to their Principals enum value, thus the array should be ordered in that way
    mapping(address => mapping(uint256 => address[9])) public markets;

    /// @notice pools map markets to their respective YieldSpace pools for the MetaPrincipal token
    mapping(address => mapping(uint256 => address)) public pools;

    /// @notice address that is allowed to create markets, set fees, etc. It is commonly used in the authorized modifier.
    address public admin;
    /// @notice address of the deployed redeemer contract
    address public immutable redeemer;
    /// @notice address of the deployed lender contract
    address public immutable lender;

    /// @notice emitted upon the creation of a new market
    event CreateMarket(
        address indexed underlying,
        uint256 indexed maturity,
        address[9] tokens
    );
    /// @notice emitted upon change of principal token
    event SetPrincipal(
        address indexed underlying,
        uint256 indexed maturity,
        address indexed principal
    );
    /// @notice emitted on change of admin
    event SetAdmin(address indexed admin);
    /// @notice emitted on change of pool
    event SetPool(address indexed pool);

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
    constructor(address r, address l) {
        admin = msg.sender;
        redeemer = r;
        lender = l;
    }

    /// @notice creates a new market for the given underlying token and maturity
    /// @param u address of an underlying asset
    /// @param m maturity (timestamp) of the market
    /// @param t principal token addresses for this market minus the illuminate principal
    /// @param n name for the illuminate token
    /// @param s symbol for the illuminate token
    /// @param d decimals for the illuminate token
    /// @param e address of the element vault that corresponds to this market
    /// @param a address of the apwine router that corresponds to this market
    /// @return bool true if successful
    function createMarket(
        address u,
        uint256 m,
        address[8] calldata t,
        string calldata n,
        string calldata s,
        uint8 d,
        address e,
        address a
    ) external authorized(admin) returns (bool) {
        {
            address illuminate = markets[u][m][
                (uint256(Principals.Illuminate))
            ];
            if (illuminate != address(0)) {
                revert Exception(9, 0, 0, illuminate, address(0));
            }
        }

        address illuminateToken;
        {
            illuminateToken = address(
                new ERC5095(u, m, redeemer, lender, address(this), n, s, d)
            );
        }

        {
            // the market will have the illuminate principal as its zeroth item,
            // thus t should have Principals[1] as [0]
            address[9] memory market = [
                illuminateToken, // illuminate
                t[0], // swivel
                t[1], // yield
                t[2], // element
                t[3], // pendle
                t[4], // tempus
                t[5], // sense
                t[6], // apwine
                t[7] // notional
            ];

            // necessary to get around stack too deep
            address underlying = u;
            uint256 maturity = m;

            // set the market
            markets[underlying][maturity] = market;
        }

        // todo also call the next two in the setPrincipal call?
        // Max approve lender spending on the element and apwine contracts
        ILender(lender).approve(u, e, a, t[7]);

        // Max approve converters's ability to convert redeemer's pendle PTs
        IRedeemer(redeemer).approve(t[3]);

        {
            address[9] memory tokens = markets[u][m];
            emit CreateMarket(u, m, tokens);
        }
        return true;
    }

    /// @notice allows the admin to set an individual market
    /// @param p enum value of the principal token
    /// @param u underlying token address
    /// @param m maturity timestamp for the market
    /// @param a address of the new principal token
    /// @return bool true if the principal set, false otherwise
    function setPrincipal(
        uint8 p,
        address u,
        uint256 m,
        address a
    ) external authorized(admin) returns (bool) {
        address market = markets[u][m][p];
        if (market != address(0)) {
            revert Exception(9, 0, 0, market, address(0));
        }
        markets[u][m][p] = a;

        // todo: should we handle special protocol based approvals here?

        emit SetPrincipal(u, m, a);
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
    /// @param u address of the underlying asset
    /// @param m maturity (timestamp) of the market
    /// @param a address of the pool
    /// @return bool true if the pool set, false otherwise
    function setPool(
        address u,
        uint256 m,
        address a
    ) external authorized(admin) returns (bool) {
        address pool = pools[u][m];
        if (pool != address(0)) {
            revert Exception(10, 0, 0, pool, address(0));
        }
        pools[u][m] = a;
        emit SetPool(a);
        return true;
    }

    /// @notice sells the PT for the PT via the pool
    /// @param u address of the underlying asset
    /// @param m maturity (timestamp) of the market
    /// @param a amount of PT to swap
    /// @param s slippage cap, minimum number of tokens that must be received
    /// @return uint128 amount of underlying bought
    function sellPrincipalToken(
        address u,
        uint256 m,
        uint128 a,
        uint128 s
    ) external returns (uint128) {
        IPool pool = IPool(pools[u][m]);
        Safe.transferFrom(
            IERC20(address(pool.fyToken())),
            msg.sender,
            address(pool),
            a
        );
        uint128 preview = pool.sellFYTokenPreview(a);
        if (preview < s) {
            revert Exception(16, preview, 0, address(0), address(0));
        }

        return pool.sellFYToken(msg.sender, preview);
    }

    /// @notice buys the PUT for the underlying via the pool
    /// @param u address of the underlying asset
    /// @param m maturity (timestamp) of the market
    /// @param a amount of underlying tokens to sell
    /// @param s slippage cap, minimum number to tokens to receive after swap
    /// @return uint128 amount of underlying sold
    function buyPrincipalToken(
        address u,
        uint256 m,
        uint128 a,
        uint128 s
    ) external returns (uint128) {
        IPool pool = IPool(pools[u][m]);
        Safe.transferFrom(IERC20(pool.base()), msg.sender, address(pool), a);
        uint128 preview = pool.buyFYTokenPreview(a);
        if (preview < s) {
            revert Exception(16, preview, 0, address(0), address(0));
        }
        return pool.buyFYToken(msg.sender, preview, 0);
    }

    /// @notice sells the underlying for the PT via the pool
    /// @param u address of the underlying asset
    /// @param m maturity (timestamp) of the market
    /// @param a amount of underlying to swap
    /// @param s slippage cap, minimum number of tokens that must be received
    /// @return uint128 amount of PT purchased
    function sellUnderlying(
        address u,
        uint256 m,
        uint128 a,
        uint128 s
    ) external returns (uint128) {
        IPool pool = IPool(pools[u][m]);
        Safe.transferFrom(IERC20(pool.base()), msg.sender, address(pool), a);
        uint128 preview = pool.sellBasePreview(a);
        if (preview < s) {
            revert Exception(16, preview, 0, address(0), address(0));
        }
        return pool.sellBase(msg.sender, preview);
    }

    /// @notice buys the underlying for the PT via the pool
    /// @param u address of the underlying asset
    /// @param m maturity (timestamp) of the market
    /// @param a amount of PT to swap
    /// @param s slippage cap, minimum number of tokens to be received after swap
    /// @return uint128 amount of PTs sold
    function buyUnderlying(
        address u,
        uint256 m,
        uint128 a,
        uint128 s
    ) external returns (uint128) {
        IPool pool = IPool(pools[u][m]);
        Safe.transferFrom(
            IERC20(address(pool.fyToken())),
            msg.sender,
            address(pool),
            a
        );
        uint128 preview = pool.buyBasePreview(a);
        if (preview < s) {
            revert Exception(16, preview, 0, address(0), address(0));
        }
        return pool.buyBase(msg.sender, preview, 0);
    }

    /// @notice mint liquidity tokens in exchange for adding underlying and PT
    /// @dev amount of liquidity tokens to mint is calculated from the amount of unaccounted for PT in this contract.
    /// @dev A proportional amount of underlying tokens need to be present in this contract, also unaccounted for.
    /// @param u the address of the underlying token
    /// @param m the maturity of the principal token
    /// @param b number of base tokens
    /// @param p the principal token amount being sent
    /// @param minRatio minimum ratio of underlying to PT in the pool.
    /// @param maxRatio maximum ratio of underlying to PT in the pool.
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
        IPool pool = IPool(pools[u][m]);
        Safe.transferFrom(IERC20(pool.base()), msg.sender, address(pool), b);
        Safe.transferFrom(
            IERC20(address(pool.fyToken())),
            msg.sender,
            address(pool),
            p
        );
        return pool.mint(msg.sender, msg.sender, minRatio, maxRatio);
    }

    /// @notice Mint liquidity tokens in exchange for adding only underlying
    /// @dev amount of liquidity tokens is calculated from the amount of PT to buy from the pool,
    /// plus the amount of unaccounted for PT in this contract.
    /// @param u the address of the underlying token
    /// @param m the maturity of the principal token
    /// @param a the underlying amount being sent
    /// @param p amount of `PT` being bought in the Pool, from this we calculate how much underlying it will be taken in.
    /// @param minRatio minimum ratio of underlying to PT in the pool.
    /// @param maxRatio maximum ratio of underlying to PT in the pool.
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
        IPool pool = IPool(pools[u][m]);
        Safe.transferFrom(IERC20(pool.base()), msg.sender, address(pool), a);
        return pool.mintWithBase(msg.sender, msg.sender, p, minRatio, maxRatio);
    }

    /// @notice burn liquidity tokens in exchange for underlying and PT.
    /// @param u the address of the underlying token
    /// @param m the maturity of the principal token
    /// @param minRatio minimum ratio of underlying to PT in the pool
    /// @param maxRatio maximum ratio of underlying to PT in the pool
    /// @return uint256 amount of LP tokens burned
    /// @return uint256 amount of base tokens received
    /// @return uint256 amount of fyTokens received
    function burn(
        address u,
        uint256 m,
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
        return
            IPool(pools[u][m]).burn(msg.sender, msg.sender, minRatio, maxRatio);
    }

    /// @notice burn liquidity tokens in exchange for underlying.
    /// @param u the address of the underlying token
    /// @param m the maturity of the principal token
    /// @param minRatio minimum ratio of underlying to PT in the pool.
    /// @param maxRatio minimum ratio of underlying to PT in the pool.
    /// @return uint256 amount of PT tokens sent to the pool
    /// @return uint256 amount of underlying tokens returned
    function burnForUnderlying(
        address u,
        uint256 m,
        uint256 minRatio,
        uint256 maxRatio
    ) external returns (uint256, uint256) {
        return IPool(pools[u][m]).burnForBase(msg.sender, minRatio, maxRatio);
    }

    /// @notice provides an interface to receive principal token addresses from markets
    /// @param u underlying asset contract address
    /// @param m maturity timestamp for the market
    /// @param p principal index mapping to the Principals enum
    function token(
        address u,
        uint256 m,
        uint256 p
    ) external view returns (address) {
        return markets[u][m][p];
    }
}
