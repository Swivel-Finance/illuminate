# Exception
[Git Source](https://github.com/Swivel-Finance/illuminate/blob/76b26ef748dc63cf89e3fa660df1bda262dcef15/src/errors/Exception.sol)

*A single custom error capable of indicating a wide range of detected errors by providing
an error code value whose string representation is documented in errors.txt, and any possible other values
that are pertinent to the error.*


```solidity
error Exception(uint8, uint256, uint256, address, address);
```

