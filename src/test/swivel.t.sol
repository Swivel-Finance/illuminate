// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import "forge-std/Test.sol";
import "forge-std/console.sol";

// import all major contracts
import "../Converter.sol";
import "../Lender.sol";
import "../Creator.sol";
import "../ETHWrapper.sol";
import "../Redeemer.sol";
 
// import adapters
import "../adapters/SwivelAdapter.sol"; 
import "../adapters/YieldAdapter.sol";

import "../lib/Hash.sol";

contract SwivelTest is Test {

    uint256 user1_sk = 0x8882c68b373b93e91b80cef3ffced6b17a6fdabb210f09209bf5a76c9c8343cf;
    address user1_pk = 0x87FAB749498eCaE02db60079bfe51F012B71E96A;

    address USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    uint256 maturity = 1704975690;

    address swivelDecember = 0xA7E982740200ca6bd5f4dCf17599389A02185292;

    address swivel = 0x373a06bD3067f8DA90239a47f316F09312b7800F;

    address userPublicKey = 0x3f60008Dfd0EfC03F476D9B489D6C5B13B3eBF2C;

    uint256 startingBalance = 100000 ether;

    Creator creator;
    Converter converter;
    ETHWrapper ethWrapper;
    Lender lender;
    Redeemer redeemer;
    MarketPlace marketplace;

    function setUp() public {

        // Deploy all major contracts
        creator = new Creator();
        converter = new Converter();
        ethWrapper = new ETHWrapper();
        lender = new Lender(swivel, address(0), address(0));
        redeemer = new Redeemer(address(lender), address(0), address(0));
        marketplace = new MarketPlace(address(redeemer), address(lender), address(creator));

        // Set up connections
        creator.setMarketPlace(address(marketplace));
        lender.setMarketPlace(address(marketplace));
        lender.setRedeemer(address(redeemer));

        // Deploy yield adapter
        SwivelAdapter swivelAdapter = new SwivelAdapter();
        YieldAdapter yieldAdapter = new YieldAdapter();

        address[] memory tokens = new address[](1);
        address[] memory adapters = new address[](2);
        tokens[0] = swivelDecember;
        adapters[0] = address(yieldAdapter);
        adapters[1] = address(swivelAdapter);

        // Set adapters
        marketplace.setAdapters(adapters);

        // Create market
        marketplace.createMarket(USDC, maturity, tokens, "iPT-DEC", "iPT-DEC-USDC");

        // Deal Balances
        deal(address(USDC), userPublicKey, startingBalance);
        deal(userPublicKey, 10000 ether);

        // Set approval
        address[] memory _USDC = new address[](1);
        _USDC[0] = USDC;
        address[] memory _swivel = new address[](1);
        _swivel[0] = swivel;

        lender.approve(_USDC,_swivel);
        vm.startPrank(userPublicKey);
        IERC20(USDC).approve(address(lender), type(uint256).max-1);
        vm.stopPrank();
    }

    function packD(
        Swivel.Order[] memory orders,
        Swivel.Components[] memory components,
        address pool,
        uint256 swapMinimum,
        bool swapFlag
    ) public pure returns (bytes memory d) {
        return abi.encode(
            orders,
            components,
            pool,
            swapMinimum,
            swapFlag
        );
    }
    
    function testLendUSDC() public {
        // setup user 1 
        deal(USDC, user1_pk, startingBalance, true);
        vm.startPrank(user1_pk);
        IERC20(USDC).approve(address(swivel), startingBalance);
        IERC20(USDC).approve(address(lender), startingBalance);

        Swivel.Order[] memory orders = new Swivel.Order[](1);
        Swivel.Components[] memory signatures = new Swivel.Components[](1);
        uint256[] memory amounts = new uint256[](1);

        bytes32 key;
        orders[0] = Swivel.Order(
            key, // key
            1, // protocol
            user1_pk, // maker
            USDC, // underlying
            true, // vault
            false, // exit
            50000000, // principal
            500000, // premium
            1703840400, // maturity
            1703840400 // expiry
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

        vm.stopPrank();
        
        vm.startPrank(userPublicKey);

        amounts[0] = 50000000;

        bytes memory d = packD(orders, signatures, 0x3667362C4B666B952383eDBE12fC9cC108D09cD7, uint256(1), false);

        uint256 returned = lender.lend(
            1,
            USDC,
            maturity,
            amounts,
            d
        );
    }

        function testLendUSDCSwapFlag() public {
        // setup user 1 
        deal(USDC, user1_pk, startingBalance, true);
        vm.startPrank(user1_pk);
        IERC20(USDC).approve(address(swivel), startingBalance);
        IERC20(USDC).approve(address(lender), startingBalance);

        Swivel.Order[] memory orders = new Swivel.Order[](1);
        Swivel.Components[] memory signatures = new Swivel.Components[](1);
        uint256[] memory amounts = new uint256[](1);

        bytes32 key;
        orders[0] = Swivel.Order(
            key, // key
            1, // protocol
            user1_pk, // maker
            USDC, // underlying
            true, // vault
            false, // exit
            50000000, // principal
            500000, // premium
            1703840400, // maturity
            1703840400 // expiry
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

        vm.stopPrank();
        
        vm.startPrank(userPublicKey);

        amounts[0] = 50000000;

        bytes memory d = packD(orders, signatures, 0x3667362C4B666B952383eDBE12fC9cC108D09cD7, uint256(1), true);

        uint256 returned = lender.lend(
            1,
            USDC,
            maturity,
            amounts,
            d
        );
    }
}


