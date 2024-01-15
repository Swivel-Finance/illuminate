// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.20;

interface ITempusAMM {
    function balanceOf(address) external view returns (uint256);

    function tempusPool() external view returns (address);
}
