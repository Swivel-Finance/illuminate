// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

contract PendleForge {
    bytes32 private forgeIdReturn;

    function forgeIdReturns(bytes32 f) external {
        forgeIdReturn = f;
    }

    function forgeId() external view returns (bytes32) {
        return forgeIdReturn;
    }
}
