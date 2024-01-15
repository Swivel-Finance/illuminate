// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.16;

import 'src/mocks/ERC20.sol';

contract SwivelToken is ERC20 {
    uint256 private maturityReturn;

    function maturityReturns(uint256 m) external {
        maturityReturn = m;
    }

    function maturity() external view returns (uint256) {
        return maturityReturn;
    }
}
