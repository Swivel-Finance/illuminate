// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import 'src/tokens/ERC5095.sol';

import 'test/fork/Contracts.sol';

import 'src/Lender.sol' as l;
import 'src/MarketPlace.sol' as mp;
import 'src/Redeemer.sol' as r;
import 'src/Creator.sol' as c;

import 'forge-std/Test.sol';
using stdStorage for StdStorage;

contract ERC5095Test is Test {
    ERC5095 token;

    r.Redeemer redeemer;
    l.Lender lender;
    mp.MarketPlace marketplace;
    c.Creator creator;

    uint256 maturity = 2664550000;

    function setUp() public {
        creator = new c.Creator();
        lender = new l.Lender(address(0), address(0), address(0));
        redeemer = new r.Redeemer(
            address(lender),
            address(0),
            address(0),
            address(0)
        );
        marketplace = new mp.MarketPlace(address(redeemer), address(lender), address(creator));
        stdstore
            .target(address(marketplace))
            .sig('pools(address,uint256)')
            .with_key(Contracts.USDC)
            .with_key(maturity)
            .depth(0)
            .checked_write(Contracts.YIELD_POOL_USDC);
        redeemer.setMarketPlace(address(marketplace));

        token = new ERC5095(
            Contracts.USDC,
            maturity,
            address(redeemer),
            address(lender),
            address(marketplace),
            'Test 5095 Token',
            'T5095T',
            18
        );

        vm.startPrank(address(marketplace));
        token.setPool(Contracts.YIELD_POOL_USDC);
        vm.stopPrank();

        marketplace.setPrincipal(
            uint8(0),
            Contracts.USDC,
            maturity,
            address(token),
            address(0),
            address(0)
        );

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
        assertEq(token.maxRedeem(address(this)), amount);
    }

    function testMaxWithdraw() public {
        uint256 amount = 100000;
        deal(address(token), address(this), amount);
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
        stdstore
            .target(address(redeemer))
            .sig('holdings(address,uint256)')
            .with_key(Contracts.USDC)
            .with_key(maturity)
            .depth(0)
            .checked_write(100000);
        vm.startPrank(address(lender));
        token.authMint(address(this), 80000);
        vm.stopPrank();

        uint256 amount = 80000;
        assertGt(token.previewRedeem(amount), 0);

        vm.warp(maturity + 1);
        assertEq(token.previewRedeem(amount / 2), 40000);
    }

    function testPreviewWithdraw() public {
        stdstore
            .target(address(redeemer))
            .sig('holdings(address,uint256)')
            .with_key(Contracts.USDC)
            .with_key(maturity)
            .depth(0)
            .checked_write(80000);
        vm.startPrank(address(lender));
        token.authMint(address(this), 100000);
        vm.stopPrank();

        uint256 amount = 1000000;
        assertGt(token.previewWithdraw(amount / 2), 40000);

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
        deal(address(token), address(this), shares);
        token.withdraw(amount, address(this), address(this));
        assertGt(IERC20(Contracts.USDC).balanceOf(address(this)), 0);
    }

    function testWithdrawPostMaturity() public {
        vm.warp(maturity + 1);
        uint256 amount = 100000;
        uint256 shares = 120000;
        deal(address(Contracts.YIELD_TOKEN), address(token), shares);
        deal(address(token), address(this), shares, true);
        stdstore
            .target(address(redeemer))
            .sig('holdings(address,uint256)')
            .with_key(Contracts.USDC)
            .with_key(maturity)
            .depth(0)
            .checked_write(120000);

        deal(Contracts.USDC, address(redeemer), amount);
        token.withdraw(amount, address(this), address(this));
        assertGt(IERC20(Contracts.USDC).balanceOf(address(this)), 0);
    }

    function testRedeemPreMaturity() public {
        uint256 amount = 100000;
        uint256 shares = 120000;
        deal(address(Contracts.YIELD_TOKEN), address(token), shares);
        deal(address(token), address(this), shares);
        token.redeem(amount, address(this), address(this));
        assertGt(IERC20(Contracts.USDC).balanceOf(address(this)), 0);
    }

    function testRedeemPostMaturity() public {
        vm.warp(maturity + 1);
        uint256 amount = 100000;
        uint256 shares = 120000;
        deal(address(Contracts.YIELD_TOKEN), address(token), shares);
        deal(address(token), address(this), shares, true);
        stdstore
            .target(address(redeemer))
            .sig('holdings(address,uint256)')
            .with_key(Contracts.USDC)
            .with_key(maturity)
            .depth(0)
            .checked_write(120000);
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
