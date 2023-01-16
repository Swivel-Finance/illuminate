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

contract SwivelTest is Test {
    uint256 user1_sk =
        0x8882c68b373b93e91b80cef3ffced6b17a6fdabb210f09209bf5a76c9c8343cf;
    address user1_pk = 0x87FAB749498eCaE02db60079bfe51F012B71E96A;

    Redeemer r;
    Lender l;
    MarketPlace mp;
    Converter c;
    Creator creator;

    uint256 fork;

    uint256 startingBalance = 100000;
    uint256 maturity = 1680274800 + 100; // Set very low maturity to pass the checks

    address constant swivelPt = 0x3476303e9038833AeC9ccCd12747BD0E0d026a8B;

    function setUp() public {
        // Fetch RPC URL and block number from environment
        string memory rpc = vm.envString('RPC_URL');
        // Create and select fork
        fork = vm.createSelectFork(rpc, Contracts.SWIVEL_BLOCK);
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
    function deployMarket(address u) internal {
        // Set the addresses
        l.setMarketPlace(address(mp));
        r.setMarketPlace(address(mp));

        // Create a market
        address[8] memory contracts;
        contracts[0] = swivelPt; // Swivel

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
    }


    function runCheatcodes(address u) internal {
        // Give msg.sender some USDC to work with
        deal(u, msg.sender, startingBalance);
        assertEq(startingBalance, IERC20(u).balanceOf(msg.sender));

        vm.startPrank(msg.sender);

        // Approve lender to spend the underlying
        IERC20(u).approve(address(l), 2**256 - 1);
    }

    function testSwivelLend() public {
        vm.startPrank(user1_pk);
        IERC20(Contracts.USDC).approve(Contracts.SWIVEL, type(uint256).max);
        vm.stopPrank();

        deployMarket(Contracts.USDC);

        runCheatcodes(Contracts.USDC);

        startingBalance = type(uint256).max;
        deal(Contracts.USDC, user1_pk, startingBalance / 4, true);
        deal(Contracts.USDC, msg.sender, startingBalance / 4, true);
        IERC20(Contracts.USDC).approve(address(l), startingBalance);

        Swivel.Order[] memory orders = new Swivel.Order[](1);
        Swivel.Components[] memory signatures = new Swivel.Components[](1);
        uint256[] memory amounts = new uint256[](1);

        bytes32 key;
        orders[0] = Swivel.Order(
            key, // key
            5, // protocol
            user1_pk, // maker
            Contracts.USDC, // underlying
            true, // vault
            false, // exit
            50e6, // principal
            1040, // premium
            1680274800, // maturity
            1680274800 // expiry
        );

        Hash.Order memory ord = Hash.Order(
            orders[0].key,
            orders[0].protocol,
            orders[0].maker,
            orders[0].underlying,
            orders[0].vault,
            orders[0].exit,
            orders[0].principal,
            orders[0].premium,
            orders[0].maturity,
            orders[0].expiry
        );

        bytes32 messageDigest = Hash.message(
            Hash.DOMAIN_TYPEHASH,
            Hash.order(ord)
        );

        {
            (uint8 v, bytes32 r1, bytes32 s) = vm.sign(user1_sk, messageDigest);
            signatures[0] = Swivel.Components(v, r1, s);
        }
        amounts[0] = 50e5;

        uint256 returned = l.lend(
            uint8(MarketPlace.Principals.Swivel),
            Contracts.USDC,
            maturity,
            amounts,
            Contracts.YIELD_POOL_USDC,
            orders,
            signatures,
            false,
            0
        );

        // Make sure the principal tokens were transferred to the lender
        assertEq(
            amounts[0] - amounts[0] / l.feenominator(),
            IERC20(swivelPt).balanceOf(address(l))
        );

        // Make sure the same amount of iPTs were minted to the user
        address ipt = mp.markets(Contracts.USDC, maturity, 0);
        assertEq(returned, IERC20(ipt).balanceOf(msg.sender));
    }

    // NOTE Test is skipped due to being unable to deal to EToken for the market
    function testSwivelRedeemSkip() public {
        // deploy market
        vm.warp(maturity + 100);
        deployMarket(Contracts.USDC);

        uint balanceAmount = 10e9;

        // give lender principal tokens
        deal(swivelPt, address(l), balanceAmount);

        // give the euler token to the swivel contract
        // deal(0xbb0D4bb654a21054aF95456a3B29c63e8D1F4c0a, Contracts.SWIVEL, balanceAmount * 10);

        vm.startPrank(msg.sender);

        // execute the redemption
        bool result = r.redeem(1, Contracts.USDC, maturity, 5);
        assertTrue(result);

        // verify that the underlying is now held by the redeemer contract
        assertEq(IERC20(Contracts.USDC).balanceOf(address(r)), balanceAmount - 1);

        // verify the lender no longer holds the principal token
        assertEq(IERC20(swivelPt).balanceOf(address(l)), 0);
    }
}