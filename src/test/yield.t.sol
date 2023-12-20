// // SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import "forge-std/Test.sol";
import "forge-std/console.sol";

// import all major contracts
import "../Lender.sol";
import "../Creator.sol";
import "../ETHWrapper.sol";
import "../Redeemer.sol";
 
// import adapters
import "../adapters/YieldAdapter.sol"; 

contract YieldTest is Test {

    address WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    uint256 maturity = 1704975690;

    address yieldDecemberPT = 0x82AC37A79D83f8C6E3B55E5e72e1f4ACb1E4fe9f;

    address yieldDecemberPool = 0xB9345c19291bB073b0E6483048fAFD0986AB82dF;

    address userPublicKey = 0x3f60008Dfd0EfC03F476D9B489D6C5B13B3eBF2C;

    uint256 startingBalance = 100000 ether;

    Creator creator;
    ETHWrapper ethWrapper;
    Lender lender;
    Redeemer redeemer;
    MarketPlace marketplace;

    event TestEvent(address, uint256, uint256, address, bytes, string);

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
        YieldAdapter yieldAdapter = new YieldAdapter();

        address[] memory tokens = new address[](1);
        address[] memory adapters = new address[](2);
        tokens[0] = yieldDecemberPT;
        adapters[0] = address(yieldAdapter);
        adapters[1] = address(yieldAdapter);
        marketplace.setAdapters(adapters);
        // Create market
        marketplace.createMarket(WETH, maturity, tokens, "iPT-DEC", "iPT-DEC-USDC");

        // Deal Balances
        deal(address(WETH), userPublicKey, startingBalance);
        deal(userPublicKey, 10000 ether);

        // Set approval
        vm.startPrank(userPublicKey);
        IERC20(WETH).approve(address(lender), type(uint256).max-1);
        vm.stopPrank();
    }

    function packD(
        uint256 minimum,
        address pool
    ) public  returns (bytes memory d) {
        return abi.encode(
            minimum,
            pool
        );
    }

    function testEncode() public {
        bytes memory d = abi.encode(address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48), 10000000, 1, address(0x9536C528d9e3f12586ea3E8f624dACb8150b22aa));
        (address underlying_, uint256 maturity, uint256 minimum, address pool) = abi.decode(d, (address, uint256, uint256, address));
        emit TestEvent(underlying_, maturity, minimum, pool, d, "test");
        assertEq(1,minimum);
    }

    function testLendWETH() public {
        vm.startPrank(userPublicKey);
        uint256[] memory amount = new uint256[](1);
        amount[0] = 10000000;
        // check approval
        assertEq(IERC20(WETH).allowance(userPublicKey, address(lender)), type(uint256).max-1);
        // ensure balance is enough for amount
        assertGt(IERC20(WETH).balanceOf(userPublicKey), amount[0]);
        bytes memory d = packD(uint256(1), address(yieldDecemberPool));
        lender.lend(1, address(WETH), maturity, amount, d);

        assertEq(IERC20(marketplace.markets(WETH, maturity).tokens[0]).balanceOf(userPublicKey), 
                 IERC20(marketplace.markets(WETH, maturity).tokens[1]).balanceOf(address(lender)));

        assertGt(IERC20(marketplace.markets(WETH, maturity).tokens[0]).balanceOf(userPublicKey), amount[0]);
    }

    function testLendETH() public {
        vm.startPrank(userPublicKey);
        uint256[] memory amount = new uint256[](1);
        amount[0] = 10000000;
        // check approval
        assertEq(IERC20(WETH).allowance(userPublicKey, address(lender)), type(uint256).max-1);
        // ensure balance is enough for amount
        assertGt(IERC20(WETH).balanceOf(userPublicKey), amount[0]);
        bytes memory d = packD(uint256(1), address(yieldDecemberPool));
        bytes memory directD = "0x000000000000000000000000000000000000000000000000015a63bbc199bfff000000000000000000000000b9345c19291bb073b0e6483048fafd0986ab82df";
        lender.lend{value: amount[0]}(1, address(WETH), maturity, amount, d, address(WETH), 1);
    }

}