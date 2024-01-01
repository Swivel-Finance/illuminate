// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import "forge-std/Test.sol";
import "forge-std/console.sol";

// import all major contracts
import "../ETHWrapper.sol";
 
// import adapters
import "../adapters/ExactlyAdapter.sol"; 

contract ETHWrapperTest is Test {

    address ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address stETH = 0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84;
    address curvePool = 0xDC24316b9AE028F1497c275EB9192a3Ea0f67022;

    address userPublicKey = 0x3f60008Dfd0EfC03F476D9B489D6C5B13B3eBF2C;

    uint256 startingBalance = 100000 ether;

    ETHWrapper ethWrapper;


    function setUp() public {

        // Deploy all major contracts
        ethWrapper = new ETHWrapper(); 

        // Deal Balances
        deal(address(ethWrapper), 10000 ether);
    }

    function testWrapETH() public {
            // DelegateCall the ETHWrapper.wrap
            (bool success, bytes memory returnData) = address(ethWrapper).delegatecall(
                abi.encodeWithSignature(
                    "swap(address,address,address,uint256,uint256)",
                    curvePool,
                    ETH,
                    stETH,
                    1 ether/10,
                    0
                )
            );
    }
}