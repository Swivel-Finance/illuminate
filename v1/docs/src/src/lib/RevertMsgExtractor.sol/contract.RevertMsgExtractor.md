# RevertMsgExtractor
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/7162e4822e4bbebd99b67c43e703ecedf92a2138/src/lib/RevertMsgExtractor.sol)


## Functions
### getRevertMsg

*Helper function to extract a useful revert message from a failed call.
If the returned data is malformed or not correctly abi encoded then this call can fail itself.*


```solidity
function getRevertMsg(bytes memory returnData) internal pure returns (string memory);
```

