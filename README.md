```
  ) _ _                 )             _            )
 (_) | |_   _ _ __ ___ (_)_ __   __ _| |_ ___     (_)
 |'| | | | | | '_ ` _ \|'| '_ \ / _` | __/ _ \    |'|
 | | | | |_| | | | | | | | | | | (_| | ||  __/    | |  _()
 |_|_|_|\__,_|_| |_| |_|_|_| |_|\__,_|\__\___|  \_|_|_/

```
 
## A zero-coupon token aggregator.
Users can deposit an integrated protocol's (swivel, yield) zero coupon within a given maturity to mint an aggregated, "meta" zero-coupon, _"lTokens"_ (working name).
A frontend can then direct a user to the correct illuminate.sol lending function, which then lends to a given protocol (acquiring zero-coupon tokens) and deposits/mints _lTokens_.
On-chain applications can also purchase the lToken tt whrough a YieldSpace or similar AMM implementation with the knowledge that the rate will be the optimal rate on the market.
Should the lToken *not* trade at the lowest price on the market (meaning the highest rate for buyers), arbitrageurs can simply deposit/mint lTokens with the cheapest alternative, and arbitrage the current open market trading price.

### Contracts
Illuminate smart contracts are located here, stored by version. Their associated `abi` and `bin` compilation assets are also here for convenience.

### Current Deployments
* Goerli
  * MarketPlace: 0xE3289aBF62D967fB3722DD0711578F812A7C84e1
  * Lender: 0xF780bBBe6aA834bad2C41232c9c39763fb0bda47
  * Redeemer: 0xD2667bB2471a8cf5b97622F555d2c58efe735f7A
  * Deployed Market: 
    * maturity: 1672525036 (DEC 22)
    * underlying: 0x07865c6E87B9F70255377e024ace6630C1Eaa37F (USDC)
    * iPT Yield Space Pool: 0x40af6C32198Db0c387031613d8d495b0D86084Ee
    * Illuminate PT (ERC 5095): 0x6AD625525CB514206259999cbD1a9bE0CD975798
    * Swivel PT (zc token): 0x3E3fe32063e1389bEE9CEE4A8a499e603052d1ee
