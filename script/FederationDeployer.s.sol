// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import 'forge-std/Script.sol';

import {Lender} from 'src/Lender.sol';
import {MarketPlace} from 'src/MarketPlace.sol';
import {Redeemer} from 'src/Redeemer.sol';
import {Creator} from 'src/Creator.sol';

contract IlluminateFederationDeployer is Script {
    address admin = 0x173033758E8623fEE7C612e2f251CEa808127654;
    // third party contracts for lender and redeemer
    address swivel = 0x373a06bD3067f8DA90239a47f316F09312b7800F;
    address pendle = 0x41FAD93F225b5C1C95f2445A5d7fcB85bA46713f;
    address apwine = 0xf5ba2E5DdED276fc0f7a7637A61157a4be79C626;
    address tempus = 0xdB5fD0678eED82246b599da6BC36B56157E4beD8;

    function run() external {
        // setup deployer contract
        uint256 deployerPrivateKey = vm.envUint('MAINNET_PRIVATE_KEY');

        vm.startBroadcast(deployerPrivateKey);

        // Deploy contracts
        Creator creator = new Creator();
        Lender lender = new Lender(swivel, pendle, apwine);
        Redeemer redeemer = new Redeemer(address(lender));
        MarketPlace marketplace = new MarketPlace(
            address(redeemer),
            address(lender),
            address(creator)
        ); 

        // Call basic setters
        creator.setMarketPlace(address(marketplace));
        lender.setMarketPlace(address(marketplace));
        redeemer.setMarketPlace(address(marketplace));

        // Set the admin
        if (admin != address(0)) {
            lender.setAdmin(admin);
            redeemer.setAdmin(admin);
            marketplace.setAdmin(admin);
        }

        vm.stopBroadcast();
    }
}
