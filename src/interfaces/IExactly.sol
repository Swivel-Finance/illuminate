  // SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.20;

interface IExactly {
    /// @notice Deposits a certain amount to a maturity.
    /// @param maturity maturity date where the assets will be deposited.
    /// @param assets amount to receive from the msg.sender.
    /// @param minAssetsRequired minimum amount of assets required by the depositor for the transaction to be accepted.
    /// @param receiver address that will be able to withdraw the deposited assets.
    /// @return positionAssets total amount of assets (principal + fee) to be withdrawn at maturity.
    function depositAtMaturity(
        uint256 maturity,
        uint256 assets,
        uint256 minAssetsRequired,
        address receiver
    ) external returns (uint256 positionAssets);


    function withdrawAtMaturity(
    uint256 maturity,
    uint256 positionAssets,
    uint256 minAssetsRequired,
    address receiver,
    address owner
    ) external returns (uint256 assetsDiscounted);

    function asset() external view returns (address);
}
