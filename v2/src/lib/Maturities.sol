// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.20;

import "../interfaces/IERC5095.sol";
import "../interfaces/ISwivelToken.sol";
import "../interfaces/IYieldToken.sol";
import "../interfaces/IElementToken.sol";
import "../interfaces/IPendleToken.sol";
import "../interfaces/ITempusToken.sol";
import "../interfaces/ITempusPool.sol";
import "../interfaces/IAPWineToken.sol";
import "../interfaces/IAPWineFutureVault.sol";
import "../interfaces/IAPWineController.sol";
import "../interfaces/INotional.sol";

library Maturities {
    /// @notice returns the maturity for an Illumiante principal token
    /// @param p address of the principal token contract
    /// @return uint256 maturity of the principal token
    function illuminate(address p) internal view returns (uint256) {
        return IERC5095(p).maturity();
    }

    /// @notice returns the maturity for a Swivel principal token
    /// @param p address of the principal token contract
    /// @return uint256 maturity of the principal token
    function swivel(address p) internal view returns (uint256) {
        return ISwivelToken(p).maturity();
    }

    function yield(address p) internal view returns (uint256) {
        return IYieldToken(p).maturity();
    }

    /// @notice returns the maturity for an Element principal token
    /// @param p address of the principal token contract
    /// @return uint256 maturity of the principal token
    function element(address p) internal view returns (uint256) {
        return IElementToken(p).unlockTimestamp();
    }

    /// @notice returns the maturity for a Pendle principal token
    /// @param p address of the principal token contract
    /// @return uint256 maturity of the principal token
    function pendle(address p) internal view returns (uint256) {
        return IPendleToken(p).expiry();
    }

    /// @notice returns the maturity for a Tempus principal token
    /// @param p address of the principal token contract
    /// @return uint256 maturity of the principal token
    function tempus(address p) internal view returns (uint256) {
        return ITempusPool(ITempusToken(p).pool()).maturityTime();
    }

    /// @notice returns the maturity for a APWine principal token
    /// @param p address of the principal token contract
    /// @return uint256 maturity of the principal token
    function apwine(address p) internal view returns (uint256) {
        address futureVault = IAPWineToken(p).futureVault();

        address controller = IAPWineFutureVault(futureVault)
            .getControllerAddress();

        uint256 duration = IAPWineFutureVault(futureVault).PERIOD_DURATION();

        return IAPWineController(controller).getNextPeriodStart(duration);
    }

    /// @notice returns the maturity for a Notional principal token
    /// @param p address of the principal token contract
    /// @return uint256 maturity of the principal token
    function notional(address p) internal view returns (uint256) {
        return INotional(p).getMaturity();
    }
}
