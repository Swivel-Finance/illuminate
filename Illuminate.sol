// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.4;

import 'ZcToken.sol';
import './Utils/Hash.sol';
import './Utils/Sig.sol';
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Interfaces/IErc2612.sol";

interface IFYDai is IERC20, IErc2612 {
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
    // function transfer(address, uint) external returns (bool);
    // function transferFrom(address, address, uint) external returns (bool);
    // function approve(address, uint) external returns (bool);
}

abstract contract YieldRouter {
        function sellDai(address from, address to, uint128 daiIn) virtual public returns(uint128);
}

abstract contract SwivelMarketplace {
  function zcTokenAddress(address, uint256) virtual external returns (address);
  function redeemZcToken(address, uint256, uint256 ) virtual external returns (bool);
}

abstract contract SwivelRouter {
    function initiate(Hash.Order[] calldata o, uint256[] calldata a, Sig.Components[] calldata c) public virtual returns(bool);
    function redeemZcToken(address, uint256, uint256 ) virtual external returns (bool);
}

contract Illuminate {

    struct Market {
        address swivel;
        address yield;
        address illuminate;
    }
    
    address public admin;
    address public immutable yieldRouter;
    address public immutable swivelRouter;
    
    mapping (address => mapping (uint256 => Market)) public markets;
    
    event marketCreated(address indexed underlying, uint256 indexed maturity, address indexed illuminate, address swivel, address yield);
    
    constructor (address swivelAddress, address yieldAddress) {
        admin = msg.sender;
        swivelRouter = swivelAddress;
        yieldRouter = yieldAddress;
    }
    

    /// Can be called by the admin to create a new market of associated swivel, yield, and illuminate zero-coupon tokens (zcTokens, yTokens, lTokens)
    /// underlying the address of the underlying token deposit
    /// maturity the maturity of the market, it must be the identical across protocols or within a 1 day buffer
    /// swivel the address of the swivel zcToken
    /// yield the address of the yield token
    /// decimals the number of decimals in the underlying token
    function createMarket(address underlying, uint256 maturity, address swivel, address yield, uint8 decimals) public onlyAdmin(admin) returns (bool) {
        
        address illuminateAddress = address(new ZcToken(underlying, maturity, "illuminate", "ILL", decimals));
        
        markets[underlying][maturity] = Market(swivel,yield,illuminateAddress);
        
        emit marketCreated(underlying, maturity, illuminateAddress, swivel, yield);
        
        return (true);
    }

    /// @notice Can be called before maturity to wrap swivel zcTokens into illuminate tokens
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    /// @param amount the amount of underlying tokens to lend   
    function swivelMint(address underlying, uint256 maturity, uint256 amount) public returns (bool) {
        
        ZcToken illuminateToken = ZcToken(markets[underlying][maturity].illuminate);
        
        IERC20(markets[underlying][maturity].swivel).transferFrom(msg.sender, address(this), amount);
        
        illuminateToken.mint(msg.sender,amount);
        
        return (true);
    }

    /// @notice Can be called before maturity to lend to Swivel while minting illuminate tokens
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    /// @param orders the swivel orders being filled
    /// @param amounts the amount of underlying tokens lent to each order
    function swivelLend(address underlying, uint256 maturity, Hash.Order[] calldata orders, uint256[] calldata amounts, Sig.Components[] calldata signatures) public returns (bool) {

        ZcToken illuminateToken = ZcToken(markets[underlying][maturity].illuminate);
        IERC20 underlyingToken = IERC20(underlying);
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
        
        uint256 yieldAmount = yieldLend(underlying, maturity, uint128(totalReturned));

        illuminateToken.mint(msg.sender, (totalLent+yieldAmount));
        
        return (true);
    }

    /// @notice Can be called before maturity to wrap yield yTokens into illuminate tokens
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    /// @param amount the amount of underlying tokens to lend   
    function yieldMint(address underlying, uint256 maturity, uint256 amount) public returns (bool) {
        
        IFYDai yieldToken = IFYDai(markets[underlying][maturity].yield);
        ZcToken illuminateToken = ZcToken(markets[underlying][maturity].illuminate);
        
        yieldToken.transferFrom(msg.sender, address(this), amount);
        
        illuminateToken.mint(msg.sender,amount);
        
        return (true);
    }

    /// @notice Can be called before maturity to lend to yield while minting illuminate tokens
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    /// @param amount the amount of underlying tokens to lend
    function yieldLend(address underlying, uint256 maturity, uint128 amount) public returns (uint256) {
        
        IFYDai yieldToken = IFYDai(markets[underlying][maturity].yield);
        ZcToken illuminateToken = ZcToken(markets[underlying][maturity].illuminate);
        
        yieldToken.transferFrom(msg.sender, address(this), amount);
        
        uint128 fyDaiOut = YieldRouter(yieldRouter).sellDai(address(this), address(this), amount);
        
        illuminateToken.mint(msg.sender, fyDaiOut);
        
        return (fyDaiOut);
    }
    
    /// @notice Can be called after maturity and after tokens have been redeemed to illuminate to redeem underlying tokens 
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    /// @param amount the amount of underlying tokens to redeem and illuminate tokens to burn
    function redeem(address underlying, uint256 maturity, uint256 amount) public returns (bool) {
    
        ZcToken illuminateToken = ZcToken(markets[underlying][maturity].illuminate);
        IERC20 underlyingToken = IERC20(underlying);
        
        require(illuminateToken.burn(msg.sender, amount), "illuminate transfer failed");
        
        underlyingToken.transfer(msg.sender,amount);
        
        return (true);
    }
    
    /// @notice called at maturity to redeem all swivel zcTokenAddress to illuminate
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    function swivelRedeem(address underlying, uint256 maturity) public returns (bool) {
        
        uint256 amount = IERC20(markets[underlying][maturity].swivel).balanceOf(address(this));
        
        require(SwivelRouter(swivelRouter).redeemZcToken(underlying,maturity,amount), "swivel redemption failed");
        
        return (true);
    }
    
    /// @notice called at maturity to redeem all yield yTokens to illuminate
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed    
    function yieldRedeem(address underlying, uint256 maturity) public returns (bool) {

        IFYDai yieldToken = IFYDai(markets[underlying][maturity].illuminate);

        uint256 amount = yieldToken.balanceOf(address(this));

        require(yieldToken.redeem(address(this),address(this),amount) >= amount, "yield redemption failed");
        
        return (true);
    }
    
    modifier onlyAdmin(address a) {
        require(msg.sender == admin, 'sender must be admin');
        _;
  }
    
}