// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import 'forge-std/Test.sol';

import 'test/fork/Contracts.sol';

import 'src/Redeemer.sol';
import 'src/Lender.sol';
import 'src/Converter.sol';

import 'src/interfaces/ISenseDivider.sol';

/* Note we test many protocols by checking if underlying balance is gt 0, post-
redemption. There might be a better way to approximate how much we expect.
*/

contract RedeemerTest is Test {
    Redeemer r;
    Lender l;
    MarketPlace mp;
    Converter c;

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
        // Deploy converter
        c = new Converter();
        // Deploy lender
        l = new Lender(Contracts.SWIVEL, Contracts.PENDLE, Contracts.TEMPUS);
        // Deploy redeemer
        r = new Redeemer(
            address(l),
            Contracts.SWIVEL, // swivel
            Contracts.PENDLE_ROUTER, // pendle
            Contracts.TEMPUS, // tempus
            Contracts.APWINE_CONTROLLER // apwine
        );
        // Deploy marketplace
        mp = new MarketPlace(address(r), address(l));
        // Set the redeemer's converter
        r.setConverter(address(c));
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
        contracts[5] = Contracts.SENSE_ADAPTER; // Sense (note: this is a wstETH market)
        contracts[6] = Contracts.APWINE_AMM_POOL; // APWine
        contracts[7] = Contracts.NOTIONAL_TOKEN; // Notional

        mp.createMarket(
            u,
            maturity,
            contracts,
            'TEST-TOKEN',
            'TEST',
            18,
            Contracts.ELEMENT_VAULT,
            Contracts.APWINE_ROUTER
        );
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

            // approve lender to transfer principal tokens
            vm.startPrank(address(l));
            IERC20(principalToken).approve(address(r), startingBalance);
            vm.stopPrank();

            vm.startPrank(msg.sender);

            // execute the redemption
            r.redeem(2, Contracts.USDC, maturity);
            vm.stopPrank();
        }
        // give user illuminate tokens
        address illuminateToken = mp.markets(Contracts.USDC, maturity, 0);
        deal(illuminateToken, msg.sender, startingBalance, true);

        // run the contract from msg.sender
        vm.startPrank(msg.sender);

        // execute the redemption
        r.redeem(Contracts.USDC, maturity);
        vm.stopPrank();

        // verify user received their tokens
        assertEq(IERC20(Contracts.USDC).balanceOf(msg.sender), startingBalance);

        // verify that the user's illuminate tokens were burned
        assertEq(IERC20(illuminateToken).balanceOf(msg.sender), 0);
    }

    function testSwivelRedeem() public {
        address principalToken = Contracts.SWIVEL_TOKEN;

        // deploy market
        deployMarket(Contracts.USDC, 0);

        // give lender principal tokens
        deal(principalToken, address(l), startingBalance);

        // approve lender to transfer principal tokens
        vm.startPrank(address(l));
        IERC20(principalToken).approve(address(r), startingBalance);
        vm.stopPrank();

        vm.startPrank(msg.sender);

        // TODO once swivel is unpaused.
        // execute the redemption
        // bool result = r.redeem(1, Contracts.USDC, maturity);
        // assertTrue(result);

        // verify that the underlying is now held by the redeemer contract
        // assertEq(IERC20(Contracts.USDC).balanceOf(address(r)), startingBalance);

        // verify the lender no longer holds the principal token
        // assertEq(IERC20(Contracts.principalToken).balanceOf(address(l)), 0);
    }

    function testYieldRedeem() public {
        address principalToken = Contracts.YIELD_TOKEN;

        deployMarket(Contracts.USDC, 0);

        // give lender principal tokens
        deal(principalToken, address(l), startingBalance);

        // approve lender to transfer principal tokens
        vm.startPrank(address(l));
        IERC20(principalToken).approve(address(r), startingBalance);
        vm.stopPrank();

        vm.startPrank(msg.sender);

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

        // approve lender to transfer principal tokens
        vm.startPrank(address(l));
        IERC20(principalToken).approve(address(r), startingBalance);
        vm.stopPrank();

        vm.startPrank(msg.sender);

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

        // approve lender to transfer principal tokens
        vm.startPrank(address(l));
        IERC20(principalToken).approve(address(r), startingBalance);
        vm.stopPrank();

        vm.startPrank(msg.sender);

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

        // approve lender to transfer principal tokens
        vm.startPrank(address(l));
        IERC20(principalToken).approve(address(r), startingBalance);
        vm.stopPrank();

        vm.startPrank(msg.sender);

        // execute the redemption
        r.redeem(5, Contracts.USDC, maturity);

        // verify that the underlying is now held by the redeemer contract
        assertGt(IERC20(Contracts.USDC).balanceOf(address(r)), 0);

        // verify the lender no longer holds the principal token
        assertEq(IERC20(principalToken).balanceOf(address(l)), 0);
    }

    // todo find out what's wrong here (slots not found in APWine pt)
    // currently getting FutureVault: ERR_FYT_AMOUNT
    function testAPWineRedeemSkip() public {
        address principalToken = Contracts.APWINE_TOKEN;
        // Move block.timestamp well into the future
        skip(matured);

        // Gets PTs to the lender contract by executing a lend operation
        // Set the addresses
        l.setMarketPlace(address(mp));
        r.setMarketPlace(address(mp));
        // Create a special market for apwine
        address[8] memory contracts;
        contracts[0] = Contracts.SWIVEL_TOKEN; // Swivel
        contracts[1] = Contracts.YIELD_TOKEN; // Yield
        contracts[2] = Contracts.ELEMENT_TOKEN; // Element
        contracts[3] = Contracts.PENDLE_TOKEN; // Pendle
        contracts[4] = Contracts.TEMPUS_TOKEN; // Tempus
        contracts[5] = Contracts.SENSE_ADAPTER; // Sense (note: this is a wstETH market)
        contracts[6] = Contracts.APWINE_AMM_POOL; // APWine
        contracts[7] = Contracts.NOTIONAL_TOKEN; // Notional
        mp.createMarket(
            Contracts.USDC,
            block.timestamp,
            contracts,
            'TEST-TOKEN',
            'TEST',
            18,
            Contracts.ELEMENT_VAULT,
            Contracts.APWINE_ROUTER
        );
        // Give msg.sender some USDC to work with
        deal(Contracts.USDC, address(this), startingBalance);
        assertEq(startingBalance, IERC20(Contracts.USDC).balanceOf(msg.sender));
        vm.startPrank(address(this));
        // Approve lender to spend the underlying
        IERC20(Contracts.USDC).approve(address(l), 2**256 - 1);
        vm.stopPrank();
        //give lender principal tokens
        l.lend(
            uint8(7),
            Contracts.USDC,
            block.timestamp,
            100000,
            0, // minReturn
            2**256 - 1, // deadline
            Contracts.APWINE_ROUTER
        );
        assertGt(IERC20(principalToken).balanceOf(address(l)), 100000);

        // approve lender to transfer principal tokens
        vm.startPrank(address(l));
        IERC20(principalToken).approve(address(r), 2**256 - 1);
        vm.stopPrank();
        vm.startPrank(msg.sender);

        // execute the redemption
        r.redeem(7, Contracts.USDC, block.timestamp);
        // verify that the underlying is now held by the redeemer contract
        assertGt(IERC20(Contracts.USDC).balanceOf(address(r)), 0);
        // verify the lender no longer holds the principal token
        assertEq(IERC20(principalToken).balanceOf(address(l)), 0);
    }

    function testSenseRedeemSkip() public {
        // note for sense, we provide the adapter
        // note to get token, get divider from adapter and then pt from divider
        address principalToken = Contracts.SENSE_ADAPTER;

        uint256 settledTimestamp = Contracts.SENSE_VALID_SETTLEMENT_TS -
            block.timestamp;
        deployMarket(Contracts.WETH, settledTimestamp);
        assertEq(block.timestamp, Contracts.SENSE_VALID_SETTLEMENT_TS);

        // give lender principal tokens
        deal(Contracts.SENSE_TOKEN, address(l), startingBalance);

        // settle the series
        ISenseDivider(Contracts.SENSE_DIVIDER).settleSeries(
            principalToken,
            Contracts.SENSE_MATURITY
        );

        // approve redeemer to spend lender's tokens
        vm.startPrank(address(l));
        IERC20(Contracts.SENSE_TOKEN).approve(address(r), startingBalance);
        vm.stopPrank();

        // execute the redemption
        r.redeem(6, Contracts.WETH, maturity, Contracts.SENSE_MATURITY);

        // verify that the underlying is now held by the redeemer contract
        assertGt(IERC20(Contracts.WETH).balanceOf(address(r)), 0);
        // verify the lender no longer holds the principal token
        assertEq(IERC20(principalToken).balanceOf(address(l)), 0);
    }

    function testPendleRedeem() public {
        address principalToken = Contracts.PENDLE_TOKEN;

        deployMarket(Contracts.USDC, 0);

        // give lender principal tokens
        deal(principalToken, address(l), startingBalance);

        // approve redeemer to spend lender's tokens
        vm.startPrank(address(l));
        IERC20(principalToken).approve(address(r), startingBalance);
        vm.stopPrank();

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
        deal(principalToken, user, startingBalance);
        deal(Contracts.USDC, address(r), startingBalance);

        vm.startPrank(user);
        IERC20(Contracts.USDC).approve(address(r), startingBalance / 2);
        vm.stopPrank();

        // call autoRedeem
        uint256[] memory amounts = new uint256[](1);
        amounts[0] = startingBalance / 4;
        address[] memory onBehalfOf = new address[](1);
        onBehalfOf[0] = user;

        uint256 fee = r.autoRedeem(
            Contracts.USDC,
            maturity,
            onBehalfOf,
            amounts
        );

        // check balances
        assertEq(
            IERC20(Contracts.USDC).balanceOf(user),
            (startingBalance / 4) - fee
        );
        assertEq(
            IERC20(Contracts.USDC).balanceOf(address(r)),
            (startingBalance * 3) / 4
        );
        assertEq(
            IERC20(principalToken).balanceOf(user),
            (startingBalance * 3) / 4
        );
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
        uint256[] memory amounts = new uint256[](1);
        amounts[0] = startingBalance / 4;
        address[] memory onBehalfOf = new address[](1);
        onBehalfOf[0] = user;

        vm.expectRevert(Exception.selector);
        r.autoRedeem(Contracts.USDC, maturity, onBehalfOf, amounts);
    }
}
