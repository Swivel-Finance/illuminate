// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import "forge-std/Test.sol";
import "forge-std/console.sol";

// import all major contracts
import "../Lender.sol";
import "../Creator.sol";
import "../ETHWrapper.sol";
import "../Redeemer.sol";
import "../ETHWrapper.sol";

import "../lib/Pendle.sol";
 
// import adapters
import "../adapters/PendleAdapter.sol"; 
import "../adapters/YieldAdapter.sol";

contract PendleTest is Test {

    address eETH = 0x35fA164735182de50811E8e2E824cFb9B6118ac2;

    address WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    uint256 maturity = 1735448400;

    address pendleJun24PT = 0xc69Ad9baB1dEE23F4605a82b3354F8E40d1E5966;

    address pendleJun24Market = 0xF32e58F92e60f4b0A37A69b95d642A471365EAe8;

    address pendleRouter = 0x0000000001E4ef00d069e71d6bA041b0A16F7eA0;

    address userPublicKey = 0x3f60008Dfd0EfC03F476D9B489D6C5B13B3eBF2C;

    address curveRouter = 0x99a58482BD75cbab83b27EC03CA68fF489b5788f;

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
        lender = new Lender(address(0), pendleRouter, address(0));
        redeemer = new Redeemer(address(lender));
        marketplace = new MarketPlace(address(redeemer), address(lender), address(creator));

        // Set up connections
        creator.setMarketPlace(address(marketplace));
        lender.setMarketPlace(address(marketplace));
        lender.setRedeemer(address(redeemer));

        // Deploy yield adapter and Pendle Adapter
        PendleAdapter pendleAdapter = new PendleAdapter();
        YieldAdapter yieldAdapter = new YieldAdapter();

        address[] memory tokens = new address[](1);
        address[] memory adapters = new address[](2);
        tokens[0] = pendleJun24PT;
        adapters[0] = address(yieldAdapter);
        adapters[1] = address(pendleAdapter);
        marketplace.setAdapters(adapters);
        lender.setCurveRouter(curveRouter);
        lender.setETHWrapper(address(ethWrapper));
        // Create market
        marketplace.createMarket(WETH, maturity, tokens, "iPT-DEC", "iPT-DEC-USDC");

        // Deal Balances
        deal(address(WETH), userPublicKey, startingBalance);
        vm.startPrank(0x88C24C07084C9eDa7F65B2A114C53753D7105aFf);
        IERC20(eETH).transfer(userPublicKey, 100 ether);
        vm.stopPrank();
        deal(userPublicKey, 10000 ether);

        // Set approval
        address[] memory underlyings = new address[](4);
        underlyings[0] = WETH;
        underlyings[1] = WETH;
        underlyings[2] = eETH;
        underlyings[3] = eETH;
        address[] memory _pendle = new address[](4);
        _pendle[0] = pendleRouter;
        _pendle[1] = 0x13947303F63b363876868D070F14dc865C36463b;
        _pendle[2] = pendleRouter;
        _pendle[3] = 0x13947303F63b363876868D070F14dc865C36463b;

        lender.approve(underlyings,_pendle);
        vm.startPrank(userPublicKey);
        IERC20(WETH).approve(address(lender), type(uint256).max-1);
        IERC20(eETH).approve(address(lender), type(uint256).max-1);
        vm.stopPrank();
    }

    function packD(
        uint256 minimum,
        address market,
        Pendle.ApproxParams memory approxParams,
        Pendle.TokenInput memory tokenInput
    ) public  returns (bytes memory d) {
        return abi.encode(
            minimum,
            market,
            approxParams,
            tokenInput
        );
    }

    function testLendETH() public {
        vm.startPrank(userPublicKey);
        uint256[] memory amount = new uint256[](1);
        amount[0] = 1 ether;

        Pendle.ApproxParams memory approxParams = Pendle.ApproxParams({
                guessMin: 0,
                guessMax: UINT256_MAX,
                guessOffchain: 0,
                maxIteration: 256,
                eps: (1e15)
        });

        Pendle.TokenInput memory tokenInput = Pendle.TokenInput({
            tokenIn: eETH,
            netTokenIn: amount[0],
            tokenMintSy: eETH,
            bulk: address(0),
            pendleSwap: address(0),
            swapData: Pendle.SwapData({
                swapType: Pendle.SwapType.NONE,
                extRouter: address(0),
                extCalldata: bytes(""),
                needScale: false
            })
        });

        bytes memory d = packD(uint256(1), pendleJun24Market, approxParams, tokenInput);

        lender.lend{value: amount[0]}(1, address(WETH), maturity, amount, d, eETH, 0);

        // assert that balanceOf WETH lender is 0
        //assertEq(IERC20(WETH).balanceOf(address(lender)), 0);
        // assert that balanceOf eETH lender is 0
        assertEq(IERC20(eETH).balanceOf(address(lender)), lender.fees(eETH));
    }

}