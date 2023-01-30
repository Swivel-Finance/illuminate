// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import 'forge-std/Script.sol';

import {Lender} from 'flattened/Lender.flattened.sol';
import {MarketPlace} from 'flattened/MarketPlace.flattened.sol';
import {Redeemer} from 'flattened/Redeemer.flattened.sol';
import {Converter} from 'flattened/Converter.flattened.sol';
import {Creator} from 'flattened/Creator.flattened.sol';

contract IlluminateFederationDeployer is Script {
    address admin;
    // third party contracts for lender and redeemer
    address swivel;
    address pendle;
    address apwine;
    address tempus;

    function run() external {
        // setup deployer contract
        uint256 deployerPrivateKey = vm.envUint('');

        vm.startBroadcast(deployerPrivateKey);

        // Deploy contracts
        Creator creator = new Creator();
        Lender lender = new Lender(swivel, pendle, apwine);
        Redeemer redeemer = new Redeemer(
            address(lender),
            swivel,
            pendle,
            tempus
        );
        MarketPlace marketplace = new MarketPlace(
            address(redeemer),
            address(lender),
            address(creator)
        );
        Converter converter = new Converter();

        // Call basic setters
        lender.setMarketPlace(address(marketplace));
        redeemer.setMarketPlace(address(marketplace));
        redeemer.setConverter(address(converter), new address[](0));
        creator.setMarketPlace(address(marketplace));

        // Set the admin
        lender.setAdmin(admin);
        redeemer.setAdmin(admin);
        marketplace.setAdmin(admin);

        vm.stopBroadcast();
    }
}
