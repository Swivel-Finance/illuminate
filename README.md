```

  _ _ _                 _             _       
 (_) | |_   _ _ __ ___ (_)_ __   __ _| |_ ___ 
 | | | | | | | '_ ` _ \| | '_ \ / _` | __/ _ \
 | | | | |_| | | | | | | | | | | (_| | ||  __/
 |_|_|_|\__,_|_| |_| |_|_|_| |_|\__,_|\__\___|
                                              

```
 
## A zero-coupon token aggregator.

Users can deposit an integrated protocol's (swivel, yield) zero coupon within a given maturity to mint an aggregated, "meta" zero-coupon, _"lTokens"_ (working name).

A frontend can then direct a user to the correct illuminate.sol lending function, which then lends to a given protocol (acquiring zero-coupon tokens) and deposits/mints _lTokens_.

On-chain applications can also purchase the lToken through a YieldSpace or similar AMM implementation with the knowledge that the rate will be the optimal rate on the market.

Should the lToken *not* trade at the lowest price on the market (meaning the highest rate for buyers), arbitrageurs can simply deposit/mint lTokens with the cheapest alternative, and arbitrage the current open market trading price.
