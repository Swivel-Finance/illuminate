// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.4;

import './ZcToken.sol';
import "./Interfaces/IPErc20.sol";
import "./Interfaces/IErc2612.sol";
import "./Interfaces/IElementToken.sol";
import "./Interfaces/IYieldToken.sol";
import "./Interfaces/IPendleRouter.sol";
import "./Interfaces/INotionalRouter.sol";
import "./Interfaces/ITempusRouter.sol";
import "./Interfaces/ISwivelRouter.sol";
import "./Interfaces/IYieldPool.sol";
import "./Interfaces/IElementPool.sol";
import "./Interfaces/IAsset.sol";
import "./Utils/CastU256U128.sol";
import "./Utils/SafeTransferLib.sol";

interface ISensePool is IElementPool {
}

interface IAPWineRouter {
     function swapExactAmountIn(uint256 _pairID, uint256 _tokenIn, uint256 _tokenAmountIn, uint256 _tokenOut, uint256 _minAmountOut, address _to) external returns (uint256 tokenAmountOut, uint256 spotPriceAfter);
}

interface ISenseToken is IElementToken {
}

contract Illuminate {

    struct Market {
        address swivel;
        address yield;
        address element;
        address pendle;
        address tempus;
        address notional;
        address sense;
        address apwine;
        address illuminate;
    }

    address public admin;
    address public immutable swivelRouter;
    address public immutable pendleRouter;
    address public immutable tempusRouter;
    address public immutable apwineRouter;

    // Mapping for underlying <-> maturity pairings / market pairs
    mapping (address => mapping (uint256 => Market)) public markets;

    event marketCreated(address indexed underlying, uint256 indexed maturity, address swivel, address yield, address element, address pendle, address tempus, address indexed illuminate);
    event marketPopulated(address indexed underlying, uint256 indexed maturity, address notional);
    event swivelLent(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event swivelMinted(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event swivelRedeemed(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event yieldLent(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event yieldMinted(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event yieldRedeemed(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event elementLent(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event elementMinted(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event elementRedeemed(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event pendleLent(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event pendleMinted(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event pendleRedeemed(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event illuminateLent(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event redeemed(address indexed underlying, uint256 indexed maturity, uint256 amount);


    // @param swivelAddress address of the swivel router
    // @param pendleAddress address of the pendle router
    // @param tempusAddress address of the tempus router
    // @param apwineAddress address of the apwine router
    constructor (address swivelAddress, address pendleAddress, address tempusAddress, address apwineAddress) {
        admin = msg.sender;
        swivelRouter = swivelAddress;
        pendleRouter = pendleAddress;
        tempusRouter = tempusAddress;
        apwineRouter = apwineAddress;
    }

    /// @notice Can be called by the admin to create a new market of associated Swivel, Yield, Element, Pendle and Illuminate zero-coupon tokens (zcTokens, yTokens, PTokens, OTokens, ITokens)
    /// @param underlying the address of the underlying token deposit
    /// @param maturity the maturity of the market, it must be the identical across protocols or within a 1 day buffer
    /// @param swivel the address of the Swivel zcToken
    /// @param yield the address of the Yield yToken
    /// @param element the address of the Element Principal Token
    /// @param pendle the address of the Pendle Ownership Token
    /// @param tempus the address of the Tempus Capital Token
    /// @param name name of the Illuminate IToken
    /// @param decimals the number of decimals in the underlying token
    function createMarket(address underlying, uint256 maturity, address swivel, address yield, address element, address pendle, address tempus, string calldata name, uint8 decimals) public onlyAdmin(admin) returns (bool) {
        
        require(markets[underlying][maturity].illuminate == address(0), 'market already exists');

        markets[underlying][maturity] = Market(swivel, yield, element, pendle, tempus, address(0), address(0), address(0), address(new ZcToken(underlying, maturity, name, name, decimals)));

        emit marketCreated(underlying, maturity, swivel, yield, element, pendle, tempus, markets[underlying][maturity].illuminate);

        return (true);
    }

    /// @notice Can be called by the admin to fill the rest of a new market and associate it with Tempus and Notional zero-coupon tokens (Capital Tokens, nTokens)
    /// @param underlying the address of the underlying token deposit
    /// @param maturity the maturity of the market, it must be the identical across protocols or within a 1 day buffer
    /// @param notional the address of the Yield yToken
    /// @param sense the address of the Sense PT
    /// @param apwine the address of the APWine PT
    function populateMarket(address underlying, uint256 maturity, address notional, address sense, address apwine) public onlyAdmin(admin) returns (bool) {
        
        require(markets[underlying][maturity].notional == address(0), 'market already exists');

        markets[underlying][maturity].notional = notional;

        emit marketPopulated(underlying, maturity, notional);

        return (true);
    }

    /// @notice Can be called before maturity to wrap Swivel zcTokens into Illuminate tokens
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    /// @param amount the amount of underlying tokens to lend   
    function swivelMint(address underlying, uint256 maturity, uint256 amount) public returns (bool) {

        Market memory market = markets[underlying][maturity];

        SafeTransferLib.safeTransferFrom(ERC20(market.swivel), msg.sender, address(this), amount);

        ZcToken(market.illuminate).mint(msg.sender,amount);

        emit swivelMinted(underlying, maturity, amount);

        return (true);
    }

    /// @notice Can be called before maturity to lend to Swivel while minting Illuminate tokens
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    /// @param orders the swivel orders being filled
    /// @param amounts the amount of underlying tokens lent to each order
    function swivelLend(address underlying, uint256 maturity, address yieldPool, Hash.Order[] calldata orders, uint256[] calldata amounts, Sig.Components[] calldata signatures) public returns (uint256) {

        // Instantiate market and tokens       
        ZcToken illuminateToken = ZcToken(markets[underlying][maturity].illuminate);
        ERC20 underlyingToken = ERC20(underlying);
        uint256 totalLent;
        uint256 totalReturned;

        for (uint256 i=0; i < orders.length; i++) {
            Hash.Order memory order = orders[i];
            // Require the Swivel order provided matches the underlying and maturity market provided    
            require(order.maturity == maturity, 'wrong Swivel order maturity');
            require(order.underlying == underlying, 'wrong Swivel order underlying');
            // Sum the total amount lent to Swivel (amount of zcb to mint)
            totalLent += amounts[i];
            // Sum the total amount of premium paid from Swivel (amount of underlying to lend to yield)
            totalReturned += amounts[i] * order.premium / order.principal;
        }

        // Transfer funds from user to Illuminate         
        SafeTransferLib.safeTransferFrom(underlyingToken, msg.sender, address(this), totalLent);
        underlyingToken.approve(swivelRouter, totalLent);

        // Fill orders on Swivel 
        ISwivelRouter(swivelRouter).initiate(orders, amounts, signatures); 

        // Lend the remaining amount to Yield
        uint256 yieldAmount = yieldLend(underlying, maturity, yieldPool, CastU256U128.u128(totalReturned));

        // Mint Illuminate zero coupons
        illuminateToken.mint(msg.sender, (totalLent+yieldAmount));

        emit swivelLent(underlying, maturity, totalLent+yieldAmount);

        return (totalLent+yieldAmount);
    }

    /// @notice Can be called before maturity to wrap Yield yTokens into Illuminate tokens
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    /// @param amount the amount of underlying tokens to lend   
    function yieldMint(address underlying, uint256 maturity, uint256 amount) public returns (bool) {

        Market memory market = markets[underlying][maturity];

        SafeTransferLib.safeTransferFrom(ERC20(market.yield), msg.sender, address(this), amount);

        ZcToken(market.illuminate).mint(msg.sender,amount);

        emit yieldMinted(underlying, maturity, amount);

        return (true);
    }

    /// @notice Can be called before maturity to lend to Yield while minting Illuminate tokens
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    /// @param amount the amount of underlying tokens to lend
    function yieldLend(address underlying, uint256 maturity, address yieldPool, uint128 amount) public returns (uint256) {

        // Instantiate market and tokens
        ERC20 underlyingToken = ERC20(underlying);
        ZcToken illuminateToken = ZcToken(markets[underlying][maturity].illuminate);
        IYieldPool Pool = IYieldPool(yieldPool);

        // Require the Yield pool provided matches the underlying and maturity market provided      
        require(Pool.maturity() == maturity, 'Wrong Yield pool address: maturity');
        require(address(Pool.base()) == underlying, 'Wrong Yield pool address: underlying');

        // Transfer funds from user to Illuminate       
        SafeTransferLib.safeTransferFrom(underlyingToken, msg.sender, address(this), amount);
        underlyingToken.approve(yieldPool, 2**256 - 1);

        // Preview exact swap slippage on YieldSpace pool
        uint128 returned = Pool.sellBasePreview(amount);

        // Transfer funds to Yieldspace pool        
        SafeTransferLib.safeTransfer(underlyingToken, yieldPool, amount);

        // "Sell Base" meaning purchase the zero coupons from YieldSpace pool
        Pool.sellBase(address(this), returned);

        // Mint Illuminate zero coupons
        illuminateToken.mint(msg.sender, returned);

        emit yieldLent(underlying, maturity, returned);

        return (returned);
    }

    /// @notice Can be called before maturity to wrap Element PT's into Illuminate tokens
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    /// @param amount the amount of underlying tokens to lend   
    function elementMint(address underlying, uint256 maturity, uint256 amount) public returns (bool) {

        Market memory market = markets[underlying][maturity];

        SafeTransferLib.safeTransferFrom(ERC20(market.element), msg.sender, address(this), amount);

        ZcToken(market.illuminate).mint(msg.sender,amount);

        emit elementMinted(underlying, maturity, amount);

        return (true);
    }

    /// @notice Can be called before maturity to lend to Element while minting Illuminate tokens
    /// @param elementPool the underlying token being redeemed
    /// @param poolID the balancer poolID for the principal token
    /// @param amount the amount of underlying tokens to lend
    /// @param minimumBought the minimum amount of zero-coupon tokens to return accounting for slippage
    /// @param deadline the maximum timestamp at which the transaction can be executed
    function elementLend(address underlying, uint256 maturity, address elementPool, bytes32 poolID, uint128 amount, uint256 minimumBought, uint256 deadline) public returns(uint256){

        // Instantiate market and tokens
        Market memory market = markets[underlying][maturity];
        ERC20 underlyingToken = ERC20(underlying);
        IElementToken elementToken = IElementToken(market.element);

        // Require the Element pool provided matches the underlying and maturity market provided
        require(elementToken.unlockTimestamp() == maturity, 'Wrong Element pool address: maturity');
        require(address(elementToken.underlying()) == underlying, 'Wrong Element pool address: underlying');

        // Transfer funds from user to Illuminate
        SafeTransferLib.safeTransferFrom(underlyingToken, msg.sender, address(this), amount);
        underlyingToken.approve(elementPool, 2**256 - 1);

        // Populate Balancer structs for a "SingleSwap"
        IElementPool Pool = IElementPool(elementPool);
        IElementPool.FundManagement memory _fundManagement = IElementPool.FundManagement({
            sender: address(this),
            fromInternalBalance: false,
            recipient: payable(address(this)),
            toInternalBalance: false
        });
        IElementPool.SingleSwap memory _singleSwap = IElementPool.SingleSwap({
            poolId: poolID,
            kind: IElementPool.SwapKind(0),
            assetIn: IAsset(underlying),
            assetOut: IAsset(market.element),
            amount: amount,
            userData: "0x00000000000000000000000000000000000000000000000000000000000000"
        });

        // Swap on the Balancer pool using the provided structs and params
        uint256 returned = Pool.swap(_singleSwap, _fundManagement, minimumBought, deadline);

        // Scope instantiation to avoid stack limit and mint Illuminate zero coupons
        {
        ZcToken illuminateToken = ZcToken(market.illuminate);
        illuminateToken.mint(msg.sender, returned);
        }

        emit elementLent(underlying, maturity, returned);

        return (returned);
    }

    /// @notice Can be called before maturity to wrap Pendle Ownership Tokens into Illuminate tokens
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    /// @param amount the amount of underlying tokens to lend   
    function pendleMint(address underlying, uint256 maturity, uint256 amount) public returns (bool) {

        Market memory market = markets[underlying][maturity];

        SafeTransferLib.safeTransferFrom(ERC20(market.pendle), msg.sender, address(this), amount);

        ZcToken(market.illuminate).mint(msg.sender,amount);

        emit pendleMinted(underlying, maturity, amount);

        return (true);
    }

    /// @notice Can be called before maturity to lend to Pendle while minting Illuminate tokens
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    /// @param amount the amount of underlying tokens to lend
    /// @param minimumAmount the minimum amount of zero-coupon tokens to return accounting for slippage
    /// @param pendleId the maximum timestamp at which the transaction can be executed
    function PendleLend(address underlying, uint256 maturity, uint256 amount, uint256 minimumAmount, bytes32 pendleId) public returns (uint256) {

        // Instantiate market and tokens
        Market memory market = markets[underlying][maturity];
        ERC20 underlyingToken = ERC20(underlying);
        IPendleRouter Router = IPendleRouter(pendleRouter);
        ZcToken illuminateToken = ZcToken(market.illuminate);

        // Transfer funds from user to Illuminate    
        SafeTransferLib.safeTransferFrom(underlyingToken, msg.sender, address(this), amount);   
        underlyingToken.approve(pendleRouter, 2**256 - 1);

        // Swap on the Pendle Router using the provided market and params
        uint256 returned = Router.swapExactIn(underlying, market.pendle, amount, minimumAmount, pendleId);

        // Mint Illuminate zero coupons
        illuminateToken.mint(msg.sender, returned);

        emit pendleLent(underlying, maturity, returned);

        return (returned);
    }

    /// @notice Can be called before maturity to lend to the Illuminate AMM directly without needing approvals to it
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    /// @param amount the amount of underlying tokens to lend
    function illuminateLend(address underlying, uint256 maturity, address illuminatePool, uint128 amount) public returns (uint256) {

        // Instantiate market and tokens
        ERC20 underlyingToken = ERC20(underlying);
        IYieldPool Pool = IYieldPool(illuminatePool);
 
        // Require the Yield pool provided matches the underlying and maturity market provided      
        require(Pool.maturity() == maturity, 'Wrong Illuminate pool address: maturity');
        require(address(Pool.base()) == underlying, 'Wrong Illuminate pool address: underlying');

        // Transfer funds from user to Illuminate      
        SafeTransferLib.safeTransferFrom(underlyingToken, msg.sender, address(this), amount); 
        underlyingToken.approve(illuminatePool, 2**256 - 1);

        // Preview exact swap slippage on YieldSpace pool
        uint128 returned = Pool.sellBasePreview(amount);

        // Transfer funds to Yieldspace pool        
        SafeTransferLib.safeTransfer(underlyingToken, illuminatePool, amount);

        // "Sell Base" meaning purchase the zero coupons from YieldSpace pool
        Pool.sellBase(msg.sender, returned);

        emit illuminateLent(underlying, maturity, returned);

        return (returned);
    }

    /// @notice Can be called after maturity and after tokens have been redeemed to Illuminate to redeem underlying tokens 
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    function redeem(address underlying, uint256 maturity) public returns (bool) {

        IZcToken illuminateToken = IZcToken(markets[underlying][maturity].illuminate);
        ERC20 underlyingToken = ERC20(underlying);

        uint256 amount = illuminateToken.balanceOf(msg.sender);

        require(illuminateToken.burn(msg.sender, amount), "Illuminate token burn failed");

        SafeTransferLib.safeTransfer(underlyingToken, msg.sender, amount);

        emit redeemed(underlying, maturity, amount);

        return (true);
    }
    
    /// @notice called at maturity to redeem all Swivel zcTokens to Illuminate
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    function swivelRedeem(address underlying, uint256 maturity) public returns (bool) {

        uint256 amount = IZcToken(markets[underlying][maturity].swivel).balanceOf(address(this));

        require(ISwivelRouter(swivelRouter).redeemZcToken(underlying,maturity,amount), "Swivel redemption failed");

        emit swivelRedeemed(underlying, maturity, amount);

        return (true);
    }

    /// @notice called at maturity to redeem all Yield yTokens to Illuminate
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed    
    function yieldRedeem(address underlying, uint256 maturity) public returns (bool) {

        IYieldToken yieldToken = IYieldToken(markets[underlying][maturity].illuminate);

        uint256 amount = yieldToken.balanceOf(address(this));

        require(yieldToken.redeem(address(this), address(this), amount) >= amount, "Yield redemption failed");

        emit yieldRedeemed(underlying, maturity, amount);

        return (true);
    }

    /// @notice called at maturity to redeem all Element PT's to Illuminate
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed    
    function elementRedeem(address underlying, uint256 maturity) public returns (bool) {

        IElementToken elementToken = IElementToken(markets[underlying][maturity].element);

        uint256 amount = elementToken.balanceOf(address(this));

        require(elementToken.withdrawPrincipal(amount, address(this)) >= amount, "Element redemption failed");

        emit elementRedeemed(underlying, maturity, amount);

        return (true);
    } 

    /// @notice called at maturity to redeem all Pendle PT's to Illuminate
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    /// @param forgeId the Pendle forge ID for the given underyling and maturity market pair
    function pendleRedeem(address underlying, uint256 maturity, bytes32 forgeId) public returns (bool) {

        PErc20 pendleToken = PErc20(markets[underlying][maturity].pendle);
        IPendleRouter Router = IPendleRouter(pendleRouter);

        uint256 amount = pendleToken.balanceOf(address(this));

        require(Router.redeemAfterExpiry(forgeId, underlying, maturity) >= amount, "Pendle redemption failed");

        emit pendleRedeemed(underlying, maturity, amount);

        return (true);
    }

    modifier onlyAdmin(address a) {
        require(msg.sender == admin, 'sender must be admin');
        _;
  }
}