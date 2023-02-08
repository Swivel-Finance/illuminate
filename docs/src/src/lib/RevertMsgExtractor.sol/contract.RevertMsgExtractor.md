# RevertMsgExtractor
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/29a4038ae0d0795d36640f068da3ac5c1dd43806/src/lib/RevertMsgExtractor.sol)


## Functions
### getRevertMsg

*Helper function to extract a useful revert message from a failed call.
If the returned data is malformed or not correctly abi encoded then this call can fail itself.*


```solidity
function getRevertMsg(bytes memory returnData) internal pure returns (string memory);
```

