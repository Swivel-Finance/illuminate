// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.20;

interface IConverter {
    function convert(bytes memory) external returns (uint256);
}
