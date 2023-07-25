// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.20;

import 'src/tokens/ERC5095.sol';
import 'src/lib/RevertMsgExtractor.sol';
import 'src/errors/Exception.sol';

import 'src/interfaces/ICreator.sol';

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
    /// @param approvalCalldata calldata for approvals for the protcol
    /// @return bool true if the principal set, false otherwise
    function setPrincipal(
        uint8 p,
        address u,
        uint256 m,
        address a,
        address adapter,
        bytes calldata approvalCalldata
    ) external authorized(admin) returns (bool) {
        // Set the principal token in the markets mapping
        markets[u][m][p] = a;

        // Set the adapter contract in the adapters mapping
        adapters[u][m][p] = adapter;

        // Call any necessary approvals for the new adapter
        (bool success, ) = adapter.delegatecall(
            abi.encodeWithSignature(
                'approve(address[] calldata)',
                approvalCalldata
            )
        );

        emit SetPrincipal(u, m, a, adapter, p);
        return success;
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

    /// @notice approves any necessary addresses for a protocol via its adapter
    /// @param u address of an underlying asset
    /// @param m maturity (timestamp) of the market
    /// @param p index of the protocol's adapter
    /// @param a approval calldata for the given protocol
    /// @return bool true if approvals occurred, false if not
    function approve(
        address u,
        uint256 m,
        uint8 p,
        bytes calldata a
    ) external authorized(admin) returns (bool) {
        address adapter = adapters[u][m][p];

        if (adapter == address(0)) {
            revert Exception(0, 0, 0, address(0), address(0));
        }

        (bool success, ) = adapter.delegatecall(
            abi.encodeWithSignature('approve(address[] calldata)', a)
        );

        return success;
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
