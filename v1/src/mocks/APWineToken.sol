// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import 'src/mocks/ERC20.sol';

contract APWineToken is ERC20 {
    address private futureVaultReturn;

    function futureVaultReturns(address f) external {
        futureVaultReturn = f;
    }

    function futureVault() external view returns (address) {
        return futureVaultReturn;
    }
}
