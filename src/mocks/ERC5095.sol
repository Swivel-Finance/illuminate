// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import 'src/mocks/ERC20.sol';

contract ERC5095 is ERC20 {
    address private poolReturn;
    bool private setPoolReturn;

    address public setPoolCalled;

    function poolReturns(address p) external {
        poolReturn = p;
    }

    function pool() external view returns (address) {
        return poolReturn;
    }

    function setPoolReturns(bool p) external {
        setPoolReturn = p;
    }

    function setPool(address p) external returns (bool) {
        setPoolCalled = p;

        return setPoolReturn;
    }
}
