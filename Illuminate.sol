// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.8.4;

import './ZcToken.sol';
import './Utils/Hash.sol';
import './Utils/Sig.sol';
import "./Interfaces/IPErc20.sol";
import "./Interfaces/IErc2612.sol";
import "./Utils/CastU256U128.sol";

interface ElementToken is IPErc20 {
    function withdrawPrincipal(uint256 _amount, address _destination) external returns (uint256);
    function underlying() external view returns (IPErc20);
    function unlockTimestamp() external view returns (uint256);
}

interface YieldToken is IPErc20, IErc2612 {
    function isMature() external view returns(bool);
    function maturity() external view returns(uint);
    function redeem(address, address, uint256) external returns (uint256);
}

interface IAsset {
}

interface ElementPool {
    struct SingleSwap {
        bytes32 poolId;
        SwapKind kind;
        IAsset assetIn;
        IAsset assetOut;
        uint256 amount;
        bytes userData;
    }
    struct FundManagement {
        address sender;
        bool fromInternalBalance;
        address payable recipient;
        bool toInternalBalance;
    }
    enum SwapKind { GIVEN_IN, GIVEN_OUT }
    function swap(SingleSwap calldata singleSwap, FundManagement calldata funds,uint256 limit,uint256 deadline) external returns (uint256 amountCalculated);
}

interface YieldPool is IPErc20, IErc2612 {
    function maturity() external view returns(uint32);
    function base() external view returns(IPErc20);
    function sellBase(address to, uint128 min) external returns(uint128);
    function sellBasePreview(uint128 baseIn) external view returns(uint128);
    function retrieveBase(address user) external returns(uint128);
}

interface SwivelMarketplace {
  function zcTokenAddress(address, uint256) external returns (address);
  function redeemZcToken(address, uint256, uint256 ) external returns (bool);
}

interface SwivelRouter {
    function initiate(Hash.Order[] calldata o, uint256[] calldata a, Sig.Components[] calldata c) external returns(bool);
    function redeemZcToken(address, uint256, uint256 ) external returns (bool);
}

contract Illuminate {

    struct Market {
        address swivel;
        address yield;
        address element;
        address illuminate;
    }

    address public admin;
    address public immutable swivelRouter;
    
    // Mapping for underlying <-> maturity pairings / market pairs
    mapping (address => mapping (uint256 => Market)) public markets;
    
    event marketCreated(address indexed underlying, uint256 indexed maturity, address swivel, address yield, address element, address indexed illuminate);
    event swivelLent(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event swivelMinted(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event swivelRedeemed(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event yieldLent(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event yieldMinted(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event yieldRedeemed(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event elementLent(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event elementMinted(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event elementRedeemed(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event redeemed(address indexed underlying, uint256 indexed maturity, uint256 amount);

    constructor (address swivelAddress) {
        admin = msg.sender;
        swivelRouter = swivelAddress;
    }
    

    /// Can be called by the admin to create a new market of associated swivel, yield, and illuminate zero-coupon tokens (zcTokens, yTokens, lTokens)
    /// underlying the address of the underlying token deposit
    /// maturity the maturity of the market, it must be the identical across protocols or within a 1 day buffer
    /// swivel the address of the swivel zcToken
    /// yield the address of the yield token
    /// decimals the number of decimals in the underlying token
    function createMarket(address underlying, uint256 maturity, address swivel, address yield, address element, string calldata name, string calldata symbol, uint8 decimals) public onlyAdmin(admin) returns (bool) {
        
        address illuminate = address(new ZcToken(underlying, maturity, name, symbol, decimals));
        
        markets[underlying][maturity] = Market(swivel, yield, element, illuminate);
        
        emit marketCreated(underlying, maturity, swivel, yield, element, illuminate);
        
        return (true);
    }

    /// @notice Can be called before maturity to wrap swivel zcTokens into illuminate tokens
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    /// @param amount the amount of underlying tokens to lend   
    function swivelMint(address underlying, uint256 maturity, uint256 amount) public returns (bool) {

        Market memory market = markets[underlying][maturity];

        IPErc20(market.swivel).transferFrom(msg.sender, address(this), amount);
        
        ZcToken(market.illuminate).mint(msg.sender,amount);

        emit swivelMinted(underlying, maturity, amount);
        
        return (true);
    }

    /// @notice Can be called before maturity to lend to Swivel while minting illuminate tokens
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    /// @param orders the swivel orders being filled
    /// @param amounts the amount of underlying tokens lent to each order
    function swivelLend(address underlying, uint256 maturity, address yieldPool, Hash.Order[] calldata orders, uint256[] calldata amounts, Sig.Components[] calldata signatures) public returns (uint256) {

        // Instantiate market and tokens       
        ZcToken illuminateToken = ZcToken(markets[underlying][maturity].illuminate);
        IPErc20 underlyingToken = IPErc20(underlying);
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
        underlyingToken.transferFrom(msg.sender, address(this), totalLent);
        underlyingToken.approve(swivelRouter, totalLent);

        // Fill orders on Swivel 
        SwivelRouter(swivelRouter).initiate(orders, amounts, signatures); 
        
        // Lend the remaining amount to Yield
        uint256 yieldAmount = yieldLend(underlying, maturity, yieldPool, CastU256U128.u128(totalReturned));

        // Mint Illuminate zero coupons
        illuminateToken.mint(msg.sender, (totalLent+yieldAmount));
        
        emit swivelLent(underlying, maturity, totalLent+yieldAmount);

        return (totalLent+yieldAmount);
    }

    /// @notice Can be called before maturity to wrap yield yTokens into illuminate tokens
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    /// @param amount the amount of underlying tokens to lend   
    function yieldMint(address underlying, uint256 maturity, uint256 amount) public returns (bool) {

        Market memory market = markets[underlying][maturity];

        IPErc20(market.yield).transferFrom(msg.sender, address(this), amount);
        
        ZcToken(market.illuminate).mint(msg.sender,amount);

        emit yieldMinted(underlying, maturity, amount);
        
        return (true);
    }

    /// @notice Can be called before maturity to lend to yield while minting illuminate tokens
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    /// @param amount the amount of underlying tokens to lend
    function yieldLend(address underlying, uint256 maturity, address yieldPool, uint128 amount) public returns (uint256) {

        // Instantiate market and tokens
        IPErc20 u = IPErc20(underlying);
        ZcToken illuminateToken = ZcToken(markets[underlying][maturity].illuminate);
        YieldPool Pool = YieldPool(yieldPool);

        // Require the Yield pool provided matches the underlying and maturity market provided      
        require(Pool.maturity() == maturity, 'Wrong Yield pool address: maturity');
        require(address(Pool.base()) == underlying, 'Wrong Yield pool address: underlying');

        // Transfer funds from user to Illuminate       
        u.transferFrom(msg.sender, address(this), amount);
        u.approve(yieldPool, 2**256 - 1);

        // Preview exact swap slippage on YieldSpace pool
        uint128 returned = Pool.sellBasePreview(amount);

        // Transfer funds to yieldspace pool        
        u.transfer(yieldPool, amount);

        // "Sell Base" meaning purchase the zero coupons from YieldSpace pool
        Pool.sellBase(address(this), returned);

        // Mint Illuminate zero coupons
        illuminateToken.mint(msg.sender, returned);

        emit yieldLent(underlying, maturity, returned);
        
        return (returned);
    }

    /// @notice Can be called before maturity to wrap yield element PT's into illuminate tokens
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    /// @param amount the amount of underlying tokens to lend   
    function elementMint(address underlying, uint256 maturity, uint256 amount) public returns (bool) {

        Market memory market = markets[underlying][maturity];
        
        ElementToken(market.element).transferFrom(msg.sender, address(this), amount);
        
        ZcToken(market.illuminate).mint(msg.sender,amount);

        emit elementMinted(underlying, maturity, amount);
        
        return (true);
    }

    /// @notice Can be called before maturity to lend to yield while minting illuminate tokens
    /// @param elementPool the underlying token being redeemed
    /// @param poolID the balancer poolID for the principal token
    /// @param amount the amount of underlying tokens to lend
    /// @param minimumBought the minimum amount of zero-coupon tokens to return accounting for slippage
    /// @param deadline the maximum timestamp at which the transaction can be executed
    function elementLend(address underlying, uint256 maturity, address elementPool, bytes32 poolID, uint128 amount, uint256 minimumBought, uint256 deadline) public returns(uint256){
        
        // Instantiate market and tokens
        Market memory market = markets[underlying][maturity];
        IPErc20 underlyingToken = IPErc20(underlying);
        ElementToken elementToken = ElementToken(market.element);

        // Require the Element pool provided matches the underlying and maturity market provided
        require(elementToken.unlockTimestamp() == maturity, 'Wrong Element pool address: maturity');
        require(address(elementToken.underlying()) == underlying, 'Wrong Element pool address: underlying');
        
        // Transfer funds from user to Illuminate
        underlyingToken.transferFrom(msg.sender, address(this), amount);
        underlyingToken.approve(elementPool, 2**256 - 1);

        // Populate Balancer structs for a "SingleSwap"
        ElementPool Pool = ElementPool(elementPool);
        ElementPool.FundManagement memory _fundManagement = ElementPool.FundManagement({
            sender: address(this),
            fromInternalBalance: false,
            recipient: payable(address(this)),
            toInternalBalance: false
        });
        ElementPool.SingleSwap memory _singleSwap = ElementPool.SingleSwap({
            poolId: poolID,
            kind: ElementPool.SwapKind(0),
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

    /// @notice Can be called after maturity and after tokens have been redeemed to illuminate to redeem underlying tokens 
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    /// @param amount the amount of underlying tokens to redeem and illuminate tokens to burn
    function redeem(address underlying, uint256 maturity, uint256 amount) public returns (bool) {
    
        IZcToken illuminateToken = IZcToken(markets[underlying][maturity].illuminate);
        IPErc20 underlyingToken = IPErc20(underlying);
        
        require(illuminateToken.burn(msg.sender, amount), "Illuminate token burn failed");
        
        underlyingToken.transfer(msg.sender, amount);

        emit redeemed(underlying, maturity, amount);
        
        return (true);
    }
    
    /// @notice called at maturity to redeem all swivel zcTokenAddress to illuminate
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    function swivelRedeem(address underlying, uint256 maturity) public returns (bool) {
        
        uint256 amount = IZcToken(markets[underlying][maturity].swivel).balanceOf(address(this));
        
        require(SwivelRouter(swivelRouter).redeemZcToken(underlying,maturity,amount), "Swivel redemption failed");

        emit swivelRedeemed(underlying, maturity, amount);
        
        return (true);
    }
    
    /// @notice called at maturity to redeem all yield yTokens to illuminate
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed    
    function yieldRedeem(address underlying, uint256 maturity) public returns (bool) {

        YieldToken yieldToken = YieldToken(markets[underlying][maturity].illuminate);

        uint256 amount = yieldToken.balanceOf(address(this));

        require(yieldToken.redeem(address(this), address(this), amount) >= amount, "Yield redemption failed");

        emit yieldRedeemed(underlying, maturity, amount);
        
        return (true);
    }

    /// @notice called at maturity to redeem all element PT's to illuminate
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed    
    function elementRedeem(address underlying, uint256 maturity) public returns (bool) {

        ElementToken elementToken = ElementToken(markets[underlying][maturity].element);

        uint256 amount = elementToken.balanceOf(address(this));

        require(elementToken.withdrawPrincipal(amount, address(this)) >= amount, "Element redemption failed");

        emit elementRedeemed(underlying, maturity, amount);
        
        return (true);
    } 

    modifier onlyAdmin(address a) {
        require(msg.sender == admin, 'sender must be admin');
        _;
  }
}