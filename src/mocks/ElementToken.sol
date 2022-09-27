// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import 'src/mocks/ERC20.sol';

contract ElementToken is ERC20 {
    address private underlyingReturn;
    uint256 private unlockTimestampReturn;
    uint256 private withdrawPrincipalReturn;

    mapping(address => uint256) public withdrawPrincipalCalled;

    function unlockTimestampReturns(uint256 u) external {
        unlockTimestampReturn = u;
    }

    function underlyingReturns(address a) external {
        underlyingReturn = a;
    }

    function unlockTimestamp() external view returns (uint256) {
        return unlockTimestampReturn;
    }

    function underlying() external view returns (address) {
        return underlyingReturn;
    }

    function withdrawPrincipalReturns(uint256 w) external {
        withdrawPrincipalReturn = w;
    }

    function withdrawPrincipal(uint256 a, address d)
        external
        returns (uint256)
    {
        withdrawPrincipalCalled[d] = a;
        return withdrawPrincipalReturn;
    }
}
