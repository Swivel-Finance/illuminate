// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import 'forge-std/Test.sol';
using stdStorage for StdStorage;

import 'test/fork/Contracts.sol';

import 'src/Redeemer.sol';
import 'src/Lender.sol';
import 'src/Converter.sol';
import 'src/Creator.sol';

import 'src/interfaces/ISenseDivider.sol';

/* Note we test many protocols by checking if underlying balance is gt 0, post-
redemption. There might be a better way to approximate how much we expect.
*/

contract RedeemerTest is Test {
    Redeemer r;
    Lender l;
    MarketPlace mp;
    Converter c;
    Creator creator;

    uint256 fork;

    uint256 startingBalance = 100000;
    uint256 maturity = 12345; // Set very low maturity to pass the checks
    uint256 matured = 9664550000; // Teleport blockchain to a matured timestamp

    function setUp() public {
        // Fetch RPC URL and block number from environment
        string memory rpc = vm.envString('RPC_URL');
        uint256 blockNumber = vm.envUint('BLOCK_NUMBER');
        // Create and select fork
        fork = vm.createSelectFork(rpc, blockNumber);
        // Deploy creator
        creator = new Creator();
        // Deploy converter
        c = new Converter();
        // Deploy lender
        l = new Lender(Contracts.SWIVEL, Contracts.PENDLE, Contracts.APWINE_ROUTER);
        // Deploy redeemer
        r = new Redeemer(
            address(l),
            Contracts.SWIVEL, // swivel
            Contracts.PENDLE_ROUTER, // pendle
            Contracts.TEMPUS // tempus
        );
        // Deploy marketplace
        mp = new MarketPlace(address(r), address(l), address(creator));
        // Set the redeemer's converter
        r.setConverter(address(c), new address[](0));
        // Set the creator's marketplace
        creator.setMarketPlace(address(mp));
    }

    /// @param u underlying asset (e.g. USDC)
    /// @param t timestamp to skip to from current block.timestamp (ignored if 0)
    function deployMarket(address u, uint256 t) internal {
        // Set next block timestamp
        if (t != 0) {
            skip(t);
        } else {
            skip(matured);
        }

        // Set the addresses
        l.setMarketPlace(address(mp));
        r.setMarketPlace(address(mp));

        // Create a market
        address[8] memory contracts;
        contracts[0] = Contracts.SWIVEL_TOKEN; // Swivel
        contracts[1] = Contracts.YIELD_TOKEN; // Yield
        contracts[2] = Contracts.ELEMENT_TOKEN; // Element
        contracts[3] = Contracts.PENDLE_TOKEN; // Pendle
        contracts[4] = Contracts.TEMPUS_TOKEN; // Tempus
        contracts[5] = Contracts.SENSE_TOKEN; // Sense (note: this is a wstETH market)
        contracts[6] = Contracts.APWINE_TOKEN; // APWine
        contracts[7] = Contracts.NOTIONAL_TOKEN; // Notional

        mp.createMarket(
            u,
            maturity,
            contracts,
            'TEST-TOKEN',
            'TEST',
            Contracts.ELEMENT_VAULT,
            Contracts.APWINE_ROUTER,
            Contracts.WSTETH,
            Contracts.SENSE_PERIPHERY
        );

        // Approve the redeemer to spend the lender's principal tokens
        vm.startPrank(l.admin());
        l.approve(u, maturity, address(r));
        vm.stopPrank();
    }

    /// @param p token to be given to the lender contract
    /// @param i illuminate principal token, to be given to the redeemer
    /// @param u user's address (msg.sender of the redeem() method)
    /// @dev (i, u) are only needed for Illuminate's redeem
    function runCheatcodes(
        address p,
        address i,
        address u
    ) public {
        deal(p, address(l), startingBalance);

        deal(i, u, startingBalance);

        vm.startPrank(msg.sender);
    }

    function testIlluminateRedeem() public {
        // deploy market
        deployMarket(Contracts.USDC, 0);

        // give redeemer underlying tokens
        deal(Contracts.USDC, address(r), startingBalance);

        // update holdings by executing another redeem
        {
            address principalToken = Contracts.YIELD_TOKEN;

            // give lender principal tokens
            deal(principalToken, address(l), startingBalance);

            // execute the redemption
            r.redeem(2, Contracts.USDC, maturity);
        }

        // give msg.sender illuminate tokens
        address illuminateToken = mp.markets(Contracts.USDC, maturity, 0);
        deal(illuminateToken, msg.sender, startingBalance, true);

        // execute the redemption
        vm.startPrank(msg.sender);
        r.redeem(Contracts.USDC, maturity);
        vm.stopPrank();

        // verify user received their tokens
        assertEq(IERC20(Contracts.USDC).balanceOf(msg.sender), startingBalance);

        // verify that the user's illuminate tokens were burned
        assertEq(IERC20(illuminateToken).balanceOf(msg.sender), 0);
    }

    function testYieldRedeem() public {
        address principalToken = Contracts.YIELD_TOKEN;

        deployMarket(Contracts.USDC, 0);

        // give lender principal tokens
        deal(principalToken, address(l), startingBalance);

        // execute the redemption
        r.redeem(2, Contracts.USDC, maturity);

        // verify that the underlying is now held by the redeemer contract
        assertEq(IERC20(Contracts.USDC).balanceOf(address(r)), startingBalance);

        // verify the lender no longer holds the principal token
        assertEq(IERC20(principalToken).balanceOf(address(l)), 0);
    }

    function testElementRedeem() public {
        address principalToken = Contracts.ELEMENT_TOKEN;

        deployMarket(Contracts.USDC, 0);

        // give lender principal tokens
        deal(principalToken, address(l), startingBalance);

        // execute the redemption
        r.redeem(3, Contracts.USDC, maturity);

        // verify that the underlying is now held by the redeemer contract
        assertGt(IERC20(Contracts.USDC).balanceOf(address(r)), 0);

        // verify the lender no longer holds the principal token
        assertEq(IERC20(principalToken).balanceOf(address(l)), 0);
    }

    function testNotionalRedeem() public {
        address principalToken = Contracts.NOTIONAL_TOKEN;

        deployMarket(Contracts.DAI, 0);

        // give lender principal tokens
        deal(principalToken, address(l), startingBalance);

        // execute the redemption
        r.redeem(8, Contracts.DAI, maturity);

        // verify that the underlying is now held by the redeemer contract
        assertGt(IERC20(Contracts.DAI).balanceOf(address(r)), 0);

        // verify the lender no longer holds the principal token
        assertEq(IERC20(principalToken).balanceOf(address(l)), 0);
    }

    function testTempusRedeem() public {
        address principalToken = Contracts.TEMPUS_TOKEN;

        deployMarket(Contracts.USDC, 0);

        // give lender principal tokens
        deal(principalToken, address(l), startingBalance);

        // execute the redemption
        r.redeem(5, Contracts.USDC, maturity);

        // verify that the underlying is now held by the redeemer contract
        assertGt(IERC20(Contracts.USDC).balanceOf(address(r)), 0);

        // verify the lender no longer holds the principal token
        assertEq(IERC20(principalToken).balanceOf(address(l)), 0);
    }

    function testAPWineRedeem() public {
        address principalToken = Contracts.APWINE_TOKEN;
        deployMarket(Contracts.USDT, 0);

        deal(Contracts.USDT, address(this), startingBalance);

        // Swap for APWine PTs
        uint256[] memory pairPath = new uint256[](1);
        pairPath[0] = 0;
        uint256[] memory tokenPath = new uint256[](2);
        tokenPath[0] = 1;
        tokenPath[1] = 0;
        Safe.approve(IERC20(Contracts.USDT), Contracts.APWINE_ROUTER, type(uint256).max);
        IAPWineRouter(Contracts.APWINE_ROUTER).swapExactAmountIn(
            Contracts.APWINE_AMM_POOL,
            pairPath,
            tokenPath,
            startingBalance,
            0,
            address(address(l)),
            type(uint256).max,
            address(0)
        );

        // Launch a new period (to make the PTs redeemable)
        vm.startPrank(Contracts.APWINE_CONTROLLER);
        IAPWineFutureVault(Contracts.APWINE_FUTURE_VAULT).startNewPeriod();
        vm.stopPrank();

        // execute the redemption
        r.redeem(7, Contracts.USDT, maturity);
        // verify that the underlying is now held by the redeemer contract
        assertGt(IERC20(Contracts.USDT).balanceOf(address(r)), 0);
        // verify the lender no longer holds the principal token
        assertEq(IERC20(principalToken).balanceOf(address(l)), 0);
    }

    function testSenseRedeem() public {
        address principalToken = Contracts.SENSE_TOKEN;


        // set timestamp between 3 and 6 hours after maturity
        deployMarket(Contracts.STETH, 0);

        // give lender principal tokens
        deal(Contracts.SENSE_TOKEN, address(l), startingBalance);

        // set the timestamp within the settlement window for the series sponsor
        uint256 settledTimestamp = Contracts.SENSE_MATURITY + 1 minutes;
        vm.warp(settledTimestamp);

        // only the sponsor can settle the series
        address sponsor = 0xe09fE5ACb74c1d98507f87494Cf6AdEBD3B26b1e;
        vm.startPrank(sponsor);
        ISenseDivider(Contracts.SENSE_DIVIDER).settleSeries(
            Contracts.SENSE_ADAPTER,
            Contracts.SENSE_MATURITY
        );
        vm.stopPrank();

        // execute the redemption
        r.redeem(
            6,
            Contracts.STETH,
            maturity,
            Contracts.SENSE_MATURITY,
            7,
            Contracts.SENSE_PERIPHERY
        );

        // verify that the underlying is now held by the redeemer contract
        assertGt(IERC20(Contracts.STETH).balanceOf(address(r)), 0);
        // verify the lender no longer holds the principal token
        assertEq(IERC20(principalToken).balanceOf(address(l)), 0);
    }

    function testPendleRedeem() public {
        deployMarket(Contracts.USDC, 0);

        // give lender principal tokens
        address principalToken = Contracts.PENDLE_TOKEN;
        deal(principalToken, address(l), startingBalance);

        // execute the redemption
        r.redeem(4, Contracts.USDC, maturity);

        // verify that the underlying is now held by the redeemer contract
        // note in the case of pendle, the compounding token is redeemed,
        // not the underlying asset for the given market
        assertGt(IERC20(Contracts.USDC).balanceOf(address(r)), 0);
        // verify the lender no longer holds the principal token
        assertEq(IERC20(principalToken).balanceOf(address(l)), 0);
    }

    function testAutoRedeem() public {
        deployMarket(Contracts.USDC, 0);

        address user = 0x7111F9Aeb2C1b9344EC274780dc9e3806bdc60Ef;

        address principalToken = mp.markets(Contracts.USDC, maturity, 0);

        // starting balances
        deal(principalToken, user, startingBalance, true);
        deal(Contracts.USDC, address(r), startingBalance);
        // update holdings
        stdstore
            .target(address(r))
            .sig('holdings(address,uint256)')
            .with_key(Contracts.USDC).with_key(maturity)
            .depth(0)
            .checked_write(startingBalance);

        vm.startPrank(user);
        IERC20(principalToken).approve(address(r), startingBalance);
        vm.stopPrank();

        // call autoRedeem
        address[] memory onBehalfOf = new address[](1);
        onBehalfOf[0] = user;

        uint256 fee = r.autoRedeem(Contracts.USDC, maturity, onBehalfOf);

        // check balances
        assertEq(IERC20(Contracts.USDC).balanceOf(address(r)), 0);
        assertEq(IERC20(Contracts.USDC).balanceOf(user), startingBalance - fee);
        assertEq(IERC20(principalToken).balanceOf(user), 0);
        assertEq(IERC20(Contracts.USDC).balanceOf(address(this)), fee);
    }

    function testFailAutoRedeemInsufficientAllowance() public {
        deployMarket(Contracts.USDC, 0);

        address user = 0x7111F9Aeb2C1b9344EC274780dc9e3806bdc60Ef;

        address principalToken = mp.markets(Contracts.USDC, maturity, 0);

        // starting balances
        deal(principalToken, user, startingBalance);
        deal(Contracts.USDC, address(r), startingBalance);

        // call autoRedeem
        address[] memory onBehalfOf = new address[](1);
        onBehalfOf[0] = user;

        vm.expectRevert(Exception.selector);
        r.autoRedeem(Contracts.USDC, maturity, onBehalfOf);
    }

    function testFailPausedPrincipal() public {
        deployMarket(Contracts.USDC, 0);

        // give lender principal tokens
        address principalToken = Contracts.PENDLE_TOKEN;
        deal(principalToken, address(l), startingBalance);

        // pause the principal
        l.pause(uint8(MarketPlace.Principals.Pendle), true);

        // execute the redemption
        vm.expectRevert(Exception.selector);
        r.redeem(4, Contracts.USDC, maturity);
    }

    function testFailIlluminatePaused() public {
        // Pause the contract
        l.pauseIlluminate(true);

        vm.expectRevert(Exception.selector);
        r.redeem(4, Contracts.USDC, maturity);
    }
}
