// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import 'src/tokens/ERC5095.sol';

import 'test/fork/Contracts.sol';

import 'src/Lender.sol' as l;
import 'src/MarketPlace.sol' as mp;
import 'src/Redeemer.sol' as r;

import 'forge-std/Test.sol';

contract ERC5095Test is Test {
    ERC5095 token;

    r.Redeemer redeemer;
    address lender;
    mp.MarketPlace marketplace;

    uint256 maturity = 2664550000;

    function setUp() public {
        lender = address(new l.Lender(address(0), address(0), address(0)));
        redeemer = new r.Redeemer(
            address(0),
            address(0),
            address(0),
            address(0),
            address(0)
        );
        marketplace = new mp.MarketPlace(address(redeemer), lender);
        marketplace.setPool(
            Contracts.USDC,
            maturity,
            Contracts.YIELD_POOL_USDC
        );
        redeemer.setMarketPlace(address(marketplace));

        console.log('pool', marketplace.pools(Contracts.USDC, maturity));
        console.log('yield pool', Contracts.YIELD_POOL_USDC);

        token = new ERC5095(
            Contracts.USDC,
            maturity,
            address(redeemer),
            lender,
            address(marketplace),
            'Test 5095 Token',
            'T5095T',
            18
        );

        marketplace.setPrincipal(
            uint8(0),
            Contracts.USDC,
            maturity,
            address(token)
        );
        console.log('got here');

        // approve for pool interactions
        IERC20(Contracts.USDC).approve(address(token), type(uint256).max);
        IERC20(address(token)).approve(address(token), type(uint256).max);
        vm.startPrank(address(token));
        IERC20(Contracts.USDC).approve(address(marketplace), type(uint256).max);
        IERC20(Contracts.YIELD_TOKEN).approve(
            address(marketplace),
            type(uint256).max
        );
        vm.stopPrank();
    }

    function testTokenBasics() public {
        assertEq(token.name(), 'Test 5095 Token');
        assertEq(token.symbol(), 'T5095T');
        assertEq(token.decimals(), 18);
    }

    function testConvertToUnderlying() public {
        uint256 amount = token.convertToUnderlying(100);
        assertGt(amount, 0);
        assertLt(amount, 100);

        vm.warp(maturity + 1);
        amount = token.convertToUnderlying(100);
        assertEq(amount, 100);
    }

    function testConvertToShares() public {
        uint256 amount = token.convertToShares(100);
        assertGt(amount, 100);

        vm.warp(maturity + 1);
        amount = token.convertToShares(100);
        assertEq(amount, 100);
    }

    function testMaxRedeem() public {
        uint256 amount = 100000;
        deal(address(token), address(this), amount);
        assertGt(token.maxRedeem(address(this)), 0);

        vm.warp(maturity + 1);
        assertEq(token.maxRedeem(address(this)), amount);
    }

    function testMaxWithdraw() public {
        uint256 amount = 100000;
        deal(address(token), address(token), amount);
        assertGt(token.maxWithdraw(address(this)), 0);

        vm.warp(maturity + 1);
        deal(address(token), address(this), amount);
        assertEq(token.maxWithdraw(address(this)), amount);
    }

    function testPreviewDeposit() public {
        uint256 amount = token.previewDeposit(1000);
        assertGt(amount, 0);

        vm.warp(maturity + 1);
        assertEq(0, token.previewDeposit(100));
    }

    function testPreviewMint() public {
        uint256 amount = token.previewMint(1000);
        assertGt(amount, 0);

        vm.warp(maturity + 1);
        assertEq(0, token.previewMint(100));
    }

    function testPreviewRedeem() public {
        uint256 amount = 100000;
        assertGt(token.previewRedeem(amount), 0);

        vm.warp(maturity + 1);
        assertEq(token.previewRedeem(amount), amount);
    }

    function testPreviewWithdraw() public {
        uint256 amount = 1000000;
        assertGt(token.previewWithdraw(amount), amount);

        vm.warp(maturity + 1);
        assertGt(token.previewWithdraw(amount), 0);
    }

    function testDeposit() public {
        uint256 amount = 100000;
        deal(Contracts.USDC, address(this), amount);
        deal(address(token), address(token), amount * 2);
        token.deposit(address(this), amount);
        assertEq(IERC20(Contracts.USDC).balanceOf(address(this)), 0);
        assertGt(IERC20(address(token)).balanceOf(address(this)), 0);
    }

    function testMint() public {
        uint256 amount = 100000;
        deal(Contracts.USDC, address(this), amount);
        deal(address(token), address(token), amount * 2);
        token.mint(address(this), amount);
        assertGt(IERC20(address(token)).balanceOf(address(this)), 0);
    }

    function testFailTooLate() public {
        vm.warp(maturity + 1);
        vm.expectRevert(Exception.selector);
        token.deposit(address(this), 100000);

        vm.expectRevert(Exception.selector);
        token.mint(address(this), 100000);
    }

    function testWithdrawPreMaturity() public {
        uint256 amount = 100000;
        uint256 shares = 120000;
        deal(address(Contracts.YIELD_TOKEN), address(token), shares);
        token.withdraw(amount, address(this), address(this));
        assertGt(IERC20(Contracts.USDC).balanceOf(address(this)), 0);
    }

    function testWithdrawPostMaturity() public {
        vm.warp(maturity + 1);
        uint256 amount = 100000;
        uint256 shares = 120000;
        deal(address(Contracts.YIELD_TOKEN), address(token), shares);
        deal(address(token), address(this), shares);
        deal(Contracts.USDC, address(redeemer), amount);
        token.withdraw(amount, address(this), address(this));
        assertGt(IERC20(Contracts.USDC).balanceOf(address(this)), 0);
    }

    function testRedeemPreMaturity() public {
        uint256 amount = 100000;
        uint256 shares = 120000;
        deal(address(Contracts.YIELD_TOKEN), address(token), shares);
        token.redeem(amount, address(this), address(this));
        assertGt(IERC20(Contracts.USDC).balanceOf(address(this)), 0);
    }

    function testRedeemPostMaturity() public {
        vm.warp(maturity + 1);
        uint256 amount = 100000;
        uint256 shares = 120000;
        deal(address(Contracts.YIELD_TOKEN), address(token), shares);
        deal(address(token), address(this), shares);
        deal(Contracts.USDC, address(redeemer), amount);
        token.redeem(amount, address(this), address(this));
        assertGt(IERC20(Contracts.USDC).balanceOf(address(this)), 0);
    }

    function testAuthMint() public {
        uint256 amount = 100000;
        vm.startPrank(address(lender));
        token.authMint(msg.sender, amount);
        vm.stopPrank();
        assertEq(IERC20(address(token)).balanceOf(msg.sender), amount);
    }

    function testFailAuths() public {
        vm.expectRevert(Exception.selector);
        token.authMint(msg.sender, 100000);

        vm.expectRevert(Exception.selector);
        token.authBurn(msg.sender, 1000);
    }

    function testAuthBurn() public {
        uint256 amount = 100000;
        deal(address(token), msg.sender, amount);
        vm.startPrank(address(redeemer));
        token.authBurn(msg.sender, amount);
        vm.stopPrank();
        assertEq(IERC20(address(token)).balanceOf(msg.sender), 0);
    }
}
