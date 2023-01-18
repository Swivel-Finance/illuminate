# Exception
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/756f41d3de7041d0b83523598284cee2b14c535e/src/errors/Exception.sol)

*A single custom error capable of indicating a wide range of detected errors by providing
an error code value whose string representation is documented in errors.txt, and any possible other values
that are pertinent to the error.*


```solidity
error Exception(uint8, uint256, uint256, address, address);
```

