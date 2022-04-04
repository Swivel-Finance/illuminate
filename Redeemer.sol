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
import "./Interfaces/IIlluminate.sol";
import "./Utils/SafeTransferLib.sol";


contract Redeemer {

    event swivelRedeemed(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event yieldRedeemed(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event elementRedeemed(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event senseRedeemed(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event pendleRedeemed(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event tempusRedeemed(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event APWineRedeemed(address indexed underlying, uint256 indexed maturity, uint256 amount);
    event redeemed(address indexed underlying, uint256 indexed maturity, uint256 amount);

    address public immutable illuminate;
    address public immutable swivelRouter;
    address public immutable pendleRouter;
    address public immutable tempusRouter;
    address public immutable apwineRouter;

    constructor (address illuminateAddress, address swivelAddress, address pendleAddress, address tempusAddress, address apwineAddress) {
        illuminate = illuminateAddress;
        swivelRouter = swivelAddress;
        pendleRouter = pendleAddress;
        tempusRouter = tempusAddress;
        apwineRouter = apwineAddress;
    }

    /// @notice Can be called after maturity and after tokens have been redeemed to Illuminate to redeem underlying tokens 
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    /// @param owner the owner of the zcTokens being redeemed
    function redeem(address underlying, uint256 maturity, address owner) public returns (bool) {

        IZcToken illuminateToken = IZcToken(IIlluminate(illuminate).markets(underlying, maturity).illuminate);

        ERC20 underlyingToken = ERC20(underlying);

        amount = illuminateToken.balanceOf(owner);

        illuminateToken.burn(owner, amount);

        SafeTransferLib.safeTransfer(underlyingToken, owner, amount);

        emit redeemed(underlying, maturity, amount);

        return (true);
    }
    
    /// @notice called at maturity to redeem all Swivel zcTokens to Illuminate
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    function swivelRedeem(address underlying, uint256 maturity) public returns (bool) {

        IZcToken illuminateToken = IZcToken(IIlluminate(illuminate).markets(underlying, maturity).swivel);

        uint256 amount = illuminateToken.balanceOf(illuminate);

        illuminateToken.transferFrom(illuminate, address(this), amount);

        ISwivelRouter(swivelRouter).redeemZcToken(underlying, maturity, amount);

        emit swivelRedeemed(underlying, maturity, amount);

        return (true);
    }

    /// @notice called at maturity to redeem all Yield yTokens to Illuminate
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed    
    function yieldRedeem(address underlying, uint256 maturity) public returns (bool) {

        IYieldToken yieldToken = IYieldToken(IIlluminate(illuminate).markets(underlying, maturity).yield);

        uint256 amount = yieldToken.balanceOf(illuminate);

        yieldToken.transferFrom(illuminate, address(this), amount);

        yieldToken.redeem(address(this), address(this), amount);

        emit yieldRedeemed(underlying, maturity, amount);

        return (true);
    }

    /// @notice called at maturity to redeem all Element PT's to Illuminate
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed    
    function elementRedeem(address underlying, uint256 maturity) public returns (bool) {

        IElementToken elementToken = IElementToken(IIlluminate(illuminate).markets(underlying, maturity).element);

        uint256 amount = elementToken.balanceOf(illuminate);

        elementToken.transferFrom(illuminate, address(this), amount);

        elementToken.withdrawPrincipal(amount, illuminate);

        emit elementRedeemed(underlying, maturity, amount);

        return (true);
    } 

    /// @notice called at maturity to redeem all Sense PT's to Illuminate
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed    
    /// @param senseDivider address of the senseRouter for a given maturity
    function senseRedeem(address underlying, uint256 maturity, address senseDivider, address senseAdapter) public returns (bool) {

        IERC20 senseToken = IERC20(IIlluminate(illuminate).markets(underlying, maturity).sense);

        uint256 amount = senseToken.balanceOf(address(this));

        senseToken.transferFrom(illuminate, address(this), amount);

        ISenseDivider(senseDivider).redeem(senseAdapter, maturity, amount);

        emit senseRedeemed(underlying, maturity, amount);

        return (true);
    }

    /// @notice called at maturity to redeem all Pendle PT's to Illuminate
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    /// @param forgeId the Pendle forge ID for the given underyling and maturity market pair
    function pendleRedeem(address underlying, uint256 maturity, bytes32 forgeId) public returns (bool) {

        IERC20 pendleToken = IERC20(IIlluminate(illuminate).markets(underlying, maturity).pendle);
        IPendleRouter Router = IPendleRouter(pendleRouter);

        uint256 amount = pendleToken.balanceOf(illuminate);

        pendleToken.transferFrom(illuminate, address(this), amount);

        Router.redeemAfterExpiry(forgeId, underlying, maturity);

        emit pendleRedeemed(underlying, maturity, amount);

        return (true);
    }

    /// @notice called at maturity to redeem all Tempus CT's to Illuminate
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    /// @param tempusPool the address of the given tempus pool
    function tempusRedeem(address underlying, uint256 maturity, address tempusPool) public returns (bool) {

        IERC20 tempusToken = IERC20(IIlluminate(illuminate).markets(underlying, maturity).tempus);
        ITempusRouter Router = ITempusRouter(tempusRouter);

        uint256 amount = tempusToken.balanceOf(illuminate);

        tempusToken.transferFrom(illuminate, address(this), amount);

        Router.redeemToBacking(ITempusPool(tempusPool), amount, 0, address(this));

        emit tempusRedeemed(underlying, maturity, amount);

        return (true);
    }

    /// @notice called at maturity to redeem all APWine PT's to Illuminate
    /// @param underlying the underlying token being redeemed
    /// @param maturity the maturity of the market being redeemed
    /// @param APWineVault the address of the given APWine vault
    function APWineRedeem(address underlying, uint256 maturity, address APWineVault) public returns (bool) {

        IERC20 APWineToken = IERC20(IIlluminate(illuminate).markets(underlying, maturity).apwine);
        IAPWineRouter Router = IAPWineRouter(apwineRouter);

        uint256 amount = APWineToken.balanceOf(illuminate);

        APWineToken.transferFrom(illuminate, address(this), amount);

        Router.withdraw(IAPWineVault(APWineVault), amount);

        emit APWineRedeemed(underlying, maturity, amount);

        return (true);
    }

}