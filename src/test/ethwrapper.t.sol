// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import "forge-std/Test.sol";
import "forge-std/console.sol";

// import all major contracts
import "../ETHWrapper.sol";

contract ETHWrapperTest is Test {

    address ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address frxETH = 0x5E8422345238F34275888049021821E8E08CAa1f;
    address stETH = 0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84;
    address stETHcurvePool = 0xDC24316b9AE028F1497c275EB9192a3Ea0f67022;
    address frxETHcurvePool = 0xa1F8A6807c402E4A15ef4EBa36528A3FED24E577;
    address curveRouter = 0x99a58482BD75cbab83b27EC03CA68fF489b5788f;
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

        vm.startPrank(0x505603e2440b44C1602b44D0Eb8385399b3F7bab);
        IERC20(frxETH).transfer(address(this), 100 ether);
        vm.stopPrank();
    }

    function testWrapETH() public {
            (bool success, bytes memory returnData) = address(ethWrapper).delegatecall(
                abi.encodeWithSignature(
                    "swap(address,address,address,uint256,uint256)",
                    stETHcurvePool,
                    ETH,
                    stETH,
                    1 ether/10,
                    0
                )
            );
    }

    function testUnwrapETH() public payable {
        IERC20(stETH).approve(stETHcurvePool, 99999 ether);
        (bool success, bytes memory returnData) = address(ethWrapper).delegatecall(
            abi.encodeWithSignature(
                "swap(address,address,address,uint256,uint256)",
                stETHcurvePool,
                stETH,
                ETH,
                1 ether/10,
                0
            )
        );
    }

    function testWrapfrxETH() public {
            (bool success, bytes memory returnData) = address(ethWrapper).delegatecall(
                abi.encodeWithSignature(
                    "swap(address,address,address,uint256,uint256)",
                    frxETHcurvePool,
                    ETH,
                    frxETH,
                    1 ether/10,
                    0
                )
            );
    }

    function testUnwrapfrxETH() public payable {
        IERC20(frxETH).approve(frxETHcurvePool, 99999 ether);
        (bool success, bytes memory returnData) = address(ethWrapper).delegatecall(
            abi.encodeWithSignature(
                "swap(address,address,address,uint256,uint256)",
                frxETHcurvePool,
                frxETH,
                ETH,
                1 ether/10,
                0
            )
        );
    }

    function testWrapETH2() public {
            (bool success, bytes memory returnData) = address(ethWrapper).delegatecall(
                abi.encodeWithSignature(
                    "swap(address,address,address,uint256,uint256)",
                    curveRouter,
                    ETH,
                    stETH,
                    1 ether/10,
                    0
                )
            );
    }
}