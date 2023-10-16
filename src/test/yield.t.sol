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
import "../adapters/YieldAdapter.sol"; 

contract YieldTest is Test {

    address USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    uint256 maturity = 1704975690;

    address yieldDecember = 0x9536C528d9e3f12586ea3E8f624dACb8150b22aa;

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
        lender = new Lender(address(0), address(0), address(0));
        redeemer = new Redeemer(address(lender), address(0), address(0));
        marketplace = new MarketPlace(address(redeemer), address(lender), address(creator));

        // Set up connections
        creator.setMarketPlace(address(marketplace));
        lender.setMarketPlace(address(marketplace));
        lender.setRedeemer(address(redeemer));

        // Deploy yield adapter
        YieldAdapter yieldAdapter = new YieldAdapter();

        address[] memory tokens = new address[](1);
        address[] memory adapters = new address[](2);
        tokens[0] = yieldDecember;
        adapters[0] = address(yieldAdapter);
        adapters[1] = address(yieldAdapter);
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
        address underlying_,
        uint256 maturity,
        uint256 minimum,
        address pool
    ) public  returns (bytes memory d) {
        return abi.encode(
            underlying_,
            maturity,
            minimum,
            pool
        );
    }

    // function testEncode() public {
    //     bytes memory d = abi.encode(address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48), uint256(1704975690), uint256(1704975691), address(0x9536C528d9e3f12586ea3E8f624dACb8150b22aa));
    //     (address underlying_, uint256 maturity, uint256 minimum, address pool) = abi.decode(d, (address, uint256, uint256, address));
    //     console.log(underlying_, "underlying");
    //     console.log(maturity, "maturity");
    //     console.log(minimum, "minimum");
    //     console.log(pool, "pool");
    //     assertEq(maturity,minimum);
    // }

    function testLendUSDC() public {
        vm.startPrank(userPublicKey);
        uint256[] memory amount = new uint256[](1);
        amount[0] = 100 * 10 ** 6;
        // check approval
        assertEq(IERC20(USDC).allowance(userPublicKey, address(lender)), type(uint256).max-1);
        // ensure balance is enough for amount
        assertGt(IERC20(USDC).balanceOf(userPublicKey), amount[0]);
        bytes memory d = packD(address(USDC), maturity, uint256(1), address(yieldDecember));
        lender.lend(1, address(USDC), maturity, amount, d);

        // assertGt(IERC20(yieldDecember).balanceOf(userPublicKey), 100 * 10 ** 6);
    }

}