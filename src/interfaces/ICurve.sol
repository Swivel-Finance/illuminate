// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

interface ICurve {
    function exchange(
        int128,
        int128,
        uint256,
        uint256
    ) external returns (uint256);

    function get_dy(int128, int128, uint256) external returns (uint256);

    function coins(int128) external returns (address);
}

interface ICurveV2 {
    function exchange(
        address,
        address,
        address,
        uint256,
        uint256,
        address
    ) external payable returns (uint256);

    function exchange_with_best_rate(
        address,
        address,
        address,
        uint256,
        uint256,
        address
    ) external payable returns (uint256);
}