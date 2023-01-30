// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import 'forge-std/Script.sol';

import {MarketPlace} from 'flattened/MarketPlace.flattened.sol';
import {Lender} from 'flattened/Lender.flattened.sol';
import {Redeemer} from 'flattened/Redeemer.flattened.sol';

contract IlluminateMarketCreator is Script {
    MarketPlace marketplace = MarketPlace(0xDBcaCe3715a2206113a81e6cC02e8aBE907Ece26);
    Lender lender = Lender(0xb338Caa1488c319a1E938af02ab1BBe74dc7Fd17);
    Redeemer redeemer = Redeemer(0x8CA4ef1314Ce95Dfb965c31a96C6E3d111Cc1079);

    uint256 maturity;
    address underlying;
    string name;
    string symbol;
    address element;
    address apwine;

    // Principal Tokens
    address swivelPT;
    address yieldPT;

    // Third party contracts
    address tempusController;
    address senseInterestBearingToken;
    address sensePeriphery;

    function run() external {
        maturity = 1675362900;
        underlying = 0x07865c6E87B9F70255377e024ace6630C1Eaa37F;
        name = 'ptUSDC-1675362900';
        symbol = 'ptUSDC-FEB23';

        // setup deployer
        uint256 deployerPrivateKey = vm.envUint('GOERLI_PRIVATE_KEY');

        vm.startBroadcast(deployerPrivateKey);

        // setup the principal tokens
        address[8] memory tokens;
        tokens[0] = 0xAC0F2091eC3A2b1847b0B38f50218da211c3aA14;

        // deploy the market
        marketplace.createMarket(
            underlying,
            maturity,
            tokens,
            name,
            symbol,
            element,
            apwine,
            senseInterestBearingToken,
            sensePeriphery
        );

        // approve the third party contracts to spend the underlying
        address[] memory underlyings = new address[](1);
        underlyings[0] = underlying;
        address[] memory approved = new address[](1);
        approved[0] = lender.swivelAddr();
        // approved[1] = lender.pendleAddr();
        lender.approve(underlyings, approved);

        // approve the redeemer to spend the principal tokens
        lender.approve(underlying, maturity, address(redeemer));

        vm.stopBroadcast();
    }
}
