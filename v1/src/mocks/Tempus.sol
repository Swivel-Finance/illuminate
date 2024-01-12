// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import 'src/interfaces/IAny.sol';
import 'src/interfaces/ITempus.sol';

import 'src/mocks/ERC20.sol';

contract Tempus is ITempus {
    ERC20 pt;

    struct RedeemToBackingArgs {
        uint256 amount;
        uint256 yield;
        address recipient;
    }

    struct DepositAndFixArgs {
        address amm;
        bool bt;
        uint256 minimumReturned;
        uint256 deadline;
    }

    mapping(address => RedeemToBackingArgs) public redeemToBackingCalled;
    mapping(uint256 => DepositAndFixArgs) public depositAndFixCalled;

    constructor(address p) {
        pt = ERC20(p);
    }

    function depositAndFix(
        address x,
        uint256 a,
        bool bt,
        uint256 mr,
        uint256 d
    ) external {
        pt.balanceOfReturns(a + pt.balanceOf(address(0)));
        depositAndFixCalled[a] = DepositAndFixArgs(x, bt, mr, d);
    }

    function redeemToBacking(
        address o,
        uint256 a,
        uint256 y,
        address r
    ) external {
        redeemToBackingCalled[o] = RedeemToBackingArgs(a, y, r);
    }
}
