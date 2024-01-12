// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import 'src/mocks/ERC20.sol';

contract ERC5095 is ERC20 {
    address private poolReturn;
    bool private setPoolReturn;
    bool private approveMarketPlaceReturn;

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

    function approveMarketPlaceReturns(bool p) external {
        approveMarketPlaceReturn = p;
    }

    function approveMarketPlace() external view returns (bool) {
        return approveMarketPlaceReturn;
    }
}
