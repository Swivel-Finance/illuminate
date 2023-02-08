// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import 'forge-std/Test.sol';
using stdStorage for StdStorage;

import 'test/fork/Contracts.sol';

import 'src/Redeemer.sol';
import 'src/Lender.sol';
import 'src/Converter.sol';
import 'src/Creator.sol';

import 'test/lib/Hash.sol';

import 'src/interfaces/ISenseDivider.sol';

/* Note we test many protocols by checking if underlying balance is gt 0, post-
redemption. There might be a better way to approximate how much we expect.
*/

contract PendleTest is Test {
    Redeemer r;
    Lender l;
    MarketPlace mp;
    Converter c;
    Creator creator;

    uint256 fork;

    uint256 startingBalance = 100e18;
    uint256 maturity = 1680134400 + 100; 

    function setUp() public {
        // Fetch RPC URL and block number from environment
        string memory rpc = vm.envString('RPC_URL');
        // Create and select fork
        fork = vm.createSelectFork(rpc, Contracts.PENDLE_BLOCK);
        // Deploy converter
        c = new Converter();
        // Deploy creator
        creator = new Creator();
        // Deploy lender
        l = new Lender(Contracts.SWIVEL, Contracts.PENDLE, Contracts.APWINE_ROUTER);
        // Deploy redeemer
        r = new Redeemer(
            address(l),
            Contracts.SWIVEL, // swivel
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
    function deployMarket(address u) internal {
        // Set the addresses
        l.setMarketPlace(address(mp));
        r.setMarketPlace(address(mp));

        // Create a market
        address[8] memory contracts;
        contracts[3] = Contracts.PENDLE_TOKEN; // Pendle

        mp.createMarket(
            u,
            maturity,
            contracts,
            'TEST-TOKEN',
            'TEST',
            address(0), 
            address(0),
            address(0),
            address(0)
        );

        // Approve the redeemer from the lender
        l.approve(u, maturity, address(r));

        // Approve the Pendle router
        address[] memory underlyings = new address[](1);
        underlyings[0] = Contracts.USDC;
        address[] memory approvedContracts = new address[](1);
        approvedContracts[0] = Contracts.PENDLE;
        l.approve(underlyings, approvedContracts);
    }


    function runCheatcodes(address u) internal {
        // Give msg.sender some USDC to work with
        deal(u, msg.sender, startingBalance);
        assertEq(startingBalance, IERC20(u).balanceOf(msg.sender));

        vm.startPrank(msg.sender);

        // Approve lender to spend the underlying
        IERC20(u).approve(address(l), 2**256 - 1);
    }

    function testPendleLend() public {
        deployMarket(Contracts.USDC);

        runCheatcodes(Contracts.USDC);

        startingBalance = type(uint256).max;
        deal(Contracts.USDC, msg.sender, startingBalance / 4, true);
        IERC20(Contracts.USDC).approve(address(l), startingBalance);

        Pendle.ApproxParams memory guess = Pendle.ApproxParams(
            1, 
            type(uint256).max, 
            0, 
            256, 
            10**15
        );

        uint256 returned = l.lend(
            4, 
            Contracts.USDC, 
            maturity, 
            1000e6, 
            0, 
            guess, 
            Contracts.PENDLE_MARKET
        );

        // Make sure the principal tokens were transferred to the lender
        uint256 expectedPts = 1001_796919_373475_488437;
        assertEq(
            expectedPts,
            IERC20(Contracts.PENDLE_TOKEN).balanceOf(address(l))
        );

        // Make sure the same amount of iPTs were minted to the user
        address ipt = mp.markets(Contracts.USDC, maturity, 0);
        assertEq(returned, IERC20(ipt).balanceOf(msg.sender));
    }

    function testPendleRedeem() public {
        // deploy market
        vm.warp(maturity + 100);
        deployMarket(Contracts.USDC);

        uint balanceAmount = 100e18;

        // give lender principal tokens
        deal(Contracts.PENDLE_TOKEN, address(l), balanceAmount);

        vm.startPrank(msg.sender);

        // execute the redemption
        bool result = r.redeem(4, Contracts.USDC, maturity);
        assertTrue(result);

        // verify that the underlying is now held by the redeemer contract
        uint256 expected = 99_968702; // we get back slightly less than 100 usdc
        assertEq(IERC20(Contracts.USDC).balanceOf(address(r)), expected);

        // verify the lender no longer holds the principal token
        assertEq(IERC20(Contracts.PENDLE_TOKEN).balanceOf(address(l)), 0);
    }
}