// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.8.4;

import './ZcToken.sol';
import './Utils/Hash.sol';
import './Utils/Sig.sol';
import "./Interfaces/IPErc20.sol";
import "./Interfaces/IErc2612.sol";


interface ElementToken is IPErc20 {

    function withdrawPrincipal(uint256 _amount, address _destination)
        external
        returns (uint256);

    function underlying() external view returns (IPErc20);

    function unlockTimestamp() external view returns (uint256);
}

interface YieldToken is IPErc20, IErc2612 {
    function isMature() external view returns(bool);
    function maturity() external view returns(uint);
    function chi0() external view returns(uint);
    function rate0() external view returns(uint);
    function chiGrowth() external view returns(uint);
    function rateGrowth() external view returns(uint);
    function mature() external;
    function unlocked() external view returns (uint);
    function mint(address, uint) external;
    function burn(address, uint) external;
    function flashMint(uint, bytes calldata) external;
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
    function buyBase(address to, uint128 baseOut, uint128 max) external returns(uint128);
    function sellFYToken(address to, uint128 min) external returns(uint128);
    function buyFYToken(address to, uint128 fyTokenOut, uint128 max) external returns(uint128);
    function sellBasePreview(uint128 baseIn) external view returns(uint128);
    function buyBasePreview(uint128 baseOut) external view returns(uint128);
    function sellFYTokenPreview(uint128 fyTokenIn) external view returns(uint128);
    function buyFYTokenPreview(uint128 fyTokenOut) external view returns(uint128);
}


interface SwivelMarketplace {
  function zcTokenAddress(address, uint256) virtual external returns (address);
  function redeemZcToken(address, uint256, uint256 ) virtual external returns (bool);
}

interface SwivelRouter {
    function initiate(Hash.Order[] calldata o, uint256[] calldata a, Sig.Components[] calldata c) public virtual returns(bool);
    function redeemZcToken(address, uint256, uint256 ) virtual external returns (bool);
}

contract Illuminate {

    struct Market {
        address swivel;
        address yield;
        address illuminate;
        address element;
    }
    uint128 public fyDAIOUT;
    address public admin;
    address public immutable swivelRouter;
    
    mapping (address => mapping (uint256 => Market)) public markets;
    
    event marketCreated(address indexed underlying, uint256 indexed maturity, address swivel, address yield, address element, address indexed illuminate);
    
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
    function createMarket(address underlying, uint256 maturity, address swivel, address yield, address element, uint8 decimals) public onlyAdmin(admin) returns (bool) {
        
        address illuminate = address(new ZcToken(underlying, maturity, "illuminate", "ILL", decimals));
        
        markets[underlying][maturity] = Market(swivel, yield, element, illuminate);
        
        emit marketCreated(underlying, maturity, swivel, yield, element, illuminate);
        
        return (true);
    }

    /// @notice Can be called before maturity to wrap swivel zcTokens into illuminate tokens
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    /// @param amount the amount of underlying tokens to lend   
    function swivelMint(address underlying, uint256 maturity, uint256 amount) public returns (bool) {
        
        ZcToken illuminateToken = ZcToken(markets[underlying][maturity].illuminate);
        
        IPErc20(markets[underlying][maturity].swivel).transferFrom(msg.sender, address(this), amount);
        
        illuminateToken.mint(msg.sender,amount);
        
        return (true);
    }

    /// @notice Can be called before maturity to lend to Swivel while minting illuminate tokens
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    /// @param orders the swivel orders being filled
    /// @param amounts the amount of underlying tokens lent to each order
    function swivelLend(address underlying, uint256 maturity, address yieldRouter, Hash.Order[] calldata orders, uint256[] calldata amounts, Sig.Components[] calldata signatures) public returns (uint256) {

        ZcToken illuminateToken = ZcToken(markets[underlying][maturity].illuminate);
        IPErc20 underlyingToken = IPErc20(underlying);
        uint256 totalLent;
        uint256 totalReturned;
        for (uint256 i=0; i < orders.length; i++) {
            Hash.Order memory order = orders[i];
            uint256 amount = amounts[i];
            totalLent += amount;
            totalReturned += amount * order.premium / order.principal;
        }
        
        underlyingToken.transferFrom(msg.sender, address(this), totalLent);
        underlyingToken.approve(swivelRouter, totalLent);

        require(SwivelRouter(swivelRouter).initiate(orders, amounts, signatures), "swivel lending failed"); 
        
        uint256 yieldAmount = yieldLend(underlying, maturity, yieldRouter, uint128(totalReturned));

        illuminateToken.mint(msg.sender, (totalLent+yieldAmount));
        
        return (totalLent+yieldAmount);
    }

    /// @notice Can be called before maturity to wrap yield yTokens into illuminate tokens
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    /// @param amount the amount of underlying tokens to lend   
    function yieldMint(address underlying, uint256 maturity, uint256 amount) public returns (bool) {
        
        IPErc20 yieldToken = IPErc20(markets[underlying][maturity].yield);
        ZcToken illuminateToken = ZcToken(markets[underlying][maturity].illuminate);
        
        yieldToken.transferFrom(msg.sender, address(this), amount);
        
        illuminateToken.mint(msg.sender,amount);
        
        return (true);
    }

    /// @notice Can be called before maturity to lend to yield while minting illuminate tokens
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    /// @param amount the amount of underlying tokens to lend
    function yieldLend(address underlying, uint256 maturity, address yieldPool, uint128 amount) public returns (uint256) {
        
        IPErc20 u = IPErc20(underlying);
        ZcToken illuminateToken = ZcToken(markets[underlying][maturity].illuminate);
        YieldPool Pool = YieldPool(yieldPool);
        
        u.transferFrom(msg.sender, address(this), amount);
        u.approve(yieldPool, 2**256 - 1);

        uint128 _fyDAIOUT = Pool.sellBasePreview(amount);

        uint128 returned = Pool.buyFYToken(address(this), _fyDAIOUT, amount);

        illuminateToken.mint(msg.sender, returned);
        
        return (returned);
    }

    /// @notice Can be called before maturity to wrap yield element PT's into illuminate tokens
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    /// @param amount the amount of underlying tokens to lend   
    function elementMint(address underlying, uint256 maturity, uint256 amount) public returns (bool) {

        IPErc20 elementToken = IPErc20(markets[underlying][maturity].element);
        ZcToken illuminateToken = ZcToken(markets[underlying][maturity].illuminate);
        
        elementToken.transferFrom(msg.sender, address(this), amount);
        
        illuminateToken.mint(msg.sender,amount);
        
        return (true);
    }

    /// @notice Can be called before maturity to lend to yield while minting illuminate tokens
    /// @param elementPool the underlying token being redeemed
    /// @param poolID the balancer poolID for the principal token
    /// @param amount the amount of underlying tokens to lend
    /// @param minimumBought the minimum amount of zero-coupon tokens to return accounting for slippage
    /// @param deadline the maximum timestamp at which the transaction can be executed
    function elementLend(address underlying, uint256 maturity, address elementPool, bytes32 poolID, uint128 amount, uint256 minimumBought, uint256 deadline) public returns(uint256){
        
        Market memory market = markets[underlying][maturity];

        address element = market.element;
        IPErc20 underlyingToken = IPErc20(underlying);
        
        underlyingToken.transferFrom(msg.sender, address(this), amount);
        underlyingToken.approve(elementPool, 2**256 - 1);

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
            assetOut: IAsset(element),
            amount: amount,
            userData: "0x00000000000000000000000000000000000000000000000000000000000000"
        });

        uint256 returned = Pool.swap(_singleSwap, _fundManagement, minimumBought, deadline);

        {
        ZcToken illuminateToken = ZcToken(market.illuminate);
        illuminateToken.mint(msg.sender, returned);
        }

        return (returned);
    }

    /// @notice Can be called after maturity and after tokens have been redeemed to illuminate to redeem underlying tokens 
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    /// @param amount the amount of underlying tokens to redeem and illuminate tokens to burn
    function redeem(address underlying, uint256 maturity, uint256 amount) public returns (bool) {
    
        ZcToken illuminateToken = ZcToken(markets[underlying][maturity].illuminate);
        IPErc20 underlyingToken = IPErc20(underlying);
        
        require(illuminateToken.burn(msg.sender, amount), "illuminate transfer failed");
        
        underlyingToken.transfer(msg.sender,amount);
        
        return (true);
    }
    
    /// @notice called at maturity to redeem all swivel zcTokenAddress to illuminate
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    function swivelRedeem(address underlying, uint256 maturity) public returns (bool) {
        
        uint256 amount = IPErc20(markets[underlying][maturity].swivel).balanceOf(address(this));
        
        require(SwivelRouter(swivelRouter).redeemZcToken(underlying,maturity,amount), "swivel redemption failed");
        
        return (true);
    }
    
    /// @notice called at maturity to redeem all yield yTokens to illuminate
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed    
    function yieldRedeem(address underlying, uint256 maturity) public returns (bool) {

        YieldToken yieldToken = YieldToken(markets[underlying][maturity].illuminate);

        uint256 amount = yieldToken.balanceOf(address(this));

        require(yieldToken.redeem(address(this),address(this),amount) >= amount, "yield redemption failed");
        
        return (true);
    }

    /// @notice called at maturity to redeem all element PT's to illuminate
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed    
    function elementRedeem(address underlying, uint256 maturity) public returns (bool) {

        ElementToken elementToken = ElementToken(markets[underlying][maturity].element);

        uint256 amount = elementToken.balanceOf(address(this));

        require(elementToken.withdrawPrincipal(amount, address(this)) >= amount, "element redemption failed");
        
        return (true);
    } 

    modifier onlyAdmin(address a) {
        require(msg.sender == admin, 'sender must be admin');
        _;
  }
    
}