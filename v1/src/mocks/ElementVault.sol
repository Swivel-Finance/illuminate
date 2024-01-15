// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import 'src/mocks/ERC20.sol';
import 'src/lib/Element.sol';

contract ElementVault {
    ERC20 pt;

    constructor(address p) {
        pt = ERC20(p);
    }

    struct SwapArgs {
        address recipient;
        uint256 swapAmount;
        uint256 limit;
        uint256 deadline;
    }

    uint256 private swapReturn;

    mapping(address => SwapArgs) public swapCalled;
    mapping(address => uint256) public withdrawPrincipalCalled;

    function swapReturns(uint256 s) external {
        swapReturn = s;
    }

    function swap(
        Element.SingleSwap memory s,
        Element.FundManagement memory f,
        uint256 l,
        uint256 d
    ) external returns (uint256) {
        pt.balanceOfReturns(s.amount + pt.balanceOf(msg.sender));
        swapCalled[f.sender] = SwapArgs(f.recipient, s.amount, l, d);
        return swapReturn;
    }

    function withdrawPrincipal(uint256 a, address d) external {
        withdrawPrincipalCalled[d] = a;
    }
}
