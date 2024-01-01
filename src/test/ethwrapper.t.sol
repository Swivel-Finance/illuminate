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

    fallback() external payable {} 
    
    function setUp() public {

        // Deploy all major contracts
        ethWrapper = new ETHWrapper(); 
        // Deal balances
        deal(address(this), 10000 ether);
        vm.startPrank(0xa980d4c0C2E48d305b582AA439a3575e3de06f0E);
        IERC20(stETH).transfer(address(this), 100 ether);
        vm.stopPrank();
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

    function testUnwrapETH() public payable {
        IERC20(stETH).approve(curvePool, 9999999999999999999999999999999999999);
        // DelegateCall the ETHWrapper.wrap
        (bool success, bytes memory returnData) = address(ethWrapper).delegatecall(
            abi.encodeWithSignature(
                "swap(address,address,address,uint256,uint256)",
                curvePool,
                stETH,
                ETH,
                1 ether/10,
                0
            )
        );
    }
}