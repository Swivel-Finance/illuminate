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

On-chain applications can also purchase the iPT through a our Marketplace.sol router, or direct YieldSpace AMM implementation with the knowledge that the rate is gaurunteed to be the highest collateralized rate in web3.

Should the iPT *not* trade at the lowest price on the market (meaning the highest rate for buyers), arbitrageurs can simply deposit/mint iPTs with the cheapest alternative, and arbitrage the current open market trading price.

### Contracts

Illuminate's smart contracts are located here, stored by version. Their associated `abi` and `bin` compilation assets are also here for convenience.

### Current Deployments
* Goerli
  * MarketPlace: 0xE3289aBF62D967fB3722DD0711578F812A7C84e1
  * Lender: 0xF780bBBe6aA834bad2C41232c9c39763fb0bda47
  * Redeemer: 0xD2667bB2471a8cf5b97622F555d2c58efe735f7A
  * Deployed Market: 
    * maturity: 1672525036 (DEC 22)
    * underlying: 0x07865c6E87B9F70255377e024ace6630C1Eaa37F (USDC) -- Minted through app.compound.finance
    * iPT Yield Space Pool: 0x40af6C32198Db0c387031613d8d495b0D86084Ee
    * Illuminate PT (ERC 5095): 0x6AD625525CB514206259999cbD1a9bE0CD975798
    * Swivel PT (zc token): 0x3E3fe32063e1389bEE9CEE4A8a499e603052d1ee

### Testing 

To run tests, install Foundry and use `forge test`. To operate the tests in `test/fork`, you will have to provide an RPC url and block number via an environment variable. The following is an example command to call the tests:

`forge test --fork-url ${RPC_URL} --fork-block-number ${BLOCK_NUMBER} --use solc:0.8.16`

Note that some tests are currently skipped. These tests' names will end with `Skip`. To avoid running them, add `--no-match-test "Skip\(\B"` to the test command.

There are also unit tests that can be found in `test/unit`.
