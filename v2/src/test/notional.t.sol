// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.16;

// import "forge-std/Test.sol";
// import "forge-std/console.sol";

// // import all major contracts
// import "../Lender.sol";
// import "../Creator.sol";
// import "../ETHWrapper.sol";
// import "../Redeemer.sol";
 
// // import adapters
// import "../adapters/NotionalAdapter.sol"; 

// contract NotionalTest is Test {

//     address USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

//     uint256 maturity = 1704975690;

//     address notionalDecemberPT = 0xb80372C5687E884B0a78363Fe1bF2995535fB21B;

//     address userPublicKey = 0x3f60008Dfd0EfC03F476D9B489D6C5B13B3eBF2C;

//     uint256 startingBalance = 100000 ether;

//     Creator creator;
//     ETHWrapper ethWrapper;
//     Lender lender;
//     Redeemer redeemer;
//     MarketPlace marketplace;

//     event TestEvent(address, uint256, uint256, address, bytes, string);

//     function setUp() public {

//         // Deploy all major contracts
//         creator = new Creator();
//         ethWrapper = new ETHWrapper(); 
//         lender = new Lender(address(0), address(0), address(0));
//         redeemer = new Redeemer(address(lender));
//         marketplace = new MarketPlace(address(redeemer), address(lender), address(creator));

//         // Set up connections
//         creator.setMarketPlace(address(marketplace));
//         lender.setMarketPlace(address(marketplace));
//         lender.setRedeemer(address(redeemer));

//         // Deploy yield adapter
//         NotionalAdapter notionalAdapter = new NotionalAdapter();

//         address[] memory tokens = new address[](11);
//         address[] memory adapters = new address[](12);
//         for (uint256 i = 0; i < 11; i++) {
//             adapters[i] = address(0);
//         }
//         for (uint256 i = 0; i < 11; i++) {
//             tokens[i] = address(0);
//         }

    
//         adapters[8] = address(notionalAdapter);
//         tokens[7] = notionalDecemberPT;
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
//         _pendle[0] = notionalDecemberPT;

//         lender.approve(_USDC,_pendle);
//         vm.startPrank(userPublicKey);
//         IERC20(USDC).approve(address(lender), type(uint256).max-1);
//         vm.stopPrank();
//     }

//     function packD(
//         uint256 minimum,
//         address pool
//     ) public  returns (bytes memory d) {
//         return abi.encode(
//             minimum,
//             pool
//         );
//     }

//     function testLendUSDC() public {
//         vm.startPrank(userPublicKey);
//         uint256[] memory amount = new uint256[](1);
//         amount[0] = 10000000;
//         // check approval
//         assertEq(IERC20(USDC).allowance(userPublicKey, address(lender)), type(uint256).max-1);
//         // ensure balance is enough for amount
//         assertGt(IERC20(USDC).balanceOf(userPublicKey), amount[0]);
//         lender.lend(8, address(USDC), maturity, amount, bytes("0"));
//         uint256 adjustedLenderPTBalance = ILender(address(lender)).convertDecimals(USDC, notionalDecemberPT, IERC20(marketplace.markets(USDC, maturity).tokens[8]).balanceOf(address(lender)));
//         assertApproxEqRel(IERC20(marketplace.markets(USDC, maturity).tokens[0]).balanceOf(userPublicKey), adjustedLenderPTBalance,1e16);

//         assertGt(IERC20(marketplace.markets(USDC, maturity).tokens[0]).balanceOf(userPublicKey), amount[0]);
//     }
// }