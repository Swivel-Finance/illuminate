// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.4;

interface IAPWineVault {
    function withdraw(address _user, uint256 _amount) external;
}
