// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.16;

interface IAPWineToken {
    // Todo will be used to get the maturity
    function futureVault() external view returns (address);
}
