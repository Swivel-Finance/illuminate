// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.4;

import "./ZcToken.sol";
import "./Interfaces/IPErc20.sol";
import "./Interfaces/IErc2612.sol";
import "./Interfaces/IElementToken.sol";
import "./Interfaces/IYieldToken.sol";
import "./Interfaces/IPendleRouter.sol";
import "./Interfaces/INotionalRouter.sol";
import "./Interfaces/ITempusRouter.sol";
import "./Interfaces/ISwivelRouter.sol";
import "./Interfaces/IAPWineRouter.sol";
import "./Interfaces/ISenseDivider.sol";
import "./Interfaces/IAPWineVault.sol";
import "./Interfaces/IYieldPool.sol";
import "./Interfaces/IElementPool.sol";
import "./Interfaces/ISensePool.sol";
import "./Interfaces/IAPWinePool.sol";
import "./Interfaces/IAsset.sol";
import "./Utils/CastU256U128.sol";
import "./Utils/SafeTransferLib.sol";

contract Illuminate {

    // TODO 
    // APWINE Deposits / Redeems
    // Notional Deposits / Redeems
    // -----------------------------
    // Once Stack too deep fixed in 8.13:
    // Combine create & populate market
    // Remove scoping and add a returned var to tempusLend
    // COMPLETE:
    // Element: Mint/Lend/Redeem Tested: Mint/Lend
    // Yield: Mint/Lend/Redeem Tested: Mint/Lend
    // Swivel: Mint/Lend/Redeem Tested: Mint/Lend
    // Sense(Element Fork): Mint/Lend/Redeem 
    // Pendle: Mint/Lend/Redeem 
    // Tempus: Mint/Lend/Redeem
    // Notional:
    // APWINE: Mint/Lend/Redeem
    // Illuminate(AMM): Lend Tested: Lend
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
    event marketPopulated(address indexed underlying, uint256 indexed maturity, address notional, address sense, address apwine);
    event swivelLent(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event swivelMinted(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event swivelRedeemed(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event yieldLent(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event yieldMinted(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event yieldRedeemed(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event elementLent(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event elementMinted(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event elementRedeemed(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event senseLent(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event senseMinted(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event senseRedeemed(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event pendleLent(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event pendleMinted(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event pendleRedeemed(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event tempusLent(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event tempusMinted(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event tempusRedeemed(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event APWineLent(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event APWineMinted(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event APWineRedeemed(address indexed underlying, uint256 indexed maturity, uint256 amount);
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

        Market memory market = markets[underlying][maturity];
    
        market.notional = notional;
        market.sense = sense;
        market.apwine = apwine;

        markets[underlying][maturity] = market;

        emit marketPopulated(underlying, maturity, notional, sense, apwine);

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
    /// @param signatures the signatures associated with each order
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
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
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

    /// @notice Can be called before maturity to wrap Sense PT's into Illuminate tokens
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    /// @param amount the amount of underlying tokens to lend   
    function senseMint(address underlying, uint256 maturity, uint256 amount) public returns (bool) {

        Market memory market = markets[underlying][maturity];

        SafeTransferLib.safeTransferFrom(ERC20(market.sense), msg.sender, address(this), amount);

        ZcToken(market.sense).mint(msg.sender,amount);

        emit senseMinted(underlying, maturity, amount);

        return (true);
    }

    /// @notice Can be called before maturity to lend to Sense while minting Illuminate tokens
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    /// @param sensePool the underlying token being redeemed
    /// @param senseAdapter the address of the Sense "Adapter" for a given maturity/asset market (unsure what "adapter" means 100%)
    /// @param amount the amount of underlying tokens to lend
    /// @param minimumBought the minimum amount of zero-coupon tokens to return accounting for slippage
    function senseLend(address underlying, uint256 maturity, address sensePool, address senseAdapter, uint128 amount, uint256 minimumBought) public returns(uint256){

        // Instantiate market and tokens
        Market memory market = markets[underlying][maturity];
        ERC20 underlyingToken = ERC20(underlying);

        // Transfer funds from user to Illuminate
        SafeTransferLib.safeTransferFrom(underlyingToken, msg.sender, address(this), amount);

        uint256 returned = ISensePool(sensePool).swapUnderlyingForPTs(senseAdapter, maturity, amount, minimumBought);

        ZcToken illuminateToken = ZcToken(market.illuminate);
        illuminateToken.mint(msg.sender, returned);

        emit senseLent(underlying, maturity, returned);

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
    /// @param pendleId the id of the given pendle market in bytes32
    function pendleLend(address underlying, uint256 maturity, uint256 amount, uint256 minimumAmount, bytes32 pendleId) public returns (uint256) {

        // Instantiate market and tokens
        Market memory market = markets[underlying][maturity];
        ERC20 underlyingToken = ERC20(underlying);
        IPendleRouter Router = IPendleRouter(pendleRouter);
        ZcToken illuminateToken = ZcToken(market.illuminate);

        // Transfer funds from user to Illuminate    
        SafeTransferLib.safeTransferFrom(underlyingToken, msg.sender, address(this), amount);   

        // Swap on the Pendle Router using the provided market and params
        uint256 returned = Router.swapExactIn(underlying, market.pendle, amount, minimumAmount, pendleId);

        // Mint Illuminate zero coupons
        illuminateToken.mint(msg.sender, returned);

        emit pendleLent(underlying, maturity, returned);

        return (returned);
    }

    /// @notice Can be called before maturity to wrap APWine PTs into Illuminate tokens
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    /// @param amount the amount of underlying tokens to lend   
    function APWineMint(address underlying, uint256 maturity, uint256 amount) public returns (bool) {

        Market memory market = markets[underlying][maturity];

        SafeTransferLib.safeTransferFrom(ERC20(market.apwine), msg.sender, address(this), amount);

        ZcToken(market.illuminate).mint(msg.sender,amount);

        emit APWineMinted(underlying, maturity, amount);

        return (true);
    }

    /// @notice Can be called before maturity to lend to APWine while minting Illuminate tokens
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    /// @param amount the amount of underlying tokens to lend
    /// @param minimumAmount the minimum amount of zero-coupon tokens to return accounting for slippage
    /// @param APWinePool the address of a given APWine pool
    function APWineLend(address underlying, uint256 maturity, uint256 amount, uint256 minimumAmount, address APWinePool, uint256 pairId) public returns (uint256) {

        // Instantiate market and tokens
        Market memory market = markets[underlying][maturity];
        ERC20 underlyingToken = ERC20(underlying);
        IAPWinePool Pool = IAPWinePool(APWinePool);
        ZcToken illuminateToken = ZcToken(market.illuminate);

        // Transfer funds from user to Illuminate    
        SafeTransferLib.safeTransferFrom(underlyingToken, msg.sender, address(this), amount);   

        // Swap on the APWine Pool using the provided market and params
        (uint256 returned,) = Pool.swapExactAmountIn(pairId, 1, amount, 0, minimumAmount, address(this));

        // Mint Illuminate zero coupons
        illuminateToken.mint(msg.sender, returned);

        emit APWineLent(underlying, maturity, returned);

        return (returned);
    }

    /// @notice Can be called before maturity to wrap APWine PTs into Illuminate tokens
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    /// @param amount the amount of underlying tokens to lend   
    function tempusMint(address underlying, uint256 maturity, uint256 amount) public returns (bool) {

        Market memory market = markets[underlying][maturity];

        SafeTransferLib.safeTransferFrom(ERC20(market.tempus), msg.sender, address(this), amount);

        ZcToken(market.illuminate).mint(msg.sender, amount);

        emit tempusMinted(underlying, maturity, amount);

        return (true);
    }

    /// @notice Can be called before maturity to lend to APWine while minting Illuminate tokens
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    /// @param amount the amount of underlying tokens to lend
    /// @param minimumRate the minimum amount of zero-coupon tokens to return accounting for slippage
    /// @param tempusAMM the address of the generalized APWine amm
    /// @param tempusPool the address of a given APWine pool
    /// @param deadline the maximum timestamp at which the transaction can be executed
    function tempusLend(address underlying, uint256 maturity, uint256 amount, uint256 minimumRate, address tempusAMM, address tempusPool, uint256 deadline) public returns (uint256) {

        // Instantiate market and tokens
        Market memory market = markets[underlying][maturity];
        ITempusRouter Router = ITempusRouter(tempusRouter);

        // Transfer funds from user to Illuminate, Scope to avoid stack limit
        {
        ERC20 underlyingToken = ERC20(underlying);
        SafeTransferLib.safeTransferFrom(underlyingToken, msg.sender, address(this), amount);   
        }
        // Read balance before swap to calculate difference
        uint256 starting = IZcToken(market.tempus).balanceOf(address(this));

        // Swap on the Tempus Router using the provided market and params
        uint256 returned = (Router.depositAndFix(ITempusAMM(tempusAMM), ITempusPool(tempusPool), amount, true, minimumRate, deadline) - starting);

        // Mint Illuminate zero coupons
        {
        ZcToken illuminateToken = ZcToken(market.illuminate);
        illuminateToken.mint(msg.sender, returned);
        }

        emit tempusLent(underlying, maturity, returned);

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
    /// @param amount the amount of underlying tokens to redeem and Illuminate tokens to burn
    function redeem(address underlying, uint256 maturity, uint256 amount) public returns (bool) {

        IZcToken illuminateToken = IZcToken(markets[underlying][maturity].illuminate);
        ERC20 underlyingToken = ERC20(underlying);

        illuminateToken.burn(msg.sender, amount);

        SafeTransferLib.safeTransfer(underlyingToken, msg.sender, amount);

        emit redeemed(underlying, maturity, amount);

        return (true);
    }
    
    /// @notice called at maturity to redeem all Swivel zcTokens to Illuminate
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    function swivelRedeem(address underlying, uint256 maturity) public returns (bool) {

        uint256 amount = IZcToken(markets[underlying][maturity].swivel).balanceOf(address(this));

        ISwivelRouter(swivelRouter).redeemZcToken(underlying,maturity,amount);

        emit swivelRedeemed(underlying, maturity, amount);

        return (true);
    }

    /// @notice called at maturity to redeem all Yield yTokens to Illuminate
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed    
    function yieldRedeem(address underlying, uint256 maturity) public returns (bool) {

        IYieldToken yieldToken = IYieldToken(markets[underlying][maturity].illuminate);

        uint256 amount = yieldToken.balanceOf(address(this));

        yieldToken.redeem(address(this), address(this), amount);

        emit yieldRedeemed(underlying, maturity, amount);

        return (true);
    }

    /// @notice called at maturity to redeem all Element PT's to Illuminate
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed    
    function elementRedeem(address underlying, uint256 maturity) public returns (bool) {

        IElementToken elementToken = IElementToken(markets[underlying][maturity].element);

        uint256 amount = elementToken.balanceOf(address(this));

        elementToken.withdrawPrincipal(amount, address(this));

        emit elementRedeemed(underlying, maturity, amount);

        return (true);
    } 

    /// @notice called at maturity to redeem all Sense PT's to Illuminate
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed    
    /// @param senseDivider address of the senseRouter for a given maturity
    function senseRedeem(address underlying, uint256 maturity, address senseDivider, address senseAdapter) public returns (bool) {

        IERC20 senseToken = IERC20(markets[underlying][maturity].sense);

        uint256 amount = senseToken.balanceOf(address(this));

        ISenseDivider(senseDivider).redeem(senseAdapter, maturity, amount);

        emit senseRedeemed(underlying, maturity, amount);

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

        Router.redeemAfterExpiry(forgeId, underlying, maturity);

        emit pendleRedeemed(underlying, maturity, amount);

        return (true);
    }

    /// @notice called at maturity to redeem all Tempus CT's to Illuminate
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    /// @param tempusPool the address of the given tempus pool
    function tempusRedeem(address underlying, uint256 maturity, address tempusPool) public returns (bool) {

        PErc20 tempusToken = PErc20(markets[underlying][maturity].tempus);
        ITempusRouter Router = ITempusRouter(tempusRouter);

        uint256 amount = tempusToken.balanceOf(address(this));

        Router.redeemToBacking(ITempusPool(tempusPool), amount, 0, address(this));

        emit tempusRedeemed(underlying, maturity, amount);

        return (true);
    }

    /// @notice called at maturity to redeem all APWine PT's to Illuminate
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    /// @param APWineVault the address of the given APWine vault
    function APWineRedeem(address underlying, uint256 maturity, address APWineVault) public returns (bool) {

        PErc20 APWineToken = PErc20(markets[underlying][maturity].apwine);
        IAPWineRouter Router = IAPWineRouter(apwineRouter);

        uint256 amount = APWineToken.balanceOf(address(this));

        Router.withdraw(IAPWineVault(APWineVault), amount);

        emit APWineRedeemed(underlying, maturity, amount);

        return (true);
    }

    modifier onlyAdmin(address a) {
        require(msg.sender == admin, 'sender must be admin');
        _;
  }
}