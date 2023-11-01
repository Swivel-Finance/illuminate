// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import "../lib/Pendle.sol";

interface IPendle {
    function swapExactTokenForPt(
        address,
        address,
        uint256,
        Pendle.ApproxParams calldata,
        Pendle.TokenInput calldata
    ) external returns (uint256, uint256);
    function redeemPyToToken(
        address receiver,
        address YT,
        uint256 netPyIn,
        TokenOutput calldata output
    ) external returns (uint256 netTokenOut) {
}
