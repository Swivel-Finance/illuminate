// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.20;

import "./tokens/ERC5095.sol";
import "./lib/RevertMsgExtractor.sol";
import "./errors/Exception.sol";

import "./interfaces/ICreator.sol";

/// @title MarketPlace
/// @author Sourabh Marathe, Julian Traversa, Rob Robbins
/// @notice This contract is in charge of managing the available principals for each loan market.
/// @notice In addition, this contract routes swap orders between Illuminate PTs and their respective underlying to YieldSpace pools.
contract MarketPlace {

    address public lender; 

    address public marketplace = address(this);

    address public redeemer;

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

    struct Market {
        address[] tokens;
        address[] adapters;
        address pool;
    }

    /// @notice markets are defined by a maturity and underlying tuple that points to an array of principal token addresses.
    mapping(address => mapping(uint256 => Market)) public _markets;
    /// @notice address that is allowed to create markets, set pools, etc. It is commonly used in the authorized modifier.
    address public admin;
    /// @notice address of the deployed creator contract
    address public immutable creator;
    // @notice address of the deployed illuminate adapter contract
    address public illuminateAdapter;

    function markets(address u, uint256 m) public view returns (Market memory) {
        return _markets[u][m];
    }

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

        Market memory market;
        market.tokens = new address[](t.length + 1);

        // Create the iPT and set at index 0
        market.tokens[0] = ICreator(creator).create(
            u,
            m,
            redeemer,
            lender,
            address(this),
            n,
            s
        );

        {   
            market.adapters = new address[](a.length + 1);
            // The first adapter must be a Illuminate adapter (we could hardcode this so that the array lenghts are the same?)
            market.adapters[0] = illumAdapter;
            // Assign values for the principal tokens and adapters array
            for (uint i = 0; i < t.length; i++) {
                market.tokens[i + 1] = t[i];
                market.adapters[i + 1] = a[i]; 
                // TODO: Get a small review here on the logic -- The idea is we input adapter[0] as an illuminate adapter, and token is already set on line 120
                // While the rest (both adapters and tokens outside of the iPT) are set in this loop
            }
        }

        // Store market in the markets mapping
        _markets[u][m] = market;

        {
            address underlying = u;
            uint256 maturity = m;
            emit CreateMarket(
                underlying,
                maturity,
                market.tokens,
                market.adapters
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
        _markets[u][m].tokens[p] = a;

        // Set the adapter contract in the adapters mapping
        _markets[u][m].adapters[p] = adapter;

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
        _markets[u][m].pool = a;

        // Get the principal token
        ERC5095 pt = ERC5095(_markets[u][m].tokens[uint8(Principals.Illuminate)]);

        // Set the pool for the principal token
        pt.setPool(a);

        // Approve the marketplace to spend the principal and underlying tokens
        pt.approveMarketPlace();

        emit SetPool(u, m, a);
        return true;
    }

    // @notice sets the address for the lender
    // @param l address of the lender
    // @return bool true if the lender set, false otherwise
    function setLender(address l) external authorized(admin) returns (bool) {
        lender = l;
        return true;
    }

    // @notice sets the address for the redeemer
    // @param r address of the redeemer
    // @return bool true if the redeemer set, false otherwise
    function setRedeemer(address r) external authorized(admin) returns (bool) {
        redeemer = r;
        return true;
    }

    function setIlluminateAdapter(address i) external authorized(admin) returns (bool) {
        illuminateAdapter = i;
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
        address adapter = _markets[u][m].adapters[p];

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
