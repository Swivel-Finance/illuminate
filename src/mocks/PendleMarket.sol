// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import 'src/mocks/ERC20.sol';

contract PendleMarket is ERC20 {
    address readTokenReturn;

    function readTokensReturns(address r) external {
        readTokenReturn = r;
    }

    function readTokens() external view returns (address, address, address) {
        return (address(0), readTokenReturn, address(0));
    }
}
