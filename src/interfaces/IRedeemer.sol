// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

interface IRedeemer {
    function authRedeem(
        address underlying,
        uint256 maturity,
        address from,
        address to,
        uint256 amount
    ) external returns (uint256);

    function redeem(uint8 p, address u, uint256 m, bytes calldata d) external returns (uint256);

    function redeem(address u, uint256 m) external returns (uint256);

    function convert(address lst, uint256 amount, uint256 swapMinimum) external returns (uint256 returned, uint256 slippageRatio);

    function approve(address p) external;

    function holdings(address u, uint256 m) external view returns (uint256);
}
