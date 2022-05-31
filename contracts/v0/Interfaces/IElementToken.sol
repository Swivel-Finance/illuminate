// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.4;

import "./IPErc20.sol";

interface IElementToken is IPErc20 {
    function withdrawPrincipal(uint256 _amount, address _destination) external returns (uint256);
    function underlying() external view returns (IPErc20);
    function unlockTimestamp() external view returns (uint256);
}