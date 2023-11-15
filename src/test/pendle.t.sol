// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.16;

// import "forge-std/Test.sol";
// import "forge-std/console.sol";

// // import all major contracts
// import "../Lender.sol";
// import "../Creator.sol";
// import "../ETHWrapper.sol";
// import "../Redeemer.sol";

// import "../lib/Pendle.sol";
 
// // import adapters
// import "../adapters/PendleAdapter.sol"; 
// import "../adapters/YieldAdapter.sol";

// contract PendleTest is Test {

//     address USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

//     uint256 maturity = 1735448400;

//     address pendleDec24PT = 0xd187BEA2C423D908d102ebe5Ee8C65d37f4085c3;

//     address pendleDec24Market = 0xcB71c2A73fd7588E1599DF90b88de2316585A860;

//     address pendleRouter = 0x0000000001E4ef00d069e71d6bA041b0A16F7eA0;

//     address userPublicKey = 0x3f60008Dfd0EfC03F476D9B489D6C5B13B3eBF2C;

//     uint256 startingBalance = 100000 ether;

//     Creator creator;
//     ETHWrapper ethWrapper;
//     Lender lender;
//     Redeemer redeemer;
//     MarketPlace marketplace;

//     function setUp() public {

//         // Deploy all major contracts
//         creator = new Creator();
//         ethWrapper = new ETHWrapper(); 
//         lender = new Lender(address(0), pendleRouter, address(0));
//         redeemer = new Redeemer(address(lender));
//         marketplace = new MarketPlace(address(redeemer), address(lender), address(creator));

//         // Set up connections
//         creator.setMarketPlace(address(marketplace));
//         lender.setMarketPlace(address(marketplace));
//         lender.setRedeemer(address(redeemer));

//         // Deploy yield adapter and Pendle Adapter
//         PendleAdapter pendleAdapter = new PendleAdapter();
//         YieldAdapter yieldAdapter = new YieldAdapter();

//         address[] memory tokens = new address[](1);
//         address[] memory adapters = new address[](2);
//         tokens[0] = pendleDec24PT;
//         adapters[0] = address(yieldAdapter);
//         adapters[1] = address(pendleAdapter);
//         marketplace.setAdapters(adapters);
//         // Create market
//         marketplace.createMarket(USDC, maturity, tokens, "iPT-DEC", "iPT-DEC-USDC");

//         // Deal Balances
//         deal(address(USDC), userPublicKey, startingBalance);
//         deal(userPublicKey, 10000 ether);

//         // Set approval
//         address[] memory _USDC = new address[](1);
//         _USDC[0] = USDC;
//         address[] memory _pendle = new address[](1);
//         _pendle[0] = pendleRouter;

//         lender.approve(_USDC,_pendle);
//         vm.startPrank(userPublicKey);
//         IERC20(USDC).approve(address(lender), type(uint256).max-1);
//         vm.stopPrank();
//     }

//     function packD(
//         uint256 minimum,
//         address market,
//         Pendle.ApproxParams memory approxParams,
//         Pendle.TokenInput memory tokenInput
//     ) public  returns (bytes memory d) {
//         return abi.encode(
//             minimum,
//             market,
//             approxParams,
//             tokenInput
//         );
//     }

//     function testLendUSDC() public {
//         vm.startPrank(userPublicKey);
//         uint256[] memory amount = new uint256[](1);
//         amount[0] = 10000000;

//         Pendle.ApproxParams memory approxParams = Pendle.ApproxParams({
//                 guessMin: 0,
//                 guessMax: amount[0],
//                 guessOffchain: 0,
//                 maxIteration: 256,
//                 eps: (1e15)
//         });

//         Pendle.TokenInput memory tokenInput = Pendle.TokenInput({
//             tokenIn: USDC,
//             netTokenIn: amount[0],
//             tokenMintSy: USDC,
//             bulk: address(0),
//             pendleSwap: address(0),
//             swapData: Pendle.SwapData({
//                 swapType: Pendle.SwapType.NONE,
//                 extRouter: address(0),
//                 extCalldata: bytes(""),
//                 needScale: false
//             })
//         });

//         // check approval
//         assertEq(IERC20(USDC).allowance(userPublicKey, address(lender)), type(uint256).max-1);
//         // ensure balance is enough for amount
//         assertGt(IERC20(USDC).balanceOf(userPublicKey), amount[0]);

//         bytes memory d = packD(uint256(1), pendleDec24Market, approxParams, tokenInput);

//         lender.lend(1, address(USDC), maturity, amount, d);

//         assertEq(IERC20(marketplace.markets(USDC, maturity).tokens[0]).balanceOf(userPublicKey), 
//                  IERC20(marketplace.markets(USDC, maturity).tokens[1]).balanceOf(address(lender)));

//         assertGt(IERC20(marketplace.markets(USDC, maturity).tokens[0]).balanceOf(userPublicKey), amount[0]);
//     }

// }