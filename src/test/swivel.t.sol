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

contract SwivelTest is Test {

    address USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    uint256 maturity = 1704975690;

    address swivelDecember = 0xA7E982740200ca6bd5f4dCf17599389A02185292;

    address userPublicKey = 0x3f60008Dfd0EfC03F476D9B489D6C5B13B3eBF2C;

    uint256 startingBalance = 100000 ether;

    function setUp() public {

        // Deploy all major contracts
        Creator creator = new Creator();
        Converter converter = new Converter();
        ETHWrapper ethWrapper = new ETHWrapper();
        Lender lender = new Lender(address(0), address(0), address(0));
        Redeemer redeemer = new Redeemer(address(lender), address(0), address(0));
        MarketPlace marketplace = new MarketPlace(address(redeemer), address(lender), address(creator));

        // Set up connections
        creator.setMarketPlace(address(marketplace));
        marketplace.setLender(address(lender));
        marketplace.setRedeemer(address(redeemer));

        // Deploy yield adapter
        SwivelAdapter swivelAdapter = new SwivelAdapter();

        address[] memory tokens;
        address[] memory adapters;
        tokens[0] = swivelDecember;
        adapters[0] = address(swivelAdapter);
        // Create market
        marketplace.createMarket(USDC, maturity, tokens, adapters, "iPT-DEC", "iPT-DEC-USDC");

        // Deal Balances
        deal(address(USDC), userPublicKey, startingBalance);
        deal(userPublicKey, 10000 ether);

        // Set approval
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
        return abi.encodeWithSignature('Swivel.Order[] memory orders, Swivel.Components[] memory components, address pool, uint256 swapMinimum, bool swapFlag',
            orders,
            components,
            pool,
            swapMinimum,
            swapFlag
        );
    }
    
    function testLendUSDC() public {
        vm.startPrank(userPublicKey);
    }


}