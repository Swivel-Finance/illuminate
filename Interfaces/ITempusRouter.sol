// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.4;
import "./ITempusAMM.sol";
import "./ITempusPool.sol";


interface ITempusRouter {
    function depositAndFix(ITempusAMM tempusAMM, ITempusPool tempusPool, uint256 tokenAmount, bool isBackingToken, uint256 minTYSRate, uint256 deadline) external returns (uint256);
    function redeemToBacking(ITempusPool tempusPool,uint256 principalAmount, uint256 yieldAmount, address recipient) external;
}