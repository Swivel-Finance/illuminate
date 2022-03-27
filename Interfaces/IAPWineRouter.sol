// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.4;

import "./IAPWineVault.sol";

interface IAPWineRouter {
    function withdraw(IAPWineVault _futureVault, uint256 _amount) external;
}
