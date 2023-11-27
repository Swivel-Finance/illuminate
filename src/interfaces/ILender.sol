// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.20;

interface ILender {
    function approve(address, address, address, address, address) external;

    function mint(uint8 p, address u, uint256 m, address t, uint256 a) external returns (uint256);

    function lend(uint8 p, address u, uint256 m, uint256[] memory a, bytes calldata d) external returns (uint256);

    function lend(uint8 p, address u, uint256 m, uint256[] memory a, bytes calldata d, address lst, uint256 swapMinimum) external payable returns (uint256);

    function validToken(address) external view returns(bool);

    function transferFYTs(address, uint256) external;

    function transferPremium(address, uint256) external;

    function paused(uint8) external returns (bool);

    function halted() external returns (bool);

    function feenominator() external returns (uint256);

    function protocolRouters(uint256) external returns (address);

    function ETHWrapper() external returns (address);

    function WETH() external returns (address);

    function curvePools(address) external returns (address);

    function convertDecimals(address, address, uint256) external view returns (uint256);

    function principalApprove(address[] calldata pt) external returns (bool);
}
