// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import 'src/mocks/ERC20.sol';

contract PendleToken is ERC20 {
    uint256 private expiryReturn;
    address private SYReturn;
    address private YTReturn;

    function expiryReturns(uint256 m) external {
        expiryReturn = m;
    }

    function expiry() external view returns (uint256) {
        return expiryReturn;
    }

    function SYReturns(address s) external {
        SYReturn = s;
    }

    function SY() external view returns (address) {
        return SYReturn;
    }

    function YTReturns(address y) external {
        YTReturn = y;
    }

    function YT() external view returns (address) {
        return YTReturn;
    }
}
