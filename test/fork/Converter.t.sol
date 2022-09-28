// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import 'forge-std/Test.sol';
import 'test/fork/Contracts.sol';

import 'src/interfaces/IERC20.sol';

import 'src/Converter.sol';

contract ConverterTest is Test {
    uint256 amount = 500e7;
    Converter c;

    function setUp() public {
        c = new Converter();
    }

    // todo this test fails randomly due to safemath subtraction overflow
    function testAaveToken() public {
        address token = Contracts.AUSDC;
        deal(Contracts.USDC, msg.sender, amount);

        // Transfer aTokens to the msg.sender by calling deposit (deal does not work for aTokens)
        vm.startPrank(msg.sender);
        IERC20(Contracts.USDC).approve(Contracts.AAVE_POOL, 2**256 - 1);
        IAaveLendingPool(Contracts.AAVE_POOL).deposit(
            Contracts.USDC,
            amount,
            address(this),
            0 // ref code (disabled for now by aave, but could come back in the future)
        );
        vm.stopPrank();

        // approve transfer from converter test to converter contract
        vm.startPrank(address(this));
        IERC20(token).approve(address(c), 2**256 - 1);
        vm.stopPrank();

        // make sure aTokens are with the caller of convert
        assertEq(amount, IERC20(token).balanceOf(address(this)));
        // convert aTokens -> underlying (USDC)
        c.convert(token, Contracts.USDC, amount, 0);
        // make sure we got the underlying (USDC) back
        assertEq(amount, IERC20(Contracts.USDC).balanceOf(address(this)));
    }

    function testCompoundToken() public {
        address token = Contracts.CUSDC;
        // give caller cUSDC
        deal(token, address(this), amount, true);
        // make sure caller has cUSDC balance
        assertEq(amount, IERC20(token).balanceOf(address(this)));

        // approve transfer from converter test to converter contract
        vm.startPrank(address(this));
        IERC20(token).approve(address(c), 2**256 - 1);
        vm.stopPrank();

        // convert cUSDC -> USDC for the caller
        c.convert(token, Contracts.USDC, amount, 0);
        // compute expected amount
        uint256 expected = (amount *
            ICompoundToken(token).exchangeRateCurrent()) / 1e18;
        // caller should have USDC
        assertEq(expected, IERC20(Contracts.USDC).balanceOf(address(this)));
    }

    function testWrappedStakedEthSkip() public {
        address token = Contracts.WSTETH;
        // give caller wstETH
        deal(token, address(this), amount, true);
        // make sure caller has cUSDC balance
        assertEq(amount, IERC20(token).balanceOf(address(this)));

        // approve transfer from converter test to converter contract
        vm.startPrank(address(this));
        IERC20(token).approve(address(c), 2**256 - 1);
        vm.stopPrank();

        vm.startPrank(address(c));
        IERC20(token).approve(address(Contracts.UNISWAP_ROUTER), 2**256 - 1);
        vm.stopPrank();

        // compute expected amount
        uint256 minExpected = (amount * 9) / 10;
        // convert wstETH -> wETH for the caller
        c.convert(token, Contracts.WETH, amount, minExpected);
        // caller should have USDC
        assertGt(minExpected, IERC20(Contracts.WETH).balanceOf(address(this)));
    }
}
