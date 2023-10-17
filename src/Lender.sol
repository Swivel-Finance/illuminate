// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.20;

import "./lib/Swivel.sol";
import "./lib/Pendle.sol";
import "./lib/Element.sol";
import "./lib/Safe.sol";
import "./lib/Cast.sol";
import "./lib/RevertMsgExtractor.sol";
import "./lib/Maturities.sol";
import "./errors/Exception.sol";

import "./interfaces/IERC20.sol";
import "./interfaces/IERC5095.sol";
import "./interfaces/IYield.sol";
import "./interfaces/IElementVault.sol";
import "./interfaces/IETHWrapper.sol";
import "./interfaces/IMarketPlace.sol";

/// @title Lender
/// @author Sourabh Marathe, Julian Traversa, Rob Robbins
/// @notice The lender contract executes loans on behalf of users
/// @notice The contract holds the principal tokens and mints an ERC-5095 tokens to users to represent their loans
contract Lender {

    address public lender = address(this); 

    address public marketplace;

    address public redeemer;

    /// @notice minimum wait before the admin may withdraw funds or change the fee rate
    uint256 public constant hold = 3 days;

    /// @notice address that is allowed to set and withdraw fees, disable principals, etc. It is commonly used in the authorized modifier.
    address public admin;
    /// @notice mapping that determines if a principal has been paused by the admin
    mapping(uint8 => bool) public paused;
    /// @notice flag that allows admin to stop all lending and minting across the entire protocol
    bool public halted;
    /// @notice address on which ETH swaps are conducted to purchase LSTs
    address public ETHWrapper;
    /// @notice WETH address
    address public immutable WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    error TestException(address, address, uint256, uint256, string);

    /// @notice protocol specific addresses that adapters reference when executing lends
    /// @dev these addresses are references by an implied enum; adapters hardcode the index for their protocol
    address[] public protocolRouters;

    /// @notice this value determines the amount of fees paid on loans
    uint256 public feenominator;
    /// @notice represents a point in time where the feenominator may change
    uint256 public feeChange;
    /// @notice represents a minimum that the feenominator must exceed
    uint256 public constant minimumFeenominator = 500;

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
    uint256 public maximumValue = 250_000e27;
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
    constructor(address s, address p, address a) {
        admin = msg.sender;
        protocolRouters.push(s);
        protocolRouters.push(p);
        protocolRouters.push(a);
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
            address token = IMarketPlace(marketplace).markets(u, m).tokens[i];
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
        return (true);
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

    /// @notice sets the ETHWrapper address
    /// @param a address of the ETHWrapper contract
    /// @return bool true if successful
    function setETHWrapper(address a) external authorized(admin) returns (bool) {
        ETHWrapper = a;
        return (true);
    }

    /// @notice sets the admin address
    /// @param a address of a new admin
    /// @return bool true if successful
    function setAdmin(address a) external authorized(admin) returns (bool) {
        admin = a;
        emit SetAdmin(a);
        return (true);
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
        } else if (f < minimumFeenominator) {
            revert Exception(25, 0, 0, address(0), address(0));
        }
        feenominator = f;
        delete feeChange;
        emit SetFee(f);
        return (true);
    }

    // @notice sets the redeemer address
    // @param r address of a new redeemer
    // @return bool true if successful
    function setRedeemer(address r) external authorized(admin) returns (bool) {
        redeemer = r;
        return (true);
    }

    /// @notice sets the address of the marketplace contract which contains the addresses of all the fixed rate markets
    /// @param m the address of the marketplace contract
    /// @return bool true if the address was set
    function setMarketPlace(
        address m
    ) external authorized(admin) returns (bool) {
        if (marketplace != address(0)) {
            revert Exception(5, 0, 0, marketplace, address(0));
        }
        marketplace = m;
        return (true);
    }

    /// @notice sets the ethereum price which is used in rate limiting
    /// @param p the new price
    /// @return bool true if the price was set
    function setEtherPrice(
        uint256 p
    ) external authorized(admin) returns (bool) {
        etherPrice = p;
        return (true);
    }

    /// @notice sets the maximum value that can flow through a protocol
    /// @param m the maximum value by protocol
    /// @return bool true if the price was set
    function setMaxValue(uint256 m) external authorized(admin) returns (bool) {
        maximumValue = m;
        return (true);
    }

    /// @notice allows the admin to schedule the withdrawal of tokens
    /// @param e address of (erc20) token to withdraw
    /// @return bool true if successful
    function scheduleWithdrawal(
        address e
    ) external authorized(admin) returns (bool) {
        // Calculate the timestamp that must be passed prior to withdrawal
        uint256 when = block.timestamp + hold;

        // Set the timestamp threshold for the token being withdrawn
        withdrawals[e] = when;

        emit ScheduleWithdrawal(e, when);
        return (true);
    }

    /// @notice emergency function to block unplanned withdrawals
    /// @param e address of token withdrawal to block
    /// @return bool true if successful
    function blockWithdrawal(
        address e
    ) external authorized(admin) returns (bool) {
        // Resets threshold to 0 for the token, stopping withdrawl of the token
        delete withdrawals[e];

        emit BlockWithdrawal(e);
        return (true);
    }

    /// @notice allows the admin to schedule a change to the fee denominators
    function scheduleFeeChange() external authorized(admin) returns (bool) {
        // Calculate the timestamp that must be passed prior to setting thew new fee
        uint256 when = block.timestamp + hold;

        // Store the timestamp that must be passed to update the fee rate
        feeChange = when;

        emit ScheduleFeeChange(when);
        return (true);
    }

    /// @notice Emergency function to block unplanned changes to fee structure
    function blockFeeChange() external authorized(admin) returns (bool) {
        // Resets threshold to 0 for the token, stopping the scheduling of a fee rate change
        delete feeChange;

        emit BlockFeeChange();
        return (true);
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

        return (true);
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

        if (e == WETH) {
            // transfer eth
            payable(admin).transfer(address(this).balance);
        }
        
        // Transfer the accumulated fees to the admin
        Safe.transfer(token, admin, balance);

        return (true);
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
        return (true);
    }

    /// @notice allows admin to add a protocol contract for reference by adapters
    /// @param r address of a new protocol contract
    function addRouter(address r) external authorized(admin) {
        protocolRouters.push(r);
    }

    /// @notice allows admin to change the router contract for reference by adapters
    function setRouter(address r, uint256 i) external authorized(admin) {
        protocolRouters[i] = r;
    }

    /// @notice Tranfers FYTs to Redeemer (used specifically for APWine redemptions)
    /// @param f FYT contract address
    /// @param a amount of tokens to send to the redeemer
    function transferFYTs(
        address f,
        uint256 a
    ) external authorized(IMarketPlace(marketplace).redeemer()) {
        // Transfer the Lender's FYT tokens to the Redeemer
        Safe.transfer(IERC20(f), IMarketPlace(marketplace).redeemer(), a);
    }

    /// @notice Transfers premium from the market to Redeemer (used specifically for Swivel redemptions)
    /// @param u address of an underlying asset
    /// @param m maturity (timestamp) of the market
    function transferPremium(
        address u,
        uint256 m
    ) external authorized(IMarketPlace(marketplace).redeemer()) {
        Safe.transfer(
            IERC20(u),
            IMarketPlace(marketplace).redeemer(),
            IERC20(u).balanceOf(address(this))- fees[u]
        );
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
        address principal = IMarketPlace(marketplace).markets(u, m).tokens[p];

        // Disallow mints if market is not initialized
        if (principal == address(0)) {
            revert Exception(26, 0, 0, address(0), address(0));
        }

        // Get the maturity of the principal token
        uint256 maturity;
        if (p == uint8(IMarketPlace.Principals.Illuminate)) {
            revert Exception(32, 0, 0, address(0), address(0));
        } else if (p == uint8(IMarketPlace.Principals.Swivel)) {
            maturity = Maturities.swivel(principal);
        } else if (p == uint8(IMarketPlace.Principals.Yield)) {
            maturity = Maturities.yield(principal);
        } else if (p == uint8(IMarketPlace.Principals.Element)) {
            maturity = Maturities.element(principal);
        } else if (p == uint8(IMarketPlace.Principals.Pendle)) {
            maturity = Maturities.pendle(principal);
        } else if (p == uint8(IMarketPlace.Principals.Tempus)) {
            maturity = Maturities.tempus(principal);
        } else if (p == uint8(IMarketPlace.Principals.Apwine)) {
            maturity = Maturities.apwine(principal);
        } else if (p == uint8(IMarketPlace.Principals.Notional)) {
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

        return (true);
    }

    /// @notice Allows users to lend underlying asset for Illuminate PTs via an approved protocol
    /// @param p principal value according to the MarketPlace's Principals Enum
    /// @param u underlying asset address of the market's tuple
    /// @param m timestamp of maturity of the market's tuple
    /// @param a amount of underlying to lend (an array is used for Swivel lends, [0] is the amount for other cases)
    /// @param d data to conduct the call -- For explicit information see a respective adapter's `lendABI` returns
    function lend(
        uint8 p,
        address u,
        uint256 m,
        uint256[] memory a,
        bytes calldata d
    ) external returns (uint256) {

        // Initialize _Market
        IMarketPlace.Market memory _Market = IMarketPlace(marketplace).markets(u, m);

        // Conduct the lend operation to acquire principal tokens
        (bool success, bytes memory returndata) = IMarketPlace(marketplace).adapters(p).delegatecall(
            abi.encodeWithSignature('lend(uint256[],bool,bytes)', a, false, d));

        if (!success) {
            revert Exception(0, 0, 0, address(0), address(0)); // TODO: assign exception
        }

        // Get the amount of PTs (in protocol decimals) received
        (uint256 obtained, uint256 spent, uint256 fee) = abi.decode(
            returndata,
            (uint256, uint256, uint256)
        );

        fees[u] += fee;

        // Convert decimals from principal token to underlying
        uint256 returned = convertDecimals(u, _Market.tokens[p], obtained);

        // Mint Illuminate PTs to msg.sender
        IERC5095(principalToken(u, m)).authMint(msg.sender, returned);
        emit Lend(p, u, m, returned, spent, msg.sender);
        return (returned);
    }

    // An override lend method for all ETH lending with the additional lpt and swap parameters
    // This method is only used for lending to ETH markets
    /// @param p principal value according to the MarketPlace's Principals Enum
    /// @param u underlying asset address of the market's tuple
    /// @param m timestamp of maturity of the market's tuple
    /// @param a amount of underlying to lend (an array is used for Swivel lends, [0] is the amount for other cases)
    /// @param d data to conduct the call -- For explicit information see a respective adapter's `lendABI` returns
    /// @param lst address of the token to swap to
    /// @param swapMinimum minimum amount of lst to receive
    function lend(
        uint8 p,
        address u,
        uint256 m,
        uint256[] memory a,
        bytes calldata d,
        address lst,
        uint256 swapMinimum
    ) external payable returns (uint256) {
        IMarketPlace.Market memory _Market = IMarketPlace(marketplace).markets(u, m);
        uint256 spent;
        bool success;
        bytes memory returndata;

        // If the lst parameter is not populated, a swap is not required
        if (lst == address(0)) {
            // Conduct the lend operation to acquire principal tokens
            (success, returndata) = IMarketPlace(marketplace).adapters(p).delegatecall(
                abi.encodeWithSignature('lend(uint256[],bool,bytes)', a, false, d));
        }
        // If the lst parameter is populated, swap into the requested lst
        else {
            // If the protocol is Swivel, adjust the lent amounts according to the slippageRatio
            if (p == uint8(IMarketPlace.Principals.Swivel)) {
                // Sum the amounts to be spent
                uint256 total;
                for (uint256 i; i != a.length; ) {
                    total += a[i];
                    unchecked {
                        ++i;
                    }
                }
                spent = total;
                require (msg.value >= total, 'Insufficient ETH');
                (, uint256 slippageRatio) = swapETH(lst, total, swapMinimum);
                a = adjustSwivelAmounts(a, slippageRatio);
            }
            // If the protocol is not Swivel, swap the input `a[0]` and overwrite a[0] with the returned lend amount
            else {
                (uint256 lent, ) = swapETH(lst, a[0], swapMinimum);
                spent = a[0];
                a[0] = lent;
                require (msg.value >= spent, 'Insufficient ETH');
            }
            // Conduct the lend operation to acquire principal tokens
            (success, returndata) = IMarketPlace(marketplace).adapters(p).delegatecall(
                abi.encodeWithSignature('lend(uint256[],bool,bytes)', a, true, d));
        }
        
        if (!success) {
            revert Exception(0, 0, 0, address(0), address(0)); // TODO: assign exception
        }

        // Get the amount of PTs (in protocol decimals) received
        (uint256 obtained, ,uint256 fee) = abi.decode(
            returndata,
            (uint256, uint256, uint256)
        );

        fees[u] += fee;

        // Convert decimals from principal token to underlying
        uint256 returned = convertDecimals(u, _Market.tokens[p], obtained);

        // Mint Illuminate PTs to msg.sender
        IERC5095(principalToken(u, m)).authMint(msg.sender, returned);
        emit Lend(p, u, m, returned, spent, msg.sender);
        return (returned);
    }

    // @notice: Adjusts all Swivel Amounts according to the slippageRatio
    // @param amounts: The amounts to adjust
    // @param slippageRatio: The slippageRatio to adjust by
    // @returns The adjusted amount array
    function adjustSwivelAmounts(uint256[] memory amounts, uint256 slippageRatio) internal pure returns (uint256[] memory) {
        for (uint256 i; i != amounts.length; ) {
            amounts[i] = amounts[i] - amounts[i] / slippageRatio;
            unchecked {
                ++i;
            }
        }
        return (amounts);
    }

    // @notice: Handles all necessary ETH swaps when lending
    // @param lst: The address of the token to swap to
    // @param amount: The amount of underlying to spend
    // @param swapMinimum: The minimum amount of lst to receive
    // @returns lent: The amount of underlying to be lent
    // @returns slippageRatio: The slippageRatio of the swap (1e18 based % to adjust swivel orders if necessary)
    function swapETH(address lst, uint256 amount, uint256 swapMinimum) internal returns (uint256 lent, uint256 slippageRatio) {
        payable(ETHWrapper).transfer(amount);
        if (lst != address(0)) {
            (lent, slippageRatio)  = IETHWrapper(ETHWrapper).swap(WETH, lst, amount, swapMinimum);
            return (lent, slippageRatio);
        }
        // If the `lst` address is blank, no swap is necessary
        else {
            return (amount, 1);
        }
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

    /// @notice returns array token path required for APWine's swap method
    /// @return array of uint256[] as laid out in APWine's docs
    function apwineTokenPath() internal pure returns (uint256[] memory) {
        uint256[] memory tokenPath = new uint256[](2);
        tokenPath[0] = 1;
        tokenPath[1] = 0;
        return (tokenPath);
    }

    /// @notice returns array pair path required for APWine's swap method
    /// @return array of uint256[] as laid out in APWine's docs
    function apwinePairPath() internal pure returns (uint256[] memory) {
        uint256[] memory pairPath = new uint256[](1);
        pairPath[0] = 0;
        return (pairPath);
    }

    /// @notice retrieves the ERC5095 token for the given market
    /// @param u address of an underlying asset
    /// @param m maturity (timestamp) of the market
    /// @return address of the ERC5095 token for the market
    function principalToken(address u, uint256 m) internal returns (address) {
        return (IMarketPlace(marketplace).markets(u, m).tokens[uint8(IMarketPlace.Principals.Illuminate)]);
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
            return a * 10 ** (underlyingDecimals - principalDecimals);
        }
        return (a / 10 ** (principalDecimals - underlyingDecimals));
    }

    /// @notice limits the amount of funds (in USD value) that can flow through a principal in a day
    /// @param p principal value according to the MarketPlace's Principals Enum
    /// @param u address of an underlying asset
    /// @param a amount being minted which is normalized to 18 decimals prior to check
    /// @return bool true if successful, reverts otherwise
    function rateLimit(uint8 p, address u, uint256 a) internal returns (bool) {
        // Get amount in USD to be minted
        uint256 valueToMint = a;

        // In case of stETH, we will calculate an approximate USD value
        // 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2 (WETH address)
        if (u == 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2) {
            valueToMint = etherPrice * valueToMint;
        }

        // Normalize the value to be minted to 27 decimals
        valueToMint = valueToMint * 10 ** (27 - IERC20(u).decimals());

        // Cache max value
        uint256 maxValue = maximumValue;

        // Transactions of greater than the max value of USD are rate limited
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
        // If more than the max USD has flowed through the protocol, revert
        else if (flow > maxValue) {
            revert Exception(31, protocolFlow[p], p, address(0), address(0));
        }

        return (true);
    }
}
