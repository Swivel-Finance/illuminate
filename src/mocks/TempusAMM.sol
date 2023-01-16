// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import 'src/interfaces/ITempusAMM.sol';

contract TempusAMM is ITempusAMM {
    uint256 private balanceOfReturn;
    address private tempusPoolReturn;

    function balanceOfReturns(uint256 b) external {
        balanceOfReturn = b;
    }

    function balanceOf(address) external view returns (uint256) {
        return balanceOfReturn;
    }

    function tempusPoolReturns(address p) external {
        tempusPoolReturn = p;
    }

    function tempusPool() external view returns (address) {
        return tempusPoolReturn;
    }
}
