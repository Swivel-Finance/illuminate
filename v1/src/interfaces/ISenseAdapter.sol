// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.16;

interface ISenseAdapter {
    function underlying() external view returns (address);

    function divider() external view returns (address);

    function target() external view returns (address);

    function maxm() external view returns (uint256);
}
