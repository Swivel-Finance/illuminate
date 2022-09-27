// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

contract Converter {
    struct ConvertArg {
        address underling;
        uint256 amount;
        uint256 minimum;
    }

    mapping(address => ConvertArg) public convertCalled;

    function convert(
        address c,
        address u,
        uint256 a,
        uint256 m
    ) external {
        convertCalled[c] = ConvertArg(u, a, m);
    }
}
