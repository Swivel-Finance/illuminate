// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

interface IeETH {
    function unwrap(uint256 amount) external returns (uint256);
    function wrap(uint256 amount) external payable returns (uint256);
}