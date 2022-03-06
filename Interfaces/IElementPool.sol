// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.4;

import "./IAsset.sol";

interface IElementPool {
    struct SingleSwap {
        bytes32 poolId;
        SwapKind kind;
        IAsset assetIn;
        IAsset assetOut;
        uint256 amount;
        bytes userData;
    }
    struct FundManagement {
        address sender;
        bool fromInternalBalance;
        address payable recipient;
        bool toInternalBalance;
    }
    enum SwapKind { GIVEN_IN, GIVEN_OUT }
    function swap(SingleSwap calldata singleSwap, FundManagement calldata funds,uint256 limit,uint256 deadline) external returns (uint256 amountCalculated);
}