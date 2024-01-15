// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

contract APWineAMMPool {
    address private getUnderlyingOfIBTAddressReturn;
    address private getPTAddressReturn;

    function getUnderlyingOfIBTAddressReturns(address u) external {
        getUnderlyingOfIBTAddressReturn = u;
    }

    function getUnderlyingOfIBTAddress() external view returns (address) {
        return getUnderlyingOfIBTAddressReturn;
    }

    function getPTAddressReturns(address p) external {
        getPTAddressReturn = p;
    }

    function getPTAddress() external view returns (address) {
        return getPTAddressReturn;
    }
}
