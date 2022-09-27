// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.16;

import 'src/MarketPlace.sol';

import 'src/lib/Safe.sol';
import 'src/errors/Exception.sol';

import 'src/interfaces/IERC5095.sol';
import 'src/interfaces/IERC20.sol';
import 'src/interfaces/ITempus.sol';
import 'src/interfaces/ITempusPool.sol';
import 'src/interfaces/ITempusToken.sol';
import 'src/interfaces/IAPWine.sol';
import 'src/interfaces/IAPWineController.sol';
import 'src/interfaces/IAPWineFutureVault.sol';
import 'src/interfaces/IAPWineToken.sol';
import 'src/interfaces/IAPWineAMMPool.sol';
import 'src/interfaces/ISwivel.sol';
import 'src/interfaces/ISwivelToken.sol';
import 'src/interfaces/IElementToken.sol';
import 'src/interfaces/IYieldToken.sol';
import 'src/interfaces/INotional.sol';
import 'src/interfaces/IPendle.sol';
import 'src/interfaces/IPendleForge.sol';
import 'src/interfaces/IPendleToken.sol';
import 'src/interfaces/ISenseDivider.sol';
import 'src/interfaces/ISenseAdapter.sol';
import 'src/interfaces/IYield.sol';
import 'src/interfaces/IConverter.sol';

/// @title Redeemer
/// @author Sourabh Marathe, Julian Traversa, Rob Robbins
/// @notice The Redeemer contract is used to redeem the underlying lent capital of a loan.
/// @notice Users may redeem their ERC-5095 tokens for the underlying asset represented by that token after maturity.
contract Redeemer {
    /// @notice address that is allowed to set the lender and marketplace
    address public admin;
    /// @notice address used to access the MarketPlace's markets mapping
    address public marketPlace;
    /// @notice address that custodies principal tokens for all markets
    address public lender;
    /// @notice address that converts compounding tokens to their underlying (used by pendle's redeem)
    address public converter;

    /// @notice third party contract needed to lend on Swivel
    address public immutable swivelAddr;
    /// @notice third party contract needed to lend on Pendle
    address public immutable pendleAddr;
    /// @notice third party contract needed to lend on Tempus
    address public immutable tempusAddr;
    /// @notice third party contract needed to lend on APWine
    address public immutable apwineAddr;

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
        address sender
    );
    /// @notice emitted on change of admin
    event SetAdmin(address indexed admin);
    /// @notice emitted on change of converter
    event SetConverter(address indexed converter);

    /// @notice ensures that only a certain address can call the function
    /// @param a address that msg.sender must be to be authorized
    modifier authorized(address a) {
        if (msg.sender != a) {
            revert Exception(0, 0, 0, msg.sender, a);
        }
        _;
    }

    /// @notice reverts on all markets where the paused mapping returns true
    /// @param u underlying asset
    /// @param m maturity
    modifier unpaused(address u, uint256 m) {
        if (paused[u][m]) {
            revert Exception(17, m, 0, u, address(0));
        }
        _;
    }

    /// @notice Initializes the Redeemer contract
    /// @param l the lender contract
    /// @param s the Swivel contract
    /// @param p the Pendle contract
    /// @param t the Tempus contract
    /// @param a the APWine contract
    constructor(
        address l,
        address s,
        address p,
        address t,
        address a
    ) {
        admin = msg.sender;
        lender = l;
        swivelAddr = s;
        pendleAddr = p;
        tempusAddr = t;
        apwineAddr = a;
    }

    /// @notice sets the admin address
    /// @param a Address of a new admin
    /// @return bool true if successful
    function setAdmin(address a) external authorized(admin) returns (bool) {
        admin = a;
        emit SetAdmin(a);
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

    /// @notice sets the converter address
    /// @param c address of the new converter
    /// @return bool true if successful
    function setConverter(address c) external authorized(admin) returns (bool) {
        converter = c;
        emit SetConverter(c);
        return true;
    }

    /// @notice sets the address of the lender contract which contains the addresses of all the fixed rate markets
    /// @param l the address of the lender contract
    /// @return bool true if the address was set
    function setLender(address l) external authorized(admin) returns (bool) {
        if (lender != address(0)) {
            revert Exception(8, 0, 0, address(lender), address(0));
        }
        lender = l;
        return true;
    }

    /// @notice allows admin to stop redemptions of illuminate PTs for a given market
    /// @param u address of underlying asset
    /// @param m maturity of the market
    /// @param b true to pause, false to unpause
    function pauseRedemptions(
        address u,
        uint256 m,
        bool b
    ) external authorized(admin) {
        paused[u][m] = b;
    }

    /// @notice approves the converter to spend the compounding asset
    /// todo does this need to be restricted?
    function approve(address p) external {
        if (p != address(0)) {
            address yield = IPendleToken(p).underlyingYieldToken();

            IERC20(yield).approve(address(converter), type(uint256).max);
        }
    }

    /// @notice redeem method for Swivel, Yield, Element, Pendle, APWine, Tempus and Notional protocols
    /// @param p value of a specific principal according to the Illuminate Principals Enum
    /// @param u underlying token being redeemed
    /// @param m maturity of the market being redeemed
    /// @return bool true if the redemption was successful
    function redeem(
        uint8 p,
        address u,
        uint256 m
    ) external returns (bool) {
        // Get the principal token that is being redeemed by the user
        address principal = IMarketPlace(marketPlace).token(u, m, p);
        uint256 maturity;

        // Confirm that this market has matured
        if (p == uint8(MarketPlace.Principals.Element)) {
            maturity = IElementToken(principal).unlockTimestamp();
            if (maturity > block.timestamp) {
                revert Exception(7, maturity, 0, address(0), address(0));
            }
        } else if (p == uint8(MarketPlace.Principals.Notional)) {
            maturity = INotional(principal).getMaturity();
            if (maturity > block.timestamp) {
                revert Exception(7, maturity, 0, address(0), address(0));
            }
        } else if (p == uint8(MarketPlace.Principals.Apwine)) {
            maturity = apwineMaturity(principal);
            if (maturity > block.timestamp) {
                revert Exception(7, maturity, 0, address(0), address(0));
            }
            principal = IAPWineAMMPool(principal).getPTAddress();
        } else if (p == uint8(MarketPlace.Principals.Tempus)) {
            address pool = ITempusToken(principal).pool();
            maturity = ITempusPool(pool).maturityTime();

            if (maturity > block.timestamp) {
                revert Exception(7, maturity, 0, address(0), address(0));
            }
        } else if (
            p != uint8(MarketPlace.Principals.Yield) &&
            p != uint8(MarketPlace.Principals.Swivel) &&
            p != uint8(MarketPlace.Principals.Pendle)
        ) {
            revert Exception(6, p, 0, address(0), address(0));
        }

        // Cache the lender to save gas on sload
        address cachedLender = lender;

        // The amount redeemed should be the balance of the principal token held by the Illuminate contract
        uint256 amount = IERC20(principal).balanceOf(cachedLender);

        // Transfer the principal token from the lender contract to here
        Safe.transferFrom(
            IERC20(principal),
            cachedLender,
            address(this),
            amount
        );

        // Starting balance of the underlying held by the redeemer
        uint256 starting = IERC20(u).balanceOf(address(this));

        if (p == uint8(MarketPlace.Principals.Swivel)) {
            // Get the maturity for thisprincipal token
            maturity = ISwivelToken(principal).maturity();
            // Redeems zc tokens to the sender's address
            if (!ISwivel(swivelAddr).redeemZcToken(u, maturity, amount)) {
                revert Exception(15, 0, 0, address(0), address(0));
            }
        } else if (p == uint8(MarketPlace.Principals.Element)) {
            // Redeems principal tokens from element
            IElementToken(principal).withdrawPrincipal(amount, address(this));
        } else if (p == uint8(MarketPlace.Principals.Yield)) {
            // Redeems principal tokens from yield
            IYieldToken(principal).redeem(address(this), amount);
        } else if (p == uint8(MarketPlace.Principals.Notional)) {
            // Redeems the principal token from notional
            // TODO: Should this just use the balance of the principal token (instead of maxRedeem)?
            INotional(principal).redeem(
                INotional(principal).maxRedeem(address(this)),
                address(this),
                address(this)
            );
        } else if (p == uint8(MarketPlace.Principals.Pendle)) {
            // Get the maturity for this principal token
            maturity = IPendleToken(principal).expiry();
            // Get the forge contract for the principal token
            address forge = IPendleToken(principal).forge();
            // Get the forge ID of the principal token
            bytes32 forgeId = IPendleForge(forge).forgeId();
            // Redeem the tokens from the Pendle contract
            IPendle(pendleAddr).redeemAfterExpiry(forgeId, u, maturity);
            // Get the compounding asset for this market
            address compounding = IPendleToken(principal)
                .underlyingYieldToken();
            // Redeem the compounding to token to the underlying
            IConverter(converter).convert(
                compounding,
                u,
                IERC20(compounding).balanceOf(address(this)),
                0
            );
        } else if (p == uint8(MarketPlace.Principals.Apwine)) {
            address futureVault = IAPWineToken(principal).futureVault();
            // Redeem the underlying token from APWine to Illuminate
            IAPWine(apwineAddr).withdraw(futureVault, amount);
        } else if (p == uint8(MarketPlace.Principals.Tempus)) {
            // Retrieve the pool for the principal token
            address pool = ITempusToken(principal).pool();
            // Redeem the tokens from the Tempus contract to Illuminate
            ITempus(tempusAddr).redeemToBacking(pool, amount, 0, address(this));
        }

        // Update the holding for this market
        holdings[u][m] =
            holdings[u][m] +
            (IERC20(u).balanceOf(address(this)) - starting);

        emit Redeem(p, u, m, amount, msg.sender);
        return true;
    }

    /// @notice redeem method signature for Sense
    /// @param p value of a specific principal according to the Illuminate Principals Enum
    /// @param u underlying token being redeemed
    /// @param m maturity of the market being redeemed
    /// @param s Sense's maturity is needed to extract the pt address
    /// @return bool true if the redemption was successful
    function redeem(
        uint8 p,
        address u,
        uint256 m,
        uint256 s
    ) external returns (bool) {
        // Check the principal is Sense
        if (p != uint8(MarketPlace.Principals.Sense)) {
            revert Exception(6, p, 0, address(0), address(0));
        }

        // Get the adapter for sense
        address adapter = IMarketPlace(marketPlace).token(u, m, p);

        // Get the divider from the adapter
        ISenseDivider divider = ISenseDivider(ISenseAdapter(adapter).divider());

        // Retrieve the principal token from the adapter
        IERC20 token = IERC20(divider.pt(adapter, s));

        // Cache the lender to save on sloads
        address cachedLender = lender;

        // Get the balance of tokens to be redeemed by the user
        uint256 amount = token.balanceOf(cachedLender);

        // Transfer the user's tokens to the redeem contract
        Safe.transferFrom(token, cachedLender, address(this), amount);

        // Get the starting balance to verify the amount received afterwards
        uint256 starting = IERC20(u).balanceOf(address(this));

        // Redeem the tokens from the Sense contract
        ISenseDivider(divider).redeem(adapter, s, amount);

        // Get the compounding token that is redeemed by Sense
        address target = ISenseAdapter(adapter).target();

        // Redeem the compounding token back to the underlying
        IConverter(converter).convert(
            target,
            u,
            IERC20(target).balanceOf(address(this)),
            0
        );

        // Get the amount received
        uint256 received = IERC20(u).balanceOf(address(this)) - starting;

        // Verify that we received expected underlying
        if (received < amount) {
            revert Exception(13, 0, 0, address(0), address(0));
        }

        // Update the holdings for this market
        holdings[u][m] = holdings[u][m] + received;

        emit Redeem(p, u, m, amount, msg.sender);
        return true;
    }

    /// @notice burns illuminate principal tokens and sends underlying to user
    /// @param u address of the underlying asset
    /// @param m maturity of the market
    function redeem(address u, uint256 m) external unpaused(u, m) {
        // Verify the market has matured
        if (block.timestamp < m) {
            revert Exception(7, block.timestamp, m, address(0), address(0));
        }
        // Get Illuminate's principal token for this market
        IERC5095 token = IERC5095(
            IMarketPlace(marketPlace).token(
                u,
                m,
                uint8(MarketPlace.Principals.Illuminate)
            )
        );
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
        emit Redeem(0, u, m, amount, msg.sender);
    }

    /// @notice implements the redeem method for the contract to fulfill the ERC-5095 interface
    /// @param u address of the underlying asset
    /// @param m maturity of the market
    /// @param f address from where the underlying asset will be burned
    /// @param t address to where the underlying asset will be transferred
    /// @param a amount of the underlying asset to be burned and redeemed
    /// @return uint256 amount of the underlying asset that was burned
    function authRedeem(
        address u,
        uint256 m,
        address f,
        address t,
        uint256 a
    )
        external
        authorized(IMarketPlace(marketPlace).token(u, m, 0))
        returns (uint256)
    {
        // Get the principal token for the given market
        IERC5095 pt = IERC5095(IMarketPlace(marketPlace).token(u, m, 0));

        // Make sure the market has matured
        uint256 maturity = pt.maturity();
        if (block.timestamp < maturity) {
            revert Exception(7, maturity, 0, address(0), address(0));
        }

        // Burn the user's principal tokens
        pt.authBurn(f, a);

        // Transfer the original underlying token back to the user
        Safe.transfer(IERC20(u), t, a);
        return a;
    }

    /// @notice implements a redeem method to enable third-party redemptions
    /// @param u address of the underlying asset
    /// @param m maturity of the market
    /// @param f address from where the principal token will be burned
    /// @param a amount of the illuminate principal token to be burned and redeemed
    /// @return uint256 amount of underlying yielded as a fee
    function autoRedeem(
        address u,
        uint256 m,
        address[] calldata f,
        uint256[] calldata a
    ) external returns (uint256) {
        uint256 length = f.length;
        if (length != a.length) {
            revert Exception(4, length, a.length, address(0), address(0));
        }

        // Get the principal token for the given market
        IERC5095 pt = IERC5095(IMarketPlace(marketPlace).token(u, m, 0));

        // Make sure the market has matured
        uint256 maturity = pt.maturity();
        if (block.timestamp < maturity) {
            revert Exception(7, maturity, 0, address(0), address(0));
        }

        IERC20 uToken = IERC20(u);

        uint256 incentiveFee;

        // Loop through the provided arrays and mature each individual position
        for (uint256 i; i != length; ) {
            uint256 allowance = uToken.allowance(f[i], address(this));
            uint256 fee = a[i] / 4000; // 2.5 basis points (.025%)
            if (allowance < a[i]) {
                revert Exception(20, allowance, a[i], address(0), address(0));
            }
            pt.authApproval(f[i], (allowance - a[i]));
            pt.authBurn(f[i], a[i]);
            uToken.transfer(f[i], (a[i] - fee));
            unchecked {
                ++i;
                incentiveFee += fee;
            }
        }
        uToken.transfer(msg.sender, incentiveFee);
        return incentiveFee;
    }

    /// @notice gets the maturity for a given APWine amm pool
    /// @param p address of the amm pool
    /// @return uint256 maturity timestamp for the amm pool
    function apwineMaturity(address p) internal view returns (uint256) {
        // Retrieve principal token for this amm pool
        address pt = IAPWineAMMPool(p).getPTAddress();

        // Retrieve corresponding future vault for this amm pool
        address futureVault = IAPWineToken(pt).futureVault();

        // Retrieve the period duration for this future vault
        uint256 duration = IAPWineFutureVault(futureVault).PERIOD_DURATION();

        // Return the next period (implicitly current maturity) for this amm pool
        return
            IAPWineController(
                IAPWineFutureVault(futureVault).getControllerAddress()
            ).getNextPeriodStart(duration);
    }
}
