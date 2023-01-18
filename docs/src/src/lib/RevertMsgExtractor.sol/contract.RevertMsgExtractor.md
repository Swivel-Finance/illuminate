# RevertMsgExtractor
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/756f41d3de7041d0b83523598284cee2b14c535e/src/lib/RevertMsgExtractor.sol)


## Functions
### getRevertMsg

*Helper function to extract a useful revert message from a failed call.
If the returned data is malformed or not correctly abi encoded then this call can fail itself.*


```solidity
function getRevertMsg(bytes memory returnData) internal pure returns (string memory);
```

