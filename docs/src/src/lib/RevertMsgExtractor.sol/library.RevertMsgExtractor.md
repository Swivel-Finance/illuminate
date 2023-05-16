# RevertMsgExtractor
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/76b26ef748dc63cf89e3fa660df1bda262dcef15/src/lib/RevertMsgExtractor.sol)


## Functions
### getRevertMsg

*Helper function to extract a useful revert message from a failed call.
If the returned data is malformed or not correctly abi encoded then this call can fail itself.*


```solidity
function getRevertMsg(bytes memory returnData) internal pure returns (string memory);
```

