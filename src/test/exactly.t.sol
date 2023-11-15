// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import "forge-std/Test.sol";
import "forge-std/console.sol";

// import all major contracts
import "../Lender.sol";
import "../Creator.sol";
import "../ETHWrapper.sol";
import "../Redeemer.sol";
 
// import adapters
import "../adapters/ExactlyAdapter.sol"; 

contract YieldTest is Test {

    address USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    uint256 maturity = 1704975690;

    address exactlyUSDC = 0x81C9A7B55A4df39A9B7B5F781ec0e53539694873;

    uint256 exactlyUSDCDecMaturity = 1703116800;

    address userPublicKey = 0x3f60008Dfd0EfC03F476D9B489D6C5B13B3eBF2C;

    uint256 startingBalance = 100000 ether;

    Creator creator;
    ETHWrapper ethWrapper;
    Lender lender;
    Redeemer redeemer;
    MarketPlace marketplace;


    function setUp() public {

        // Deploy all major contracts
        creator = new Creator();
        ethWrapper = new ETHWrapper(); 
        lender = new Lender(address(0), address(0), address(0));
        redeemer = new Redeemer(address(lender));
        marketplace = new MarketPlace(address(redeemer), address(lender), address(creator));

        // Set up connections
        creator.setMarketPlace(address(marketplace));
        lender.setMarketPlace(address(marketplace));
        lender.setRedeemer(address(redeemer));

        // Deploy yield adapter
        ExactlyAdapter exactlyAdapter = new ExactlyAdapter();

        address[] memory tokens = new address[](1);
        address[] memory adapters = new address[](2);
        tokens[0] = exactlyUSDC;
        adapters[0] = address(exactlyAdapter);
        adapters[1] = address(exactlyAdapter);
        marketplace.setAdapters(adapters);
        // Create market
        marketplace.createMarket(USDC, maturity, tokens, "iPT-DEC", "iPT-DEC-USDC");

        // Deal Balances
        deal(address(USDC), userPublicKey, startingBalance);
        deal(userPublicKey, 10000 ether);

        // Set approval
        vm.startPrank(userPublicKey);
        IERC20(USDC).approve(address(lender), type(uint256).max-1);
        vm.stopPrank();
    }

    function packD(
        uint256 maturity,
        uint256 minimum
    ) public  returns (bytes memory d) {
        return abi.encode(
            maturity,
            minimum
        );
    }

    function testLendUSDC() public {
        vm.startPrank(userPublicKey);
        uint256[] memory amount = new uint256[](1);
        amount[0] = 10000000;
        // check approval
        assertEq(IERC20(USDC).allowance(userPublicKey, address(lender)), type(uint256).max-1);
        // ensure balance is enough for amount
        assertGt(IERC20(USDC).balanceOf(userPublicKey), amount[0]);
        bytes memory d = packD(exactlyUSDCDecMaturity, (amount[0] - (amount[0]/100)));
        lender.lend(1, address(USDC), maturity, amount, d);

        assertEq(IERC20(marketplace.markets(USDC, maturity).tokens[0]).balanceOf(userPublicKey), 
                 IERC20(marketplace.markets(USDC, maturity).tokens[1]).balanceOf(address(lender)));

        assertGt(IERC20(marketplace.markets(USDC, maturity).tokens[0]).balanceOf(userPublicKey), amount[0]);
    }

}