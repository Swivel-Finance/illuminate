// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import 'src/mocks/ERC5095.sol';

contract Creator {
    address private createReturn;

    struct CreateArgs {
        uint256 maturity;
        address redeemer;
        address lender;
        address marketPlace;
        string name;
        string symbol;
    }

    mapping(address => CreateArgs) public createCalled;

    function createReturns(address c) external {
        createReturn = c;
    }

    function create(
        address u,
        uint256 m,
        address r,
        address l,
        address mp,
        string calldata n,
        string calldata s
    ) external returns (address) {
        createCalled[u] = CreateArgs(m, r, l, mp, n, s);
        return createReturn;
    }
}
