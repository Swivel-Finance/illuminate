// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.16;

interface IPendle {
    function swapExactTokensForTokens(
        uint256,
        uint256,
        address[] calldata,
        address,
        uint256
    ) external returns (uint256[] memory);

    function redeemAfterExpiry(
        bytes32,
        address,
        uint256
    ) external;
}
