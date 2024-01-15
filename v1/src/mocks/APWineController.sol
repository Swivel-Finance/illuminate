// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

contract APWineController {
    uint256 private getNextPeriodStartReturn;

    uint256 public getNextPeriodStartCalled;
    mapping(address => uint256) public withdrawCalled;

    function getNextPeriodStartReturns(uint256 p) external {
        getNextPeriodStartReturn = p;
    }

    // todo (cannot write to this yet, similar problem to balanceOf)
    function getNextPeriodStart(uint256) external view returns (uint256) {
        return getNextPeriodStartReturn;
    }

    function withdraw(address f, uint256 a) external {
        withdrawCalled[f] = a;
    }
}
