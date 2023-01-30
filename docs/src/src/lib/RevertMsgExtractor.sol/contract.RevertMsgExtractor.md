# RevertMsgExtractor
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/ddf95dfbaf2df4d82b6652aff5c2effb5fee45f4/src/lib/RevertMsgExtractor.sol)


## Functions
### getRevertMsg

*Helper function to extract a useful revert message from a failed call.
If the returned data is malformed or not correctly abi encoded then this call can fail itself.*


```solidity
function getRevertMsg(bytes memory returnData) internal pure returns (string memory);
```

