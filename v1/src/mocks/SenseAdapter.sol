// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.16;

contract SenseAdapter {
    address private underlyingReturn;
    address private dividerReturn;
    address private targetReturn;
    uint256 private maxmReturn;

    function underlyingReturns(address u) external {
        underlyingReturn = u;
    }

    function underlying() external view returns (address) {
        return underlyingReturn;
    }

    function dividerReturns(address d) external {
        dividerReturn = d;
    }

    function divider() external view returns (address) {
        return dividerReturn;
    }

    function targetReturns(address t) external {
        targetReturn = t;
    }

    function target() external view returns (address) {
        return targetReturn;
    }

    function maxmReturns(uint256 m) external {
        maxmReturn = m;
    }

    function maxm() external view returns (uint256) {
        return maxmReturn;
    }
}
