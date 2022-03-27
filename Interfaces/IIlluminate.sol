// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.4;

interface IIlluminate {

    struct Market {
        address swivel;
        address yield;
        address element;
        address pendle;
        address tempus;
        address notional;
        address sense;
        address apwine;
        address illuminate;
    }

    function markets(address, uint256) external view returns (Market memory market);
}
