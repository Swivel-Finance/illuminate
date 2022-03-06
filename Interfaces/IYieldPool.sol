// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.4;

interface IYieldPool is IPErc20, IErc2612 {
    function maturity() external view returns(uint32);
    function base() external view returns(IPErc20);
    function sellBase(address to, uint128 min) external returns(uint128);
    function sellBasePreview(uint128 baseIn) external view returns(uint128);
    function retrieveBase(address user) external returns(uint128);
}