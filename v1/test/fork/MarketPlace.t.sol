// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import 'forge-std/Test.sol';
import 'test/fork/Contracts.sol';
import 'test/lib/Hash.sol';

import 'src/MarketPlace.sol';

using stdStorage for StdStorage;

contract MarketPlaceTest is Test {
    MarketPlace mp;
    IPool pool;

    uint256 user1_sk =
        0x8882c68b373b93e91b80cef3ffced6b17a6fdabb210f09209bf5a76c9c8343cf;
    address user1_pk = 0x87FAB749498eCaE02db60079bfe51F012B71E96A;
    uint256 fork;

    uint256 maturity = 2664550000;
    uint256 startingBalance = 1000000;

    function setUp() public {
        // Fetch RPC URL and block number from environment
        string memory rpc = vm.envString('RPC_URL');
        uint256 blockNumber = 15682827; // use a recent block for the pool

        // Create and select fork
        fork = vm.createSelectFork(rpc, blockNumber);

        // Deploy a marketplace contract
        mp = new MarketPlace(address(0), address(0), address(0));

        // Set an existing pool from mainnnet
        stdstore
            .target(address(mp))
            .sig('pools(address,uint256)')
            .with_key(Contracts.USDC)
            .with_key(maturity)
            .depth(0)
            .checked_write(Contracts.YIELD_POOL_USDC_2);
        pool = IPool(Contracts.YIELD_POOL_USDC_2);
    }

    function runCheatcodes() internal {
        // Approve the marketplace to spend the user's tokens
        IERC20(pool.fyToken()).approve(address(mp), type(uint256).max);
        IERC20(Contracts.USDC).approve(address(mp), type(uint256).max);
        IERC20(address(pool)).approve(address(mp), type(uint256).max);
    }

    // swaps
    function testBuyUnderlying() public {
        runCheatcodes();
        uint256 needed = pool.buyBasePreview(uint128(startingBalance));
        deal(address(pool.fyToken()), address(this), needed);

        mp.buyUnderlying(
            Contracts.USDC,
            maturity,
            uint128(startingBalance),
            type(uint128).max
        );

        assertGt(IERC20(Contracts.USDC).balanceOf(address(this)), 0);
        assertEq(IERC20(pool.fyToken()).balanceOf(address(this)), 0);
    }

    function testBuyPrincipalToken() public {
        runCheatcodes();
        uint256 needed = pool.buyFYTokenPreview(uint128(startingBalance));
        deal(address(Contracts.USDC), address(this), needed);

        mp.buyPrincipalToken(
            Contracts.USDC,
            maturity,
            uint128(startingBalance),
            type(uint128).max
        );

        assertEq(IERC20(Contracts.USDC).balanceOf(address(this)), 0);
        assertEq(
            IERC20(pool.fyToken()).balanceOf(address(this)),
            startingBalance
        );
    }

    function testSellUnderlying() public {
        runCheatcodes();
        deal(Contracts.USDC, address(this), startingBalance);

        uint128 ptsBought = mp.sellUnderlying(
            Contracts.USDC,
            maturity,
            uint128(startingBalance),
            0
        );

        assertEq(IERC20(pool.fyToken()).balanceOf(address(this)), ptsBought);
    }

    function testSellPrincipalToken() public {
        runCheatcodes();
        deal(address(pool.fyToken()), address(this), startingBalance);

        uint128 underlyingBought = mp.sellPrincipalToken(
            Contracts.USDC,
            maturity,
            uint128(startingBalance),
            0
        );

        assertEq(
            IERC20(Contracts.USDC).balanceOf(address(this)),
            underlyingBought
        );
    }

    // burn
    function testBurn() public {
        runCheatcodes();
        deal(address(pool), address(this), startingBalance);

        (uint256 burnt, uint256 baseReceived, uint256 fyReceived) = mp.burn(
            Contracts.USDC,
            maturity,
            startingBalance / 2,
            0,
            type(uint256).max
        );

        assertEq(IERC20(Contracts.USDC).balanceOf(address(this)), baseReceived);
        assertEq(IERC20(pool.fyToken()).balanceOf(address(this)), fyReceived);
        assertEq(burnt, startingBalance / 2);
        assertEq(
            IERC20(address(pool)).balanceOf(address(this)),
            startingBalance - burnt
        );
    }

    function testBurnForUnderlying() public {
        runCheatcodes();
        deal(address(pool), address(this), startingBalance);

        (, uint256 baseReceived) = mp.burnForUnderlying(
            Contracts.USDC,
            maturity,
            startingBalance / 2,
            0,
            type(uint256).max
        );

        assertEq(IERC20(Contracts.USDC).balanceOf(address(this)), baseReceived);
        assertGt(baseReceived, startingBalance / 2);
        assertEq(IERC20(pool.fyToken()).balanceOf(address(this)), 0);
        assertEq(
            IERC20(address(pool)).balanceOf(address(this)),
            startingBalance / 2
        );
    }

    // mint
    function testMint() public {
        runCheatcodes();
        deal(Contracts.USDC, address(this), startingBalance);
        deal(address(pool.fyToken()), address(this), startingBalance);

        (, , uint256 minted) = mp.mint(
            Contracts.USDC,
            maturity,
            startingBalance,
            startingBalance / 3,
            0,
            type(uint256).max
        );

        assertEq(IERC20(address(pool)).balanceOf(address(this)), minted);
    }

    function testMintWithUnderlying() public {
        runCheatcodes();
        deal(Contracts.USDC, address(this), startingBalance);
        (, , uint256 lpTokensMinted) = mp.mintWithUnderlying(
            Contracts.USDC,
            maturity,
            startingBalance,
            startingBalance / 3,
            0,
            type(uint256).max
        );

        assertEq(
            IERC20(address(pool)).balanceOf(address(this)),
            lpTokensMinted
        );
    }

    function testFailSellPrincipalTokensSlippage() public {
        runCheatcodes();
        deal(address(pool.fyToken()), address(this), startingBalance);

        uint128 expectedUnderlying = pool.sellFYTokenPreview(
            uint128(startingBalance)
        );

        vm.expectRevert(Exception.selector);
        mp.sellPrincipalToken(
            Contracts.USDC,
            maturity,
            uint128(startingBalance),
            expectedUnderlying + 100
        );
    }

    function testFailBuyUnderlyingSlippage() public {
        runCheatcodes();
        deal(address(pool.fyToken()), address(this), startingBalance);

        uint128 expectedUnderlying = pool.buyBasePreview(
            uint128(startingBalance)
        );

        vm.expectRevert(Exception.selector);
        mp.sellPrincipalToken(
            Contracts.USDC,
            maturity,
            uint128(startingBalance),
            expectedUnderlying - 100
        );
    }
}
