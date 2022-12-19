// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import 'src/mocks/ERC20.sol';

contract IlluminatePrincipalToken is ERC20 {
    bool private mintReturn;
    bool private burnReturn;
    uint256 private maturityReturn;

    mapping(address => uint256) public mintCalled;
    mapping(address => uint256) public burnCalled;

    function mintReturns(bool s) external {
        mintReturn = s;
    }

    function authMint(address t, uint256 a) external returns (bool) {
        mintCalled[t] = a;
        return mintReturn;
    }

    function burnReturns(bool s) external {
        burnReturn = s;
    }

    function authBurn(address f, uint256 a) external returns (bool) {
        burnCalled[f] = a;
        return burnReturn;
    }

    function maturityReturns(uint256 m) external {
        maturityReturn = m;
    }

    function maturity() external view returns (uint256) {
        return maturityReturn;
    }
}
