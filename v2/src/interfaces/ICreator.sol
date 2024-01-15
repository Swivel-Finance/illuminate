// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.20;

interface ICreator {
    function create(
        address,
        uint256,
        address,
        address,
        address,
        string calldata,
        string calldata
    ) external returns (address);
}
