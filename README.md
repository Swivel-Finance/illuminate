```
  ) _ _                 )             _            )
 (_) | |_   _ _ __ ___ (_)_ __   __ _| |_ ___     (_)
 |'| | | | | | '_ ` _ \|'| '_ \ / _` | __/ _ \    |'|
 | | | | |_| | | | | | | | | | | (_| | ||  __/    | |  _()
 |_|_|_|\__,_|_| |_| |_|_|_| |_|\__,_|\__\___|  \_|_|_/

```

## A Fixed-Yield Aggregator & Meta Principal Token

Users can deposit an integrated protocol's (swivel, yield, notional, sense, pendle, apwine, tempus, element) principal token within a given maturity to mint an aggregated, "meta" zero-coupon, _"iPTs"_ (working name).

A frontend can then direct a user to the correct illuminate.sol lending function, which then lends to a given protocol (acquiring zero-coupon tokens) and deposits/mints _iPTs_.

On-chain applications can also purchase the iPT through our Marketplace.sol router, or direct YieldSpace AMM implementation with the knowledge that the rate is gaurunteed to be the highest collateralized rate in web3.

Should the iPT _not_ trade at the lowest price on the market (meaning the highest rate for buyers), arbitrageurs can simply deposit/mint iPTs with the cheapest alternative, and arbitrage the current open market trading price.

### Contracts

Illuminate's smart contracts are located here, stored by version. Their associated `abi` and `bin` compilation assets are also here for convenience.

### Current Deployments

- Mainnet
  - MarketPlace: 0xcd1D02fDa51CD24123e857CE94e4356D5C073b3f
  - Lender: 0x429B47C4AEADD42BBcB118651C8984086Bfc4551
  - Redeemer: 0x4eA57ef203E91AE8c7D9822aa09CC719a9c01aC6
  - Deployed Market:
    - maturity: 1688342400 (JUN 23)
    - underlying: 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48 (USDC)
    - iPT Yield Space Pool: 0xCC696A6a6174CF592e5CBF680F2aa95b02e98E15
    - Illuminate PT (ERC 5095): 0x3393f10c89F59d8c2533E559F931D147259A0A1B
    - Swivel PT: 0x7918dAf8f0F00c585DDadACd40dd215b6fF11897
    - Sense PT: 0x869a70c198c937801b26d2701dc8e4e8c4de354a
    - Notional PT: 0x3f4b94D67FA86638f3dB925e4Ce6926471b27953
- Goerli
  - MarketPlace: 0xDBcaCe3715a2206113a81e6cC02e8aBE907Ece26
  - Lender: 0xb338Caa1488c319a1E938af02ab1BBe74dc7Fd17
  - Redeemer: 0x8CA4ef1314Ce95Dfb965c31a96C6E3d111Cc1079
  - Deployed Market:
    - maturity: 1696115940 (SEP 23)
    - underlying: 0x07865c6E87B9F70255377e024ace6630C1Eaa37F (USDC)
    - iPT Yield Space Pool: 0x81B48E253E92f1501DF0277b958CAF8121d05e4e
    - Illuminate PT (ERC 5095): 0xBa8647Fbc6D11fa6d634289D0627c1eD29d54D07
    - Swivel PT: 0xac7e226c324103d8709c63c175a137c1436f5ed5
    - Yield PT: 0x868E267912E8E94BF27F91aBCAfA6a4BC283Eb5C

### Building

To build the project, run `forge build --via-ir`.

### Documentation

To serve the docs locally, run `forge doc --serve`.

### Testing

To run tests, install Foundry and use `forge test`. To operate the tests in `test/fork`, you will have to provide an RPC url and block number via an environment variable. The following is an example command to call the tests:

`forge test --fork-url ${RPC_URL} --fork-block-number ${BLOCK_NUMBER} --use solc:0.8.16`

Note that some tests are currently skipped. These tests' names will end with `Skip`. To avoid running them, add `--no-match-test "Skip\(\B"` to the test command.

There are also unit tests that can be found in `test/unit`.
