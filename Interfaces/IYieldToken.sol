// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.4;

import "./IPErc20.sol";
import "./IErc2612.sol";

interface IYieldToken is IPErc20, IErc2612 {
    function maturity() external view returns(uint);
    function redeem(address, address, uint256) external returns (uint256);
}