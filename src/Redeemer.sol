// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.20;

import "./MarketPlace.sol";

import "./lib/Safe.sol";
import "./errors/Exception.sol";

import "./interfaces/IERC5095.sol";
import "./interfaces/IERC20.sol";
import "./interfaces/IAPWineController.sol";
import "./interfaces/IAPWineFutureVault.sol";
import "./interfaces/IAPWineToken.sol";
import "./interfaces/ILender.sol";
import "./interfaces/IConverter.sol";

/// @title Redeemer
/// @author Sourabh Marathe, Julian Traversa, Rob Robbins
/// @notice The Redeemer contract is used to redeem the underlying lent capital of a loan.
/// @notice Users may redeem their ERC-5095 tokens for the underlying asset represented by that token after maturity.
contract Redeemer {

    address public lender; 

    address public marketplace;

    address public redeemer = address(this);

    /// @notice minimum wait before the admin may withdraw funds or change the fee rate
    uint256 public constant HOLD = 3 days;

    /// @notice address that is allowed to set fees and contracts, etc. It is commonly used in the authorized modifier.
    address public admin;

    /// @notice third party contract needed to redeem Swivel PTs
    address public immutable swivelAddr;

    /// @notice this value determines the amount of fees paid on auto redemptions
    uint256 public feenominator;
    /// @notice represents a point in time where the feenominator may change
    uint256 public feeChange;
    /// @notice represents a minimum that the feenominator must exceed
    uint256 public MIN_FEENOMINATOR = 500;

    /// @notice mapping that indicates how much underlying has been redeemed by a market
    mapping(address => mapping(uint256 => uint256)) public holdings;
    /// @notice mapping that determines if a market's iPT can be redeemed
    mapping(address => mapping(uint256 => bool)) public paused;

    /// @notice emitted upon redemption of a loan
    event Redeem(
        uint8 principal,
        address indexed underlying,
        uint256 indexed maturity,
        uint256 amount,
        uint256 burned,
        address sender
    );
    /// @notice emitted upon changing the admin
    event SetAdmin(address indexed admin);
    /// @notice emitted upon changing the converter
    event SetConverter(address indexed converter);
    /// @notice emitted upon setting the fee rate
    event SetFee(uint256 indexed fee);
    /// @notice emitted upon scheduling a fee change
    event ScheduleFeeChange(uint256 when);
    /// @notice emitted upon pausing of Illuminate PTs
    event PauseRedemptions(
        address indexed underlying,
        uint256 maturity,
        bool state
    );

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
    modifier unpaused(address u, uint256 m) {
        if (paused[u][m] || ILender(lender).halted()) {
            revert Exception(17, m, 0, u, address(0));
        }
        _;
    }

    /// @notice Initializes the Redeemer contract
    /// @param l the lender contract
    /// @param s the Swivel contract
    constructor(address l, address s) {
        admin = msg.sender;
        lender = l;
        swivelAddr = s;
        feenominator = 4000;
    }

    /// @notice sets the admin address
    /// @param a Address of a new admin
    /// @return bool true if successful
    function setAdmin(address a) external authorized(admin) returns (bool) {
        admin = a;
        emit SetAdmin(a);
        return (true);
    }

    /// @notice sets the address of the marketplace contract which contains the addresses of all the fixed rate markets
    /// @param m the address of the marketplace contract
    /// @return bool true if the address was set
    function setMarketPlace(
        address m
    ) external authorized(admin) returns (bool) {
        // MarketPlace may only be set once
        if (marketplace != address(0)) {
            revert Exception(5, 0, 0, marketplace, address(0));
        }

        marketplace = m;
        return (true);
    }

    /// @notice sets the address of the lender contract which contains the addresses of all the fixed rate markets
    /// @param l the address of the lender contract
    /// @return bool true if the address was set
    function setLender(address l) external authorized(admin) returns (bool) {
        // Lender may only be set once
        if (lender != address(0)) {
            revert Exception(8, 0, 0, address(lender), address(0));
        }

        lender = l;
        return (true);
    }

    /// @notice sets the feenominator to the given value
    /// @param f the new value of the feenominator, fees are not collected when the feenominator is 0
    /// @return bool true if successful
    function setFee(uint256 f) external authorized(admin) returns (bool) {
        // Cache the minimum timestamp for executing a fee rate change
        uint256 feeTime = feeChange;

        // Check that a fee rate change has been scheduled
        if (feeTime == 0) {
            revert Exception(23, 0, 0, address(0), address(0));

            // Check that the scheduled fee rate change time has been passed
        } else if (block.timestamp < feeTime) {
            revert Exception(
                24,
                block.timestamp,
                feeTime,
                address(0),
                address(0)
            );
            // Check the the new fee rate is not too high
        } else if (f < MIN_FEENOMINATOR) {
            revert Exception(25, 0, 0, address(0), address(0));
        }

        // Set the new fee rate
        feenominator = f;

        // Unschedule the fee rate change
        delete feeChange;

        emit SetFee(f);
        return (true);
    }

    /// @notice allows the admin to schedule a change to the fee denominators
    function scheduleFeeChange() external authorized(admin) returns (bool) {
        // Calculate the timestamp that must be passed prior to setting thew new fee
        uint256 when = block.timestamp + HOLD;

        // Store the timestamp that must be passed to update the fee rate
        feeChange = when;

        emit ScheduleFeeChange(when);

        return (true);
    }

    /// @notice allows admin to stop redemptions of Illuminate PTs for a given market
    /// @param u address of an underlying asset
    /// @param m maturity (timestamp) of the market
    /// @param b true to pause, false to unpause
    function pauseRedemptions(
        address u,
        uint256 m,
        bool b
    ) external authorized(admin) {
        paused[u][m] = b;
        emit PauseRedemptions(u, m, b);
    }

    /// @notice bulk approves the usage of addresses at the given ERC20 addresses.
    /// @dev the lengths of the inputs must match because the arrays are paired by index
    /// @param u array of ERC20 token addresses that will be approved on
    /// @param a array of addresses that will be approved
    /// @return true if successful
    function approve(
        address[] calldata u,
        address[] calldata a
    ) external authorized(admin) returns (bool) {
        for (uint256 i; i != u.length; ) {
            IERC20 uToken = IERC20(u[i]);
            if (address(0) != (address(uToken))) {
                Safe.approve(uToken, a[i], type(uint256).max);
            }
            unchecked {
                ++i;
            }
        }
        return (true);
    }

    /// @notice redeems principal tokens held by the Lender contract via its adapter
    /// @param p enum value of the protocol being redeemed in the market
    /// @param u address of an underlying asset
    /// @param m maturity (timestamp) of the market
    /// @param d calldata necessary to conduct the protocol's redemption
    /// @return amount of the underlying asset returned
    function redeem(
        uint8 p,
        address u,
        uint256 m,
        bytes calldata d
    ) external unpaused(u, m) returns (uint256) {
        // Get the principal token that is being redeemed
        address pt = IMarketPlace(marketplace).markets(u, m).tokens[p];

        // Get the adapter for the protocol being redeemed
        address adapter = IMarketPlace(marketplace).adapters(p);

        {
            // Verify that the PT has matured
            (bool success, bytes memory returndata) = adapter.delegatecall(
                abi.encodeWithSignature('maturity()', '')
            );
            if (!success) {
                revert Exception(0, 0, 0, address(0), address(0)); // TODO: add maturity retrieval failure code
            }

            uint256 ptMaturity = abi.decode(returndata, (uint256));
            if (block.timestamp < ptMaturity) {
                revert Exception(0, 0, 0, address(0), address(0)); // TODO: add failed to mature code
            }
        }

        uint256 amount;
        uint256 redeemed;

        {
            // Cache the lender to save gas on sload
            address cachedLender = lender;

            // Get the amount of principal tokens held by the lender
            amount = IERC20(pt).balanceOf(cachedLender);

            // Receive the principal token from the lender contract
            Safe.transferFrom(IERC20(pt), cachedLender, address(this), amount);
        }

        {
            // Get the starting balance of the underlying held by the redeemer
            uint256 starting = IERC20(u).balanceOf(address(this));

            // Conduct the redemption via the adapter
            (bool success, ) = adapter.delegatecall(
                abi.encodeWithSignature('redeem(uint256,address,uint256,bool,bytes)', u, m, amount, true, d)
            );
            if (!success) {
                revert Exception(0, 0, 0, address(0), address(0)); // TODO: add error code
            }

            // Calculate how much underlying was redeemed
            redeemed = IERC20(u).balanceOf(address(this)) - starting;

            // Update the holding for this market
            address underlying = u;
            uint256 maturity = m;
            holdings[underlying][maturity] =
                holdings[underlying][maturity] +
                redeemed;
        }

        emit Redeem(p, u, m, redeemed, amount, msg.sender);

        return (redeemed);
    }

    /// @notice burns Illuminate principal tokens and sends underlying to user
    /// @param u address of an underlying asset
    /// @param m maturity (timestamp) of the market
    /// @return uint256 amount of the underlying asset returned
    function redeem(address u, uint256 m) external unpaused(u, m) returns (uint256) {
        // Get Illuminate's principal token for this market
        IERC5095 token = IERC5095(
            IMarketPlace(marketplace).adapters(uint8(MarketPlace.Principals.Illuminate))
            );

        // Verify the token has matured
        if (block.timestamp < token.maturity()) {
            revert Exception(7, block.timestamp, m, address(0), address(0));
        }

        // Get the amount of tokens to be redeemed from the sender
        uint256 amount = token.balanceOf(msg.sender);

        // Calculate how many tokens the user should receive
        uint256 redeemed = (amount * holdings[u][m]) / token.totalSupply();

        // Update holdings of underlying
        holdings[u][m] = holdings[u][m] - redeemed;

        // Burn the user's principal tokens
        token.authBurn(msg.sender, amount);

        // Transfer the original underlying token back to the user
        Safe.transfer(IERC20(u), msg.sender, redeemed);

        emit Redeem(0, u, m, redeemed, amount, msg.sender);

        return (redeemed);
    }

    /// @notice implements the redeem method for the contract to fulfill the ERC-5095 interface
    /// @param u address of an underlying asset
    /// @param m maturity (timestamp) of the market
    /// @param f address from where the underlying asset will be burned
    /// @param t address to where the underlying asset will be transferred
    /// @param a amount of the Illuminate PT to be burned and redeemed
    /// @return uint256 amount of the underlying asset that was burned
    function authRedeem(
        address u,
        uint256 m,
        address f,
        address t,
        uint256 a
    )
        external
        authorized(IMarketPlace(marketplace).markets(u, m).tokens[0])
        unpaused(u, m)
        returns (uint256)
    {
        // Get the principal token for the given market
        IERC5095 pt = IERC5095(IMarketPlace(marketplace).markets(u, m).tokens[0]);

        // Make sure the market has matured
        uint256 maturity = pt.maturity();
        if (block.timestamp < maturity) {
            revert Exception(7, maturity, 0, address(0), address(0));
        }

        // Calculate the amount redeemed
        uint256 redeemed = (a * holdings[u][m]) / pt.totalSupply();

        // Update holdings of underlying
        holdings[u][m] = holdings[u][m] - redeemed;

        // Burn the user's principal tokens
        pt.authBurn(f, a);

        // Transfer the original underlying token back to the user
        Safe.transfer(IERC20(u), t, redeemed);

        emit Redeem(0, u, m, redeemed, a, msg.sender);

        return (a);
    }

    /// @notice implements a redeem method to enable third-party redemptions
    /// @dev expects approvals from owners to redeemer
    /// @param u address of the underlying asset
    /// @param m maturity of the market
    /// @param f address from where the principal token will be burned
    /// @return uint256 amount of underlying yielded as a fee
    function autoRedeem(
        address u,
        uint256 m,
        address[] calldata f
    ) external unpaused(u, m) returns (uint256) {
        // Get the principal token for the given market
        IERC5095 pt = IERC5095(IMarketPlace(marketplace).markets(u, m).tokens[0]);

        // Make sure the market has matured
        if (block.timestamp < pt.maturity()) {
            revert Exception(7, pt.maturity(), 0, address(0), address(0));
        }

        // Sum up the fees received by the caller
        uint256 incentiveFee;

        // Loop through the provided arrays and mature each individual position
        for (uint256 i; i != f.length; ) {
            // Fetch the allowance set by the holder of the principal tokens
            uint256 allowance = pt.allowance(f[i], address(this));

            // Get the amount of tokens held by the owner
            uint256 amount = pt.balanceOf(f[i]);

            // Calculate how many tokens the user should receive
            uint256 redeemed = (amount * holdings[u][m]) / pt.totalSupply();

            // Verify allowance
            if (allowance < amount) {
                revert Exception(20, allowance, amount, address(0), address(0));
            }

            // Burn the tokens from the user
            pt.authBurn(f[i], amount);

            // Reduce the allowance of the burned tokens
            pt.authApprove(f[i], address(this), 0);

            // Update the holdings for this market
            holdings[u][m] = holdings[u][m] - redeemed;

            {
                // Calculate the fees to be received
                uint256 fee = redeemed / feenominator;

                // Transfer the underlying to the user
                Safe.transfer(IERC20(u), f[i], redeemed - fee);

                unchecked {
                    // Track the fees gained by the caller
                    incentiveFee += fee;

                    ++i;
                }
            }
        }

        // Transfer the fee to the caller
        Safe.transfer(IERC20(u), msg.sender, incentiveFee);

        return (incentiveFee);
    }

    /// @notice Allows for external deposit of underlying for a market
    /// @notice This is to be used in emergency situations where the redeem method is not functioning for a market
    /// @param u address of the underlying asset
    /// @param m maturity of the market
    /// @param a amount of underlying to be deposited
    function depositHoldings(address u, uint256 m, uint256 a) external {
        // Receive the underlying asset from the admin
        Safe.transferFrom(IERC20(u), msg.sender, address(this), a);

        // Update the holdings
        holdings[u][m] += a;
    }
}
