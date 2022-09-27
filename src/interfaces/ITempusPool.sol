// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.16;

import 'src/interfaces/IERC20Metadata.sol';

interface ITempusPool {
    function maturityTime() external view returns (uint256);

    function backingToken() external view returns (IERC20Metadata);

    // Used for integration testing
    function principalShare() external view returns (address);

    function currentInterestRate() external view returns (uint256);

    function initialInterestRate() external view returns (uint256);
}
