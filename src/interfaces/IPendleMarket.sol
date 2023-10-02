// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import "../lib/Pendle.sol";

interface IPendleMarket {
    function readTokens() external view returns (address, address, address);
}
