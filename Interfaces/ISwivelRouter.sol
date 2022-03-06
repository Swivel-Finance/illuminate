// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.4;

import '../Utils/Hash.sol';
import '../Utils/Sig.sol';

interface ISwivelRouter {
    function initiate(Hash.Order[] calldata o, uint256[] calldata a, Sig.Components[] calldata c) external returns(bool);
    function redeemZcToken(address, uint256, uint256 ) external returns (bool);
}