// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import 'forge-std/Test.sol';
import 'forge-std/console.sol';

import 'src/Redeemer.sol';
import 'src/mocks/MarketPlace.sol' as mock_mp;
import 'src/mocks/ERC20.sol' as mock_erc20;
import 'src/mocks/Lender.sol' as mock_l;
import 'src/mocks/Converter.sol' as mock_c;
import 'src/mocks/IlluminatePrincipalToken.sol' as mock_ipt;

import 'src/mocks/Swivel.sol' as mock_sw;
import 'src/mocks/SwivelToken.sol' as mock_swt;
import 'src/mocks/YieldToken.sol' as mock_yt;
import 'src/mocks/ElementToken.sol' as mock_et;
import 'src/mocks/PendleToken.sol' as mock_pt;
import 'src/mocks/PendleForge.sol' as mock_pf;
import 'src/mocks/Pendle.sol' as mock_p;
import 'src/mocks/Tempus.sol' as mock_t;
import 'src/mocks/TempusToken.sol' as mock_tt;
import 'src/mocks/TempusPool.sol' as mock_tp;
import 'src/mocks/SenseAdapter.sol' as mock_sa;
import 'src/mocks/SenseDivider.sol' as mock_sd;
import 'src/mocks/SensePeriphery.sol' as mock_sp;
import 'src/mocks/APWineAMMPool.sol' as mock_apwammpool;
import 'src/mocks/APWineController.sol' as mock_apwc;
import 'src/mocks/APWineFutureVault.sol' as mock_apwfv;
import 'src/mocks/APWineRouter.sol' as mock_apwr;
import 'src/mocks/APWineToken.sol' as mock_apwt;
import 'src/mocks/Notional.sol' as mock_n;

contract RedeemerTest is Test {
    Redeemer r;

    // helper attributes
    address underlying;
    uint256 maturity = block.timestamp - 1000;
    uint256 amount = 100000;
    uint256 feenominator = 1000;

    // mocks
    mock_mp.MarketPlace mp;
    mock_l.Lender l;
    mock_c.Converter c;
    mock_ipt.IlluminatePrincipalToken ipt;

    mock_sw.Swivel sw;
    mock_swt.SwivelToken swt;
    mock_yt.YieldToken yt;
    mock_et.ElementToken et;
    mock_pt.PendleToken pt;
    mock_pf.PendleForge pf;
    mock_p.Pendle p;
    mock_t.Tempus t;
    mock_tt.TempusToken tt;
    mock_tp.TempusPool tp;
    mock_sa.SenseAdapter sa;
    mock_sd.SenseDivider sd;
    mock_sp.SensePeriphery sp;
    mock_erc20.ERC20 st;
    mock_apwc.APWineController apwc;
    mock_apwfv.APWineFutureVault apwfv;
    mock_apwr.APWineRouter apwr;
    mock_apwt.APWineToken apwt;
    mock_n.Notional n;

    function setUp() public {
        // Deploy mocked external contracts
        deployInterfaceMocks();
        // Deploy redeemer
        r = new Redeemer(
            address(0), // lender
            address(sw), // swivel
            address(p), // pendle
            address(t) // tempus
        );
        // Deploy marketplace
        mp = new mock_mp.MarketPlace();
        // Deploy lender
        l = new mock_l.Lender();
        // Deploy converter
        c = new mock_c.Converter();
        // Set the marketplace for the redeemer
        r.setMarketPlace(address(mp));
        // Set the lender for the redeemer
        r.setLender(address(l));
        // Set the converter for the redeemer
        r.setConverter(address(c), new address[](0));
    }

    function deployInterfaceMocks() internal {
        underlying = address(new mock_erc20.ERC20());
        ipt = new mock_ipt.IlluminatePrincipalToken();
        swt = new mock_swt.SwivelToken();
        sw = new mock_sw.Swivel(underlying, address(swt));
        yt = new mock_yt.YieldToken();
        et = new mock_et.ElementToken();
        pt = new mock_pt.PendleToken();
        pf = new mock_pf.PendleForge();
        p = new mock_p.Pendle(address(pt));
        tt = new mock_tt.TempusToken();
        tp = new mock_tp.TempusPool();
        t = new mock_t.Tempus(address(tt));
        st = new mock_erc20.ERC20();
        sa = new mock_sa.SenseAdapter();
        sd = new mock_sd.SenseDivider(underlying);
        sp = new mock_sp.SensePeriphery(address(st));
        apwc = new mock_apwc.APWineController();
        apwfv = new mock_apwfv.APWineFutureVault();
        apwt = new mock_apwt.APWineToken();
        apwr = new mock_apwr.APWineRouter(address(apwt));
        n = new mock_n.Notional();
    }

    function testIlluminateRedeem() public {
        mp.iptReturns(address(ipt));
        ipt.balanceOfReturns(amount);
        ipt.transferFromReturns(true);
        ipt.totalSupplyReturns(amount);
        ipt.maturityReturns(maturity);
        mock_erc20.ERC20(underlying).transferReturns(true);
        l.illuminatePausedReturns(false);

        /// Setup holdings to have holdings by running a redemption
        mp.marketsReturns(address(swt));
        swt.maturityReturns(maturity);
        swt.balanceOfReturns(amount);
        swt.transferFromReturns(true);
        sw.redeemZcTokenReturns(true);
        r.redeem(1, underlying, maturity, 5);
        assertEq(r.holdings(underlying, maturity), amount);

        r.redeem(underlying, maturity);
        // markets check
        (uint256 calledMaturity, uint256 calledPrincipal) = mp.iptCalled(
            underlying
        );
        assertEq(maturity, calledMaturity);
        assertEq(0, calledPrincipal);

        // burn check
        uint256 burnt = ipt.burnCalled(address(this));
        assertEq(burnt, amount);

        // transfer check
        uint256 sent = mock_erc20.ERC20(underlying).transferCalled(
            address(this)
        );
        assertEq(sent, amount);
    }

    function testSwivelRedeem() public {
        mp.marketsReturns(address(swt));
        swt.maturityReturns(maturity);
        swt.balanceOfReturns(amount);
        swt.transferFromReturns(true);
        sw.redeemZcTokenReturns(true);
        mock_erc20.ERC20(underlying).balanceOfReturns(amount);
        uint8 euler = 5;

        r.redeem(1, underlying, maturity, euler);

        // holdings check
        assertEq(r.holdings(underlying, maturity), amount);
        // markets check
        (uint256 calledMaturity, uint256 calledPrincipal) = mp.marketsCalled(
            underlying
        );
        assertEq(maturity, calledMaturity);
        assertEq(1, calledPrincipal);
        // transferFrom check
        (address transferFromTo, uint256 transferFromAmount) = mock_erc20
            .ERC20(swt)
            .transferFromCalled(address(l));
        assertEq(address(r), transferFromTo);
        assertEq(amount, transferFromAmount);
        // transferPremium check
        calledMaturity = l.transferPremiumCalled(underlying);
        assertEq(maturity, calledMaturity);
        // redeemZcToken check
        (
            uint8 protocolRedeemed,
            uint256 amountRedeemed,
            uint256 maturityRedeemed
        ) = sw.redeemZcTokenCalled(underlying);
        assertEq(euler, protocolRedeemed);
        assertEq(maturity, maturityRedeemed);
        assertEq(amount, amountRedeemed);
    }

    function testYieldRedeem() public {
        mp.marketsReturns(address(yt));
        yt.maturityReturns(maturity);
        yt.balanceOfReturns(amount);
        yt.transferFromReturns(true);

        r.redeem(2, underlying, maturity);

        // markets check
        (uint256 calledMaturity, uint256 calledPrincipal) = mp.marketsCalled(
            underlying
        );
        assertEq(maturity, calledMaturity);
        assertEq(2, calledPrincipal);
        // transferFrom check
        (address transferFromTo, uint256 transferFromAmount) = mock_erc20
            .ERC20(yt)
            .transferFromCalled(address(l));
        assertEq(address(r), transferFromTo);
        assertEq(amount, transferFromAmount);
        // redeemZcToken check
        uint256 amountRedeemed = yt.redeemCalled(address(r));
        assertEq(amount, amountRedeemed);
    }

    function testElementRedeem() public {
        mp.marketsReturns(address(et));
        et.unlockTimestampReturns(maturity);
        et.balanceOfReturns(amount);
        et.transferFromReturns(true);
        et.withdrawPrincipalReturns(amount);

        r.redeem(3, underlying, maturity);

        // markets check
        (uint256 calledMaturity, uint256 calledPrincipal) = mp.marketsCalled(
            underlying
        );
        assertEq(maturity, calledMaturity);
        assertEq(3, calledPrincipal);
        // transferFrom check
        (address transferFromTo, uint256 transferFromAmount) = mock_erc20
            .ERC20(et)
            .transferFromCalled(address(l));
        assertEq(address(r), transferFromTo);
        assertEq(amount, transferFromAmount);
        // redeemZcToken check
        uint256 amountRedeemed = et.withdrawPrincipalCalled(address(r));
        assertEq(amount, amountRedeemed);
    }

    function testPendleRedeem() public {
        bytes32 forgeId = bytes32('fixed rate');
        address compoundingToken = address(yt); // just use another token address
        mp.marketsReturns(address(pt));
        pt.expiryReturns(maturity);
        pt.forgeReturns(address(pf));
        pt.balanceOfReturns(amount);
        pt.transferFromReturns(true);
        pf.forgeIdReturns(bytes32(forgeId));
        pt.underlyingYieldTokenReturns(compoundingToken);
        yt.balanceOfReturns(amount);

        r.redeem(4, underlying, maturity);

        // markets check
        (uint256 calledMaturity, uint256 calledPrincipal) = mp.marketsCalled(
            underlying
        );
        assertEq(maturity, calledMaturity);
        assertEq(4, calledPrincipal);
        // transferFrom check
        (address transferFromTo, uint256 transferFromAmount) = mock_erc20
            .ERC20(pt)
            .transferFromCalled(address(l));
        assertEq(address(r), transferFromTo);
        assertEq(amount, transferFromAmount);
        // redeemZcToken check
        (bytes32 forgeIdCalled, uint256 maturityCalled) = p
            .redeemAfterExpiryCalled(underlying);
        assertEq(forgeId, forgeIdCalled);
        assertEq(maturity, maturityCalled);
        assertEq(
            keccak256(abi.encodePacked(forgeId)),
            keccak256(abi.encodePacked(forgeIdCalled))
        );
        (address underlyingCalled, uint256 amountCalled) = c.convertCalled(
            compoundingToken
        );
        assertEq(underlying, underlyingCalled);
        assertEq(amount, amountCalled);
    }

    function testTempusRedeem() public {
        mp.marketsReturns(address(tt));
        tt.poolReturns(address(tp));
        tp.maturityTimeReturns(maturity);
        tt.transferFromReturns(true);
        tt.balanceOfReturns(amount);

        r.redeem(5, underlying, maturity);

        // markets check
        (uint256 calledMaturity, uint256 calledPrincipal) = mp.marketsCalled(
            underlying
        );
        assertEq(maturity, calledMaturity);
        assertEq(5, calledPrincipal);
        // transferFrom check
        (address transferFromTo, uint256 transferFromAmount) = mock_erc20
            .ERC20(tt)
            .transferFromCalled(address(l));
        assertEq(address(r), transferFromTo);
        assertEq(amount, transferFromAmount);
        // redeemToBacking check
        (
            uint256 amountRedeemed,
            uint256 yieldRedeemed,
            address recipientRedeemed
        ) = t.redeemToBackingCalled(address(tp));
        assertEq(amountRedeemed, amount);
        assertEq(yieldRedeemed, 0);
        assertEq(recipientRedeemed, address(r));
    }

    function testSenseRedeem() public {
        uint256 starting = 1000;
        uint256 senseMaturity = maturity - 100;
        address target = address(yt); // just use an arbitrary token here
        mp.marketsReturns(address(st));
        mock_erc20.ERC20(underlying).allowanceReturns(11);
        sp.dividerReturns(address(sd));
        sd.adapterAddressesReturns(address(sa));
        sd.ptReturns(address(st));
        st.balanceOfReturns(amount);
        mock_erc20.ERC20(underlying).balanceOfReturns(starting);
        st.transferFromReturns(true);
        sa.targetReturns(target);
        mock_erc20.ERC20(target).balanceOfReturns(amount);

        r.redeem(6, underlying, maturity, senseMaturity, 199, address(sp));

        // markets check
        (uint256 calledMaturity, uint256 calledPrincipal) = mp.marketsCalled(
            underlying
        );
        assertEq(maturity, calledMaturity);
        assertEq(6, calledPrincipal);
        // transferFrom check
        (address transferFromTo, uint256 transferFromAmount) = mock_erc20
            .ERC20(st)
            .transferFromCalled(address(l));
        assertEq(address(r), transferFromTo);
        assertEq(amount, transferFromAmount);
        // redeem check
        (uint256 senseMaturityCalled, uint256 amountCalled) = sd.redeemCalled(
            address(sa)
        );
        assertEq(senseMaturityCalled, senseMaturity);
        assertEq(amountCalled, amount);
        // convert check
        (address underlyingCalled, uint256 convertAmount) = c.convertCalled(
            target
        );
        assertEq(underlying, underlyingCalled);
        assertEq(amount, convertAmount);
    }

    function testAPWineRedeem() public {
        mock_erc20.ERC20 ibt = new mock_erc20.ERC20();
        mock_erc20.ERC20 fyt = new mock_erc20.ERC20();
        fyt.balanceOfReturns(amount - 10);
        mp.marketsReturns(address(apwt));
        mp.iptReturns(address(ipt));
        ipt.maturityReturns(maturity);
        apwt.futureVaultReturns(address(apwfv));
        apwfv.getControllerAddressReturns(address(apwc));
        apwfv.getFYTofPeriodReturns(address(fyt));
        apwfv.getIBTAddressReturns(address(ibt));
        apwc.getNextPeriodStartReturns(maturity);
        apwt.transferFromReturns(true);
        apwt.balanceOfReturns(amount);

        r.redeem(7, underlying, maturity);

        // markets check
        (uint256 calledMaturity, uint256 calledPrincipal) = mp.marketsCalled(
            underlying
        );
        assertEq(maturity, calledMaturity);
        assertEq(7, calledPrincipal);
        // transferFrom check
        (address transferFromTo, uint256 transferFromAmount) = mock_erc20
            .ERC20(apwt)
            .transferFromCalled(address(l));
        assertEq(address(r), transferFromTo);
        assertEq(amount, transferFromAmount);
        // transfer FYTs lender -> redeemer check
        assertEq(amount - 10, l.transferFYTsCalled(address(fyt)));
        // withdraw check
        uint256 redeemed = apwc.withdrawCalled(address(apwfv));
        assertEq(redeemed, amount - 10);
    }

    function testNotionalRedeem() public {
        mp.marketsReturns(address(n));
        mp.iptReturns(address(ipt));
        n.getMaturityReturns(block.timestamp - 1);
        n.balanceOfReturns(amount);
        n.transferFromReturns(true);
        ipt.burnReturns(true);
        mock_erc20.ERC20(underlying).transferReturns(true);

        r.redeem(8, underlying, maturity);

        // markets check
        (uint256 calledMaturity, uint256 calledPrincipal) = mp.marketsCalled(
            underlying
        );
        assertEq(maturity, calledMaturity);
        assertEq(8, calledPrincipal);
        // transferFrom check
        (address transferFromTo, uint256 transferFromAmount) = mock_erc20
            .ERC20(n)
            .transferFromCalled(address(l));
        assertEq(address(r), transferFromTo);
        assertEq(amount, transferFromAmount);
        // redeem check
        (uint256 shares, address receiver) = n.redeemCalled(address(r));
        assertEq(amount, shares);
        assertEq(address(r), receiver);
    }

    function testFailPausedMarket() public {
        vm.startPrank(r.admin());
        r.pauseRedemptions(underlying, maturity, true);
        vm.stopPrank();

        vm.expectRevert(Exception.selector);
        r.redeem(underlying, maturity);
    }

    function testPartialRedemption() public {
        mp.iptReturns(address(ipt));
        ipt.balanceOfReturns(amount);
        ipt.transferFromReturns(true);
        ipt.totalSupplyReturns(amount);
        ipt.maturityReturns(maturity);
        mock_erc20.ERC20(underlying).transferReturns(true);
        l.illuminatePausedReturns(false);

        /// Setup holdings to have holdings by running a redemption
        mp.marketsReturns(address(swt));
        swt.maturityReturns(maturity);
        swt.balanceOfReturns(amount / 2);
        swt.transferFromReturns(true);
        sw.redeemZcTokenReturns(true);
        mock_erc20.ERC20(underlying).balanceOfReturns(amount / 2);
        r.redeem(1, underlying, maturity, 5);
        assertEq(r.holdings(underlying, maturity), amount / 2);

        r.redeem(underlying, maturity);
        // markets check
        (uint256 calledMaturity, uint256 calledPrincipal) = mp.iptCalled(
            underlying
        );
        assertEq(maturity, calledMaturity);
        assertEq(0, calledPrincipal);

        // burn check
        uint256 burnt = ipt.burnCalled(address(this));
        assertEq(burnt, amount);

        // transfer check
        uint256 sent = mock_erc20.ERC20(underlying).transferCalled(
            address(this)
        );
        assertEq(sent, amount / 2);

        // holdings check
        uint256 holdings = r.holdings(underlying, maturity);
        assertEq(holdings, 0);
    }

    function testFailInvalidPrincipal() public {
        address zero = address(0);
        // Swivel, Yield, Element, Pendle, APWine, Tempus and Notional
        vm.expectRevert(Exception.selector);
        r.redeem(uint8(0), address(0), 0);

        // Sense
        vm.expectRevert(
            abi.encodeWithSelector(Exception.selector, 6, 0, 0, zero, zero)
        );
        r.redeem(0, address(0), 0, 0, 0, address(0));
    }

    function testFailPausePrincipal() public {
        l.pausedReturns(true);

        vm.expectRevert(Exception.selector);
        r.redeem(uint8(0), address(0), 0);

        assertTrue(l.pausedCalled(uint8(0)));
    }

    function testPauseProtocol() public {
        l.illuminatePausedReturns(true);

        vm.expectRevert();
        r.redeem(address(0), 0);
    }
}
