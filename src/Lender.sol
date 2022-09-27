// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.16;

import 'src/MarketPlace.sol'; // library of marketplace specific constructs
import 'src/lib/Swivel.sol'; // library of swivel specific constructs
import 'src/lib/Element.sol'; // library of element specific constructs
import 'src/lib/Safe.sol';
import 'src/lib/Cast.sol';
import 'src/errors/Exception.sol';

import 'src/interfaces/ITempus.sol';
import 'src/interfaces/ITempusAMM.sol';
import 'src/interfaces/ITempusPool.sol';
import 'src/interfaces/ITempusToken.sol';
import 'src/interfaces/IERC20.sol';
import 'src/interfaces/IERC5095.sol';
import 'src/interfaces/ISensePeriphery.sol';
import 'src/interfaces/ISenseAdapter.sol';
import 'src/interfaces/ISenseDivider.sol';
import 'src/interfaces/IERC20.sol';
import 'src/interfaces/IYield.sol';
import 'src/interfaces/IYieldToken.sol';
import 'src/interfaces/ISwivel.sol';
import 'src/interfaces/IElementToken.sol';
import 'src/interfaces/IElementVault.sol';
import 'src/interfaces/ISwivel.sol';
import 'src/interfaces/IAPWineAMMPool.sol';
import 'src/interfaces/IAPWineRouter.sol';
import 'src/interfaces/IAPWineToken.sol';
import 'src/interfaces/IAPWineFutureVault.sol';
import 'src/interfaces/IAPWineController.sol';
import 'src/interfaces/INotional.sol';
import 'src/interfaces/IPendle.sol';
import 'src/interfaces/IPendleToken.sol';

/// @title Lender.sol
/// @author Sourabh Marathe, Julian Traversa, Rob Robbins
/// @notice The lender contract executes loans on behalf of users.
/// @notice The contract holds the principal tokens for each market and mints an ERC-5095 position to users to represent their lent positions.
contract Lender {
    /// @notice minimum amount of time the admin must wait before executing a withdrawal
    uint256 public constant HOLD = 0 hours; // todo make 3 days again

    /// @notice address that is allowed to create markets, set fees, etc. It is commonly used in the authorized modifier.
    address public admin;
    /// @notice address of the MarketPlace.sol contract, used to access the markets mapping
    address public marketPlace;
    /// @notice mapping that determines if a principal may be used by a lender
    mapping(uint8 => bool) public paused;

    /// @notice third party contract needed to lend on Swivel
    address public immutable swivelAddr;
    /// @notice third party contract needed to lend on Pendle
    address public immutable pendleAddr;
    /// @notice third party contract needed to lend on Tempus
    address public immutable tempusAddr; // TODO: Remove, can be retrieved via tempus token

    /// @notice this value determines the amount of fees paid on loans
    uint256 public feenominator;

    /// @notice maps underlying tokens to the amount of fees accumulated for that token
    mapping(address => uint256) public fees;
    /// @notice maps a token address to a point in time, a hold, after which a withdrawal can be made
    mapping(address => uint256) public withdrawals;

    /// @notice emitted upon executed lend
    event Lend(
        uint8 principal,
        address indexed underlying,
        uint256 indexed maturity,
        uint256 returned,
        uint256 spent,
        address sender
    );
    /// @notice emitted upon minted ERC5095 to user
    event Mint(
        uint8 principal,
        address indexed underlying,
        uint256 indexed maturity,
        uint256 amount
    );
    /// @notice emitted on token withdrawal scheduling
    event ScheduleWithdrawal(address indexed token, uint256 hold);
    /// @notice emitted on token withdrawal blocking
    event BlockWithdrawal(address indexed token);
    /// @notice emitted on change of admin
    event SetAdmin(address indexed admin);
    /// @notice emitted upon change of fee
    event SetFee(uint256 indexed fee);

    /// @notice ensures that only a certain address can call the function
    /// @param a address that msg.sender must be to be authorized
    modifier authorized(address a) {
        if (msg.sender != a) {
            revert Exception(0, 0, 0, msg.sender, a);
        }
        _;
    }

    /// @notice reverts on all markets where the paused mapping returns true
    /// @param p principal enum value
    modifier unpaused(uint8 p) {
        if (paused[p]) {
            revert Exception(1, p, 0, address(0), address(0));
        }
        _;
    }

    /// @notice initializes the Lender contract
    /// @param s the swivel contract
    /// @param p the pendle contract
    /// @param t the tempus contract
    constructor(
        address s,
        address p,
        address t
    ) {
        admin = msg.sender;
        swivelAddr = s;
        pendleAddr = p;
        tempusAddr = t;
        feenominator = 1000;
    }

    /// @notice approves the redeemer contract to spend the principal tokens held by the lender contract.
    /// @param u underlying token's address, used to define the market being approved
    /// @param m maturity of the underlying token, used to define the market being approved
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
            address token = IMarketPlace(marketPlace).token(u, m, i);
            // check that the token is defined for this particular market
            if (token != address(0)) {
                // max approve the token
                Safe.approve(IERC20(token), r, type(uint256).max);
            }
            unchecked {
                ++i;
            }
        }
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
    /// @param u address of underlying asset
    /// @param a apwine's router contract
    /// @param e element's vault contract
    /// @param n notional's token contract
    function approve(
        address u,
        address a,
        address e,
        address n
    ) external authorized(marketPlace) {
        uint256 max = type(uint256).max;
        if (a != address(0)) {
            IERC20(u).approve(a, max);
        }
        if (e != address(0)) {
            IERC20(u).approve(e, max);
        }
        if (n != address(0)) {
            IERC20(u).approve(n, max);
        }
    }

    /// @notice approves the principal token to be spent by the lender contract
    /// @dev this is called whenever a notional principal token is set individually
    /// @param u underlying token address of the market
    /// @param p principal token address that is being set
    function approve(address u, address p) external authorized(marketPlace) {
        IERC20(u).approve(p, type(uint256).max);
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
        feenominator = f;
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

    /// @notice mint swaps the sender's principal tokens for illuminate's ERC5095 tokens in effect, this opens a new fixed rate position for the sender on illuminate
    /// @param p value of a specific principal according to the MarketPlace Principals Enum
    /// @param u address of an underlying asset
    /// @param m maturity (timestamp) of the market
    /// @param a amount being minted
    /// @return bool true if the mint was successful
    function mint(
        uint8 p,
        address u,
        uint256 m,
        uint256 a
    ) external unpaused(p) returns (bool) {
        // fetch the desired principal token
        address principal = IMarketPlace(marketPlace).token(u, m, p);
        // transfer the users principal tokens to the lender contract
        Safe.transferFrom(IERC20(principal), msg.sender, address(this), a);
        // mint the tokens received from the user
        IERC5095(principalToken(u, m)).authMint(msg.sender, a);

        emit Mint(p, u, m, a);

        return true;
    }

    /// @notice lend method signature for both illuminate and yield
    /// @param p value of a specific principal according to the MarketPlace Principals Enum
    /// @param u address of an underlying asset
    /// @param m maturity (timestamp) of the market
    /// @param a amount of underlying tokens to lend
    /// @param y yieldspace pool that will execute the swap for the principal token
    /// @param minimum minimum PTs to buy from the yieldspace pool
    /// @return uint256 the amount of principal tokens lent out
    function lend(
        uint8 p,
        address u,
        uint256 m,
        uint256 a,
        address y,
        uint256 minimum
    ) external unpaused(p) returns (uint256) {
        // check the principal is illuminate or yield
        if (
            p != uint8(MarketPlace.Principals.Illuminate) &&
            p != uint8(MarketPlace.Principals.Yield)
        ) {
            revert Exception(6, 0, 0, address(0), address(0));
        }
        // get principal token for this market
        address principal = IMarketPlace(marketPlace).token(u, m, p);

        // Extract fee
        fees[u] = fees[u] + calculateFee(a);

        // transfer from user to illuminate
        Safe.transferFrom(IERC20(u), msg.sender, address(this), a);

        if (p == uint8(MarketPlace.Principals.Yield)) {
            // make sure fytoken matches principal token for this market
            address fyToken = IYield(y).fyToken();
            if (IYield(y).fyToken() != principal) {
                revert Exception(12, 0, 0, fyToken, principal);
            }
        }

        // Swap underlying for PTs to lender
        uint256 returned = yield(
            u,
            y,
            a - calculateFee(a),
            address(this),
            principal,
            minimum
        );

        // Mint illuminate PTs to msg.sender
        IERC5095(principalToken(u, m)).authMint(msg.sender, returned);

        emit Lend(p, u, m, returned, a, msg.sender);

        return returned;
    }

    /// @notice lend method signature for swivel
    /// @dev lends to yield pool. remaining balance is sent to the yield pool
    /// @param p value of a specific principal according to the Illuminate Principals Enum
    /// @param u address of an underlying asset
    /// @param m maturity (timestamp) of the market
    /// @param a array of amounts of underlying tokens lent to each order in the orders array
    /// @param y yield pool
    /// @param o array of swivel orders being filled
    /// @param s array of signatures for each order in the orders array
    /// @param f fee that the user will pay in the underlying
    /// @param e flag to indicate if returned funds should be swapped in yieldpool
    /// @param premiumSlippage only used if e is true, the minimum amount for the yield pool swap on the premium
    /// @return uint256 the amount of principal tokens lent out
    function lend(
        uint8 p,
        address u,
        uint256 m,
        uint256[] memory a,
        address y,
        Swivel.Order[] calldata o,
        Swivel.Components[] calldata s,
        uint256 f,
        bool e,
        uint256 premiumSlippage
    ) external unpaused(p) returns (uint256) {
        if (p != uint8(MarketPlace.Principals.Swivel)) {
            revert Exception(
                6,
                p,
                uint8(MarketPlace.Principals.Swivel),
                address(0),
                address(0)
            );
        }
        {
            // lent represents the amount of underlying to initiate
            uint256 lent = swivelAmount(a);
            // Avoid stack too deep by reinitializing arguments
            address underlying = u;
            uint256 maturity = m;
            uint256[] memory amounts = a;
            address pool = y;
            Swivel.Order[] memory orders = o;
            Swivel.Components[] memory components = s;

            // Get the underlying balance prior to initiate
            uint256 starting = IERC20(underlying).balanceOf(address(this));
            // Verify and collect the fee
            swivelCheckFee(f, lent, underlying);
            uint256 premium;
            {
                // Fill the orders on swivel protocol
                ISwivel(swivelAddr).initiate(orders, amounts, components);
                // Calculate the premium
                premium =
                    IERC20(underlying).balanceOf(address(this)) -
                    starting;
                // For Stack Too Deep purposes
                uint256 ps = premiumSlippage;
                if (e) {
                    swivelLendPremium(underlying, maturity, pool, premium, ps);
                }
            }
            // Mint illuminate principal tokens to the user
            IERC5095(principalToken(underlying, maturity)).authMint(
                msg.sender,
                lent
            );
            {
                uint256 spent = lent + f;
                // Necessary to get around stack too deep
                emit Lend(
                    uint8(MarketPlace.Principals.Swivel),
                    underlying,
                    maturity,
                    lent,
                    spent,
                    msg.sender
                );
            }
            return lent;
        }
    }

    /// @notice lend method signature for element
    /// @param p value of a specific principal according to the Illuminate Principals Enum
    /// @param u address of an underlying asset
    /// @param m maturity (timestamp) of the market
    /// @param a amount of principal tokens to lend
    /// @param r minimum amount to return, this puts a cap on allowed slippage
    /// @param d deadline is a timestamp by which the swap must be executed
    /// @param e element pool that is lent to
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
    ) external unpaused(p) returns (uint256) {
        // Get the principal token for this market for element
        address principal = IMarketPlace(marketPlace).token(u, m, p);

        // Transfer underlying token from user to illuminate
        Safe.transferFrom(IERC20(u), msg.sender, address(this), a);

        // Track the accumulated fees
        fees[u] = fees[u] + calculateFee(a);

        uint256 purchased;
        {
            // Calculate the amount to be lent
            uint256 lent = a - calculateFee(a);

            // Create the variables needed to execute an element swap
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

            // Conduct the swap on element
            purchased = swapElement(e, swap, fund, r, d);
        }

        // Mint tokens to the user
        IERC5095(principalToken(u, m)).authMint(msg.sender, purchased);

        emit Lend(p, u, m, purchased, a, msg.sender);
        return purchased;
    }

    /// @notice lend method signature for pendle
    /// @param p value of a specific principal according to the Illuminate Principals Enum
    /// @param u address of an underlying asset
    /// @param m maturity (timestamp) of the market
    /// @param a amount of principal tokens to lend
    /// @param r minimum amount to return, this puts a cap on allowed slippage
    /// @param d deadline is a timestamp by which the swap must be executed
    /// @return uint256 the amount of principal tokens lent out
    function lend(
        uint8 p,
        address u,
        uint256 m,
        uint256 a,
        uint256 r,
        uint256 d
    ) external unpaused(p) returns (uint256) {
        // Instantiate market and tokens
        address principal = IMarketPlace(marketPlace).token(u, m, p);

        // Transfer funds from user to Illuminate
        Safe.transferFrom(IERC20(u), msg.sender, address(this), a);

        uint256 returned;
        {
            // Add the accumulated fees to the total
            uint256 fee = calculateFee(a);
            fees[u] = fees[u] + fee;

            address[] memory path = new address[](2);
            path[0] = u;
            path[1] = principal;

            // Swap on the Pendle Router using the provided market and params
            returned = IPendle(pendleAddr).swapExactTokensForTokens(
                a - fee,
                r,
                path,
                address(this),
                d
            )[1];
        }

        // Mint Illuminate zero coupons
        IERC5095(principalToken(u, m)).authMint(msg.sender, returned);

        emit Lend(p, u, m, returned, a, msg.sender);
        return returned;
    }

    /// @notice lend method signature for tempus and apwine
    /// @param p value of a specific principal according to the Illuminate Principals Enum
    /// @param u address of an underlying asset
    /// @param m maturity (timestamp) of the market
    /// @param a amount of principal tokens to lend
    /// @param r minimum amount to return when executing the swap (sets a limit to slippage)
    /// @param d deadline is a timestamp by which the swap must be executed
    /// @param x tempus amm that executes the swap
    /// @return uint256 the amount of principal tokens lent out
    function lend(
        uint8 p,
        address u,
        uint256 m,
        uint256 a,
        uint256 r,
        uint256 d,
        address x
    ) external unpaused(p) returns (uint256) {
        address principal = IMarketPlace(marketPlace).token(u, m, p);

        // Transfer funds from user to Illuminate
        Safe.transferFrom(IERC20(u), msg.sender, address(this), a);

        uint256 lent;
        {
            // Add the accumulated fees to the total
            uint256 fee = calculateFee(a);
            fees[u] = fees[u] + fee;

            // Calculate amount to be lent out
            lent = a - fee;
        }

        // Returned holds the amount to mint
        uint256 returned;

        if (p == uint8(MarketPlace.Principals.Tempus)) {
            // Get the starting balance of the principal token
            uint256 start = IERC20(principal).balanceOf(address(this));

            // Swap on the Tempus Router using the provided market and params
            ITempus(tempusAddr).depositAndFix(x, lent, true, r, d);

            // Calculate the amount of tokens received after depositing the user's tokens
            returned = IERC20(principal).balanceOf(address(this)) - start;
        } else if (p == uint8(MarketPlace.Principals.Apwine)) {
            // Get the starting APWine token balance
            uint256 starting = IERC20(IAPWineAMMPool(principal).getPTAddress())
                .balanceOf(address(this));
            // Swap on the APWine Pool using the provided market and params
            returned = IAPWineRouter(x).swapExactAmountIn(
                principal,
                apwinePairPath(),
                apwineTokenPath(),
                lent,
                r,
                address(this),
                d,
                address(0)
            );
            if (
                IERC20(IAPWineAMMPool(principal).getPTAddress()).balanceOf(
                    address(this)
                ) -
                    starting !=
                returned
            ) {
                revert Exception(11, 0, 0, address(0), address(0));
            }
        }

        // Mint Illuminate zero coupons
        IERC5095(principalToken(u, m)).authMint(msg.sender, returned);

        emit Lend(p, u, m, returned, a, msg.sender);
        return returned;
    }

    /// @notice lend method signature for sense
    /// @dev this method can be called before maturity to lend to Sense while minting Illuminate tokens
    /// @dev sense provides a [divider] contract that splits [target] assets (underlying) into PTs and YTs. Each [target] asset has a [series] of contracts, each identifiable by their [maturity].
    /// @param p value of a specific principal according to the Illuminate Principals Enum
    /// @param u address of an underlying asset
    /// @param m maturity (timestamp) of the market
    /// @param a amount of underlying tokens to lend
    /// @param r minimum number of tokens to lend (sets a limit on the order)
    /// @param x amm that is used to conduct the swap
    /// @param s sense's maturity for the given market
    /// @param adapter sense's adapter necessary to facilitate the swap
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
    ) external unpaused(p) returns (uint256) {
        // Get the adapter for this market for this market
        IERC20 token = IERC20(IMarketPlace(marketPlace).token(u, m, p));

        uint256 lent;
        {
            // Determine the fee
            uint256 fee = calculateFee(a);

            // Add the accumulated fees to the total
            fees[u] = fees[u] + fee;

            // Determine lent amount after fees
            lent = a - fee;
        }

        // Transfer funds from user to Illuminate
        Safe.transferFrom(IERC20(u), msg.sender, address(this), a);

        // Stores the amount of principal tokens received in swap for underlying
        uint256 returned;
        {
            // Get the starting balance of the principal token
            uint256 starting = token.balanceOf(address(this));

            // Swap those tokens for the principal tokens
            returned = ISensePeriphery(x).swapUnderlyingForPTs(
                adapter,
                s,
                lent,
                r
            );

            // Verify that we received the principal tokens
            if (token.balanceOf(address(this)) < starting + returned) {
                revert Exception(11, 0, 0, address(0), address(0));
            }
        }

        // Mint the illuminate tokens based on the returned amount
        IERC5095(principalToken(u, m)).authMint(msg.sender, returned);

        emit Lend(p, u, m, returned, a, msg.sender);
        return returned;
    }

    /// @dev lend method signature for Notional
    /// @param p value of a specific principal according to the Illuminate Principals Enum
    /// @param u address of an underlying asset
    /// @param m maturity (timestamp) of the market
    /// @param a amount of underlying tokens to lend
    /// @param r minimum number of principal tokens to receive
    /// @return uint256 the amount of principal tokens lent out
    function lend(
        uint8 p,
        address u,
        uint256 m,
        uint256 a,
        uint256 r
    ) external unpaused(p) returns (uint256) {
        // Instantiate notional princpal token
        INotional token = INotional(IMarketPlace(marketPlace).token(u, m, p));

        // Transfer funds from user to Illuminate
        Safe.transferFrom(IERC20(u), msg.sender, address(this), a);

        // Add the accumulated fees to the total
        uint256 fee = calculateFee(a);
        fees[u] = fees[u] + fee;

        // Swap on the Notional Token wrapper
        uint256 returned = token.deposit(a - fee, address(this));

        if (returned < r) {
            revert Exception(16, returned, r, address(0), address(0));
        }

        // Mint Illuminate zero coupons
        IERC5095(principalToken(u, m)).authMint(msg.sender, returned);

        emit Lend(p, u, m, returned, a, msg.sender);
        return returned;
    }

    /// @notice allows the admin to schedule the withdrawal of tokens
    /// @param e address of (erc20) token to withdraw
    /// @return bool true if successful
    function scheduleWithdrawal(address e)
        external
        authorized(admin)
        returns (bool)
    {
        uint256 when = block.timestamp + HOLD;
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
        delete withdrawals[e];

        emit BlockWithdrawal(e);
        return true;
    }

    /// @notice allows the admin to withdraw the given token, provided the holding period has been observed
    /// @param e Address of token to withdraw
    /// @return bool true if successful
    function withdraw(address e) external authorized(admin) returns (bool) {
        uint256 when = withdrawals[e];
        if (when == 0) {
            revert Exception(18, 0, 0, address(0), address(0));
        }
        if (block.timestamp < when) {
            revert Exception(19, 0, 0, address(0), address(0));
        }

        delete withdrawals[e];
        delete fees[e];

        IERC20 token = IERC20(e);
        Safe.transfer(token, admin, token.balanceOf(address(this)));

        return true;
    }

    /// @notice pauses a market and prevents execution of all lending for that market
    /// @param p principal enum value
    /// @param b bool representing whether to pause or unpause
    /// @return bool true if successful
    function pause(uint8 p, bool b) external authorized(admin) returns (bool) {
        paused[p] = b;
        return true;
    }

    /// @notice transfers excess funds to yield pool after principal tokens have been lent out
    /// @dev this method is only used by the yield, illuminate and swivel protocols
    /// @param u address of an underlying asset
    /// @param y the yield pool to lend to
    /// @param a the amount of underlying tokens to lend
    /// @param r the receiving address for PTs
    /// @param p the principal token for the yield pool
    /// @param m the minimum amount to purchase
    /// @return uint256 the amount of tokens sent to the yield pool
    /// TODO there is a problem with the last check ending - starting (m is passed by user)
    function yield(
        address u,
        address y,
        uint256 a,
        address r,
        address p,
        uint256 m
    ) internal returns (uint256) {
        // get the starting balance (to verify receipt of tokens)
        uint256 starting = IERC20(p).balanceOf(r);
        // preview exact swap slippage on yield
        uint128 returned = IYield(y).sellBasePreview(Cast.u128(a));
        // send the remaining amount to the given yield pool
        Safe.transfer(IERC20(u), y, a);
        // lend out the remaining tokens in the yield pool
        IYield(y).sellBase(r, returned);
        // get thee ending balance (must be starting + returned)
        uint256 ending = IERC20(p).balanceOf(r);
        // verify receipt of PTs from yield space pool
        if (ending - starting < m) {
            revert Exception(12, ending, starting, address(0), address(0));
        }

        return returned;
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

    /// @notice this method returns the fee based on the amount passed to it. If the feenominator is 0, then there is no fee.
    /// @param a amount of underlying tokens
    /// @return uint256 The total for for the given amount
    function calculateFee(uint256 a) internal view returns (uint256) {
        uint256 feeRate = feenominator;
        return feeRate != 0 ? a / feeRate : 0;
    }

    /// @notice verifies fee amount and collects fee for swivel lend calls
    /// @param f fee that is to be held by the lender contract
    /// @param l the amount, in underlying, that is lent to be lent
    /// @param u the underlying asset
    function swivelCheckFee(
        uint256 f,
        uint256 l,
        address u
    ) internal {
        /// Get the minimum fee expected for this call
        uint256 minFee = calculateFee(l);
        // Verify the minimum fee is provided
        if (f < minFee) {
            revert Exception(14, minFee, f, address(0), address(0));
        }
        // Track accumulated fee
        fees[u] = fees[u] + f;
        // Transfer underlying tokens from user to illuminate
        Safe.transferFrom(IERC20(u), msg.sender, address(this), l + f);
    }

    /// @notice lends the leftover premium to a yieldspace pool
    function swivelLendPremium(
        address u,
        uint256 m,
        address y,
        uint256 p,
        uint256 slippageTolerance
    ) internal {
        // Lend remaining funds to yield pool
        uint256 swapped = yield(
            u,
            y,
            p,
            address(this),
            IMarketPlace(marketPlace).token(u, m, 2),
            slippageTolerance
        );
        // Mint the remaining tokens
        IERC5095(principalToken(u, m)).authMint(msg.sender, swapped);
    }

    /// @notice returns the amount of underlying tokens to be used in a swivel lend
    function swivelAmount(uint256[] memory a) internal pure returns (uint256) {
        uint256 lent;
        // iterate through each order a calculate the total lent and returned
        for (uint256 i; i != a.length; ) {
            {
                uint256 amount = a[i];
                // Sum the total amount lent to Swivel
                lent = lent + amount;
            }
            unchecked {
                ++i;
            }
        }
        return lent;
    }

    /// @notice executes a swap for and verifies receipt of element PTs
    function swapElement(
        address e,
        Element.SingleSwap memory s,
        Element.FundManagement memory f,
        uint256 r,
        uint256 d
    ) internal returns (uint256) {
        // Get the starting balance for the principal
        uint256 starting = IERC20(address(s.assetOut)).balanceOf(address(this));
        // Conduct the swap on element
        uint256 purchased = IElementVault(e).swap(s, f, r, d);
        // Calculate amount of PTs received by executing the swap
        uint256 received = IERC20(address(s.assetOut)).balanceOf(
            address(this)
        ) - starting;
        // Verify that a minimum amount was received
        if (received < r) {
            revert Exception(11, 0, 0, address(0), address(0));
        }
        return purchased;
    }

    /// @notice retrieves the ERC5095 token for the given market
    /// @param u address of the underlying
    /// @param m uint256 representing the maturity of the market
    /// @return address of the ERC5095 token for the market
    function principalToken(address u, uint256 m) internal returns (address) {
        return IMarketPlace(marketPlace).token(u, m, 0);
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
}
