// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.16;

interface IConverter {
    function convert(
        address,
        address,
        uint256
    ) external;
}
