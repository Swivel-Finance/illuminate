// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import 'src/mocks/ERC20.sol';

contract TempusToken is ERC20 {
    address private poolReturn;

    function poolReturns(address p) external {
        poolReturn = p;
    }

    function pool() external view returns (address) {
        return poolReturn;
    }
}
