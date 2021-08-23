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
}

contract Illuminate {

    struct Market {
        address swivel;
        address yield;
        address illuminate;
    }
    
    address public admin;
    
    mapping (address => mapping (uint256 => Market)) public markets;
    
    event marketCreated(address indexed underlying, uint256 indexed maturity, address indexed illuminate, address swivel, address yield);
    
    constructor () {
        admin = msg.sender;
    }
    
    
    function createMarket(address underlying, uint256 maturity, address swivel, address yield, uint8 decimals) public onlyAdmin(admin) returns (bool) {
        
        address illuminateAddress = address(new ZcToken(underlying, maturity, decimals, "illuminate", "ILL"));
        
        Market memory market = Market(swivel,yield,illuminateAddress);
        
        markets[underlying][maturity] = market;
        
        emit marketCreated(underlying, maturity, illuminateAddress, swivel, yield);
        
        return (true);
    }
    
    
    function swivelMint(address underlying, uint256 maturity, uint256 amount) public returns (bool) {
        
        ZcToken illuminateToken = ZcToken(markets[underlying][maturity].illuminate);
        
        IERC20(markets[underlying][maturity].swivel).transferFrom(msg.sender, address(this), amount);
        
        illuminateToken.mint(msg.sender,amount);
        
        return (true);
    }
     
    function swivelLend(address underlying, uint256 maturity, address swivelRouter, Hash.Order[] calldata orders, uint256[] calldata amounts, Sig.Components[] calldata signatures) public returns (bool) {

        ZcToken illuminateToken = ZcToken(markets[underlying][maturity].illuminate);
        IERC20 underlyingToken = IERC20(underlying);
        
        for (uint256 i=0; i < orders.length; i++) {
            underlyingToken.transferFrom(msg.sender, address(this), amounts[i]);
            underlyingToken.approve(swivelRouter, amounts[i]);
        }
        
        require(SwivelRouter(swivelRouter).initiate(orders, amounts, signatures), "swivel minting failed"); 
        
        for (uint256 i=0; i < orders.length; i++) {
            illuminateToken.mint(msg.sender,amounts[i]);
        }
        
        return (true);
    }
    
    function yieldMint(address underlying, uint256 maturity, uint256 amount) public returns (bool) {
        
        IFYDai yieldToken = IFYDai(markets[underlying][maturity].yield);
        ZcToken illuminateToken = ZcToken(markets[underlying][maturity].illuminate);
        
        yieldToken.transferFrom(msg.sender, address(this), amount);
        
        illuminateToken.mint(msg.sender,amount);
        
        return (true);
    }
    
    function yieldLend(address underlying, uint256 maturity, address yieldRouter, uint128 amount) public returns (bool) {
        
        IFYDai yieldToken = IFYDai(markets[underlying][maturity].yield);
        ZcToken illuminateToken = ZcToken(markets[underlying][maturity].illuminate);
        
        yieldToken.transferFrom(msg.sender, address(this), amount);
        
        uint128 fyDaiOut = YieldRouter(yieldRouter).sellDai(address(this), address(this), amount);
        
        illuminateToken.mint(msg.sender, fyDaiOut);
        
        return (true);
    }
    
    function redeem(address underlying, uint256 maturity, uint256 amount) public returns (bool) {
    
        ZcToken illuminateToken = ZcToken(markets[underlying][maturity].illuminate);
        IERC20 underlyingToken = IERC20(underlying);
        
        require(illuminateToken.burn(msg.sender, amount), "illuminate transfer failed");
        
        underlyingToken.transfer(msg.sender,amount);
        
        return (true);
    }
    
    function swivelRedeem(address underlying, uint256 maturity, address swivelMarketplace) public returns (bool) {
    
        IERC20 underlyingToken = IERC20(underlying);
        
        uint256 amount = IERC20(markets[underlying][maturity].swivel).balanceOf(address(this));
        
        require(SwivelMarketplace(swivelMarketplace).redeemZcToken(underlying,maturity,amount), "swivel redemption failed");
        
        underlyingToken.transfer(msg.sender,amount);
        
        return (true);
    }
    
    function yieldRedeem(address underlying, uint256 maturity) public returns (bool) {

        IERC20 underlyingToken = IERC20(underlying);
        IFYDai yieldToken = IFYDai(markets[underlying][maturity].illuminate);

        uint256 amount = yieldToken.balanceOf(address(this));

        require(yieldToken.redeem(address(this),address(this),amount) >= amount, "yield redemption failed");
        
        underlyingToken.transfer(msg.sender,amount);
        
        return (true);
    }
    
    modifier onlyAdmin(address a) {
        require(msg.sender == admin, 'sender must be admin');
        _;
  }
    
}