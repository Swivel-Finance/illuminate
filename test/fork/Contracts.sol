// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

library Contracts {
    // Sent to the lender contract constructor
    // Swivel.sol v3 deployed contract
    address constant SWIVEL = 0x373a06bD3067f8DA90239a47f316F09312b7800F;
    uint256 constant SWIVEL_BLOCK = 15947632;
    // Sushiswap router (https://docs.sushi.com/docs/Developers/Deployment%20Addresses)
    // note used on lender
    address constant PENDLE = 0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F;
    // note used on redeemer
    address constant PENDLE_ROUTER = 0x1b6d3E5Da9004668E14Ca39d1553E9a46Fe842B3;
    // https://docs.tempus.finance/docs/deployed-contracts (controller)
    address constant TEMPUS = 0xdB5fD0678eED82246b599da6BC36B56157E4beD8;

    // Prinicpal Tokens---------------------------------------------------------
    // Notional deployed contracts: https://docs.notional.finance/developer-documentation/
    // NOTE this is the DAI wrapped-fcash address
    address constant NOTIONAL_TOKEN =
        0xfcB060E09e452EEFf142949Bec214c187CDF25fA;
    // Via the marketplace's markets call with USDC underlying and a maturity of 1664550000 (v2)
    address constant SWIVEL_TOKEN = 0x70e6DBaA67421878681E37FF5C6F1D1C333cC938;
    // Via sushi swap market (Dec 2022 - https://app.pendle.finance/market)
    address constant PENDLE_TOKEN = 0x8fcb1783bF4b71A51F702aF0c266729C4592204a;
    // via contracts.json (https://etherscan.io/address/0x53C2a1bA37FF3cDaCcb3EA030DB3De39358e5593#readContract)
    address constant YIELD_TOKEN = 0x53C2a1bA37FF3cDaCcb3EA030DB3De39358e5593;
    // (principal share) https://etherscan.io/address/0xb3ec7facb30b163b1375285ea7ebfeefc41920b9#readContract
    address constant TEMPUS_TOKEN = 0xB3EC7FACb30b163b1375285EA7EbfEeFc41920B9;
    // NOTE for apwine, we have to use the amm pool to get the APWine token. From there, we use the PT that the
    // amm points to in order to continue with verification purposes
    // AMM Registry -> getFutureVaultAt(futureVaultAt via ProtocolRegistry) -> getFutureAMMPool
    address constant APWINE_AMM_POOL =
        0xb932c4801240753604c768c991eb640BCD7C06EB;
    // (element token) https://app.element.fi/fixedrates/0xCFe60a1535ecc5B0bc628dC97111C8bb01637911
    address constant ELEMENT_TOKEN = 0xf38c3E836Be9cD35072055Ff6a9Ba570e0B70797;
    // (sense adapter)
    // NOTE for sense, we have to use the adapter contract to verify the underlying/maturity
    // NOTE also we had to use the wsteth pools.... (maturity: 1659312000)
    address constant SENSE_ADAPTER = 0x880E5caBB22D24F3E278C4C760e763f239AccA95;

    // Misc. contracts/values --------------------------------------------------
    // found via etherscan via contracts.json or something
    address constant YIELD_POOL_USDC =
        0xf5Fd5A9Db9CcCc6dc9f5EF1be3A859C39983577C;
    address constant YIELD_POOL_USDC_2 = // DEC 22
        0xB2fff7FEA1D455F0BCdd38DA7DeE98af0872a13a;
    address constant YIELD_POOL_DAI =
        0x6BaC09a67Ed1e1f42c29563847F77c28ec3a04FC;
    // (amm) https://etherscan.io/address/0x811f4F0241A9A4583C052c08BDA7F6339DBb13f7#readContract
    address constant TEMPUS_AMM = 0x811f4F0241A9A4583C052c08BDA7F6339DBb13f7;
    // (pool) https://etherscan.io/address/0x443297de16c074fdee19d2c9ecf40fde2f5f62c2#readContract
    address constant TEMPUS_POOL = 0x443297DE16C074fDeE19d2C9eCF40fdE2f5F62C2;

    // (pool) https://etherscan.io/address/0xf5ba2E5DdED276fc0f7a7637A61157a4be79C626#writeProxyContract
    address constant APWINE_ROUTER = 0xf5ba2E5DdED276fc0f7a7637A61157a4be79C626;
    // (pool id) via getFutureVaultAt in Protocol Registry (https://docs.apwine.fi/dev/introduction/deployed-contracts)
    // APWINE POOL ID is 4 (for tests)
    // (controller, used to call getNextPeriodStart (for maturity check))
    address constant APWINE_CONTROLLER =
        0x4bA30FA240047c17FC557b8628799068d4396790;
    // (apwine PT - USDT market) https://etherscan.io/address/0x2b8692963c8ec4cdf30047a20f12c43e4d9aef6c
    address constant APWINE_TOKEN = 0x2d31591f7a650579125bC9BC1622E07fFD219033;
    address constant APWINE_FUTURE_VAULT = 0xb524c16330A76182Ef617F08F5E6996f577AC64A;
    // (element router)
    address constant ELEMENT_VAULT = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    // (element USDC pool) https://raw.githubusercontent.com/element-fi/elf-deploy/main/changelog/releases/mainnet/v1.1.0:7/addresses.json
    // tranches -> usdc -> ptPool -> poolId
    bytes32 constant ELEMENT_POOL_ID =
        0x787546bf2c05e3e19e2b6bde57a203da7f682eff00020000000000000000007c;

    // aUSDC in this case
    address constant PENDLE_UNDERLYING_YIELD_TOKEN =
        0xBcca60bB61934080951369a648Fb03DF4F96263C;

    // (sense periphery (executes swap)) https://docs.sense.finance/developers/deployed-contracts/
    address constant SENSE_PERIPHERY =
        0xFff11417a58781D3C72083CB45EF54d79Cd02437;
    address constant SENSE_TOKEN = 0x6BEf7922EBA9fDd6BEca781cD21E3a25f872Aa97;
    uint256 constant SENSE_MATURITY = 1659312000;
    address constant SENSE_DIVIDER = 0x86bA3E96Be68563E41c2f5769F1AF9fAf758e6E0;
    uint256 constant SENSE_VALID_SETTLEMENT_TS = 1659322801;

    // Underlyings--------------------------------------------------------------
    address constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    // https://api-main.swivel.exchange/v2/markets?status=active
    address constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    // Foundry specific
    address constant DEPLOYER = 0xb4c79daB8f259C7Aee6E5b2Aa729821864227e84;

    // converter tokens
    address constant AUSDC = 0xBcca60bB61934080951369a648Fb03DF4F96263C;
    address constant CUSDC = 0x39AA39c021dfbaE8faC545936693aC917d5E7563;
    address constant AAVE_POOL = 0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9;
    address constant WSTETH = 0x7f39C581F595B53c5cb19bD0b3f8dA6c935E2Ca0;
    address constant STETH = 0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84;
    address constant USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    address constant CDAI = 0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643;

    address constant EUDAI = 0xe025E3ca2bE02316033184551D4d3Aa22024D9DC;
}
