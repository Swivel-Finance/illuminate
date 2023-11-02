// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "../tokens/ERC20Permit.sol";
import "../interfaces/IERC5095.sol";
import "../errors/Exception.sol";

import "../lib/Cast.sol";
import "../lib/Safe.sol";

contract Term5095 is ERC20Permit {
    /// @dev unix timestamp when the ERC5095 token can be redeemed
    uint256 public immutable maturity;
    /// @dev address of the ERC20 token that is returned on ERC5095 redemption
    address public immutable underlying;
    /// @dev address of the minting authority
    address public immutable lender;
    /// @dev address of the "marketplace" YieldSpace AMM router
    address public immutable marketplace;
    ///@dev Interface to interact with the pool
    address public pool;

    /// @dev address and interface for an external custody contract (necessary for some project's backwards compatability)
    address public immutable redeemer;

    /// @notice ensures that only a certain address can call the function
    /// @param a address that msg.sender must be to be authorized
    modifier authorized(address a) {
        if (msg.sender != a) {
            revert Exception(0, 0, 0, msg.sender, a);
        }
        _;
    }

    constructor(
        address _underlying,
        uint256 _maturity,
        string memory name_,
        string memory symbol_,
        uint8 decimals_
    ) ERC20Permit(name_, symbol_, decimals_) {
        underlying = _underlying;
        maturity = _maturity;
    }

    /// @notice Post or at maturity, converts an amount of principal tokens to an amount of underlying that would be returned.
    /// @param s The amount of principal tokens to convert
    /// @return uint256 The amount of underlying tokens returned by the conversion
    function convertToUnderlying(
        uint256 s
    ) external view override returns (uint256) {
        if (block.timestamp < maturity) {
            return previewRedeem(s);
        }
        return s;
    }

    /// @notice Post or at maturity, converts a desired amount of underlying tokens returned to principal tokens needed.
    /// @param a The amount of underlying tokens to convert
    /// @return uint256 The amount of principal tokens returned by the conversion
    function convertToShares(
        uint256 a
    ) external view override returns (uint256) {
        if (block.timestamp < maturity) {
            return previewWithdraw(a);
        }
        return a;
    }

    /// @notice Returns user's PT balance
    /// @param o The address of the owner for which redemption is calculated
    /// @return uint256 The maximum amount of principal tokens that `owner` can redeem.
    function maxRedeem(address o) external view override returns (uint256) {
        return _balanceOf[o];
    }

    /// @notice Post or at maturity, returns user's PT balance. Prior to maturity, returns a previewRedeem for owner's PT balance.
    /// @param  o The address of the owner for which withdrawal is calculated
    /// @return uint256 maximum amount of underlying tokens that `owner` can withdraw.
    function maxWithdraw(address o) external view override returns (uint256) {
        if (block.timestamp < maturity) {
            return previewRedeem(_balanceOf[o]);
        }
        return _balanceOf[o];
    }

    /// @notice After maturity, returns 0. Prior to maturity, returns the amount of `shares` when spending `a` in underlying on a YieldSpace AMM.
    /// @param a The amount of underlying spent
    /// @return uint256 The amount of PT purchased by spending `a` of underlying
    function previewDeposit(uint256 a) public view returns (uint256) {
        if (block.timestamp < maturity) {
            return 1;
        }
        return 0;
    }

    /// @notice After maturity, returns 0. Prior to maturity, returns the amount of `assets` in underlying spent on a purchase of `s` in PT on a YieldSpace AMM.
    /// @param s The amount of principal tokens bought in the simulation
    /// @return uint256 The amount of underlying required to purchase `s` of PT
    function previewMint(uint256 s) public view returns (uint256) {
        if (block.timestamp < maturity) {
            return 1;
        }
        return 0;
    }

    /// @notice Post or at maturity, simulates the effects of redemption. Prior to maturity, returns the amount of `assets` from a sale of `s` PTs on a YieldSpace AMM.
    /// @param s The amount of principal tokens redeemed in the simulation
    /// @return uint256 The amount of underlying returned by `s` of PT redemption
    function previewRedeem(uint256 s) public view override returns (uint256) {
        if (block.timestamp >= maturity) {
            // After maturity, the amount redeemed is based on the Redeemer contract's holdings of the underlying
            return 1;
        }

        // Prior to maturity, return a a preview of a swap on the pool
        return 0;
    }

    /// @notice Post or at maturity, simulates the effects of withdrawal at the current block. Prior to maturity, simulates the amount of PTs necessary to receive `a` in underlying from the sale of PTs on a YieldSpace AMM.
    /// @param a The amount of underlying tokens withdrawn in the simulation
    /// @return uint256 The amount of principal tokens required for the withdrawal of `a`
    function previewWithdraw(uint256 a) public view override returns (uint256) {
        if (block.timestamp >= maturity) {
            // After maturity, the amount redeemed is based on the Redeemer contract's holdings of the underlying
            return 1;
        }

        // Prior to maturity, return a a preview of a swap on the pool
        return 0;
    }

    /// @notice Before maturity spends `assets` of underlying, and sends `shares` of PTs to `receiver`. Post or at maturity, reverts.
    /// @param a The amount of underlying tokens deposited
    /// @param r The receiver of the principal tokens
    /// @return uint256 The amount of principal tokens burnt by the withdrawal
    function deposit(uint256 a, address r) external override returns (uint256) {
        // Execute the deposit
        return _deposit(r, a, 0);
    }

    /// @notice Before maturity mints `shares` of PTs to `receiver` by spending underlying. Post or at maturity, reverts.
    /// @param s The amount of shares being minted
    /// @param r The receiver of the underlying tokens being withdrawn
    /// @return uint256 The amount of principal tokens purchased
    function mint(uint256 s, address r) external override returns (uint256) {
        // Execute the mint
        return _mint(r, s, type(uint128).max);
    }

    /// @notice At or after maturity, burns PTs from owner and sends `a` underlying to `r`. Before maturity, sends `a` by selling shares of PT on a YieldSpace AMM.
    /// @param a The amount of underlying tokens withdrawn
    /// @param r The receiver of the underlying tokens being withdrawn
    /// @param o The owner of the underlying tokens
    /// @return uint256 The amount of principal tokens burnt by the withdrawal
    function withdraw(
        uint256 a,
        address r,
        address o
    ) external override returns (uint256) {
        // Execute the withdrawal
        return _withdraw(a, r, o, type(uint128).max);
    }

    /// @notice At or after maturity, burns PTs from owner and sends `a` underlying to `r`. Before maturity, sends `a` by selling shares of PT on a YieldSpace AMM.
    /// @param a The amount of underlying tokens withdrawn
    /// @param r The receiver of the underlying tokens being withdrawn
    /// @param o The owner of the underlying tokens
    /// @param m The maximum amount of PTs to sell in the YieldSpace AMM (pre maturity)
    /// @return uint256 The amount of principal tokens burnt by the withdrawal
    function withdraw(
        uint256 a,
        address r,
        address o,
        uint256 m
    ) external override returns (uint256) {
        // Execute the withdrawal
        return _withdraw(a, r, o, m);
    }

    /// @notice At or after maturity, burns exactly `shares` of Principal Tokens from `owner` and sends `assets` of underlying tokens to `receiver`. Before maturity, sells `s` of PT on a YieldSpace AMM.
    /// @param s The number of shares to be burned in exchange for the underlying asset
    /// @param r The receiver of the underlying tokens being withdrawn
    /// @param o Address of the owner of the shares being burned
    /// @return uint256 The amount of underlying tokens distributed by the redemption
    function redeem(
        uint256 s,
        address r,
        address o
    ) external override returns (uint256) {
        // Execute the redemption
        return _redeem(s, r, o, 0);
    }

    /// @notice At or after maturity, burns exactly `shares` of Principal Tokens from `owner` and sends `assets` of underlying tokens to `receiver`. Before maturity, sells `s` of PT on a YieldSpace AMM.
    /// @param s The number of shares to be burned in exchange for the underlying asset
    /// @param r The receiver of the underlying tokens being withdrawn
    /// @param o Address of the owner of the shares being burned
    /// @param m The minimum amount of underlying to receive (from sales pre-maturity)
    /// @return uint256 The amount of underlying tokens distributed by the redemption
    function redeem(
        uint256 s,
        address r,
        address o,
        uint256 m
    ) external override returns (uint256) {
        // Execute the redemption
        return _redeem(s, r, o, m);
    }

    /// @param o Address of the owner of the tokens
    /// @param s Address of the spender
    /// @param a Amount to be approved
    function authApprove(
        address o,
        address s,
        uint256 a
    ) external authorized(redeemer) returns (bool) {
        _allowance[o][s] = a;
        return true;
    }

    function _deposit(
        address r,
        uint256 a,
        uint256 m
    ) internal returns (uint256) {
        // Revert if called at or after maturity
        if (block.timestamp >= maturity) {
            revert Exception(
                21,
                block.timestamp,
                maturity,
                address(0),
                address(0)
            );
        }

        // Receive the funds from the sender

        // Wrap the PTs into the ERC5095 at a 1-1 basis
        uint256 returned;
        
        // Pass the received shares onto the intended receiver
        _transfer(address(this), r, returned);

        return returned;
    }

    function _mint(address r, uint256 s, uint256 m) internal returns (uint256) {
        // Revert if called at or after maturity
        if (block.timestamp >= maturity) {
            revert Exception(
                21,
                block.timestamp,
                maturity,
                address(0),
                address(0)
            );
        }

        // Determine how many underlying tokens are needed to mint the shares
        uint256 required = IYield(pool).buyFYTokenPreview(Cast.u128(s));

        // Transfer the underlying to the token
        Safe.transferFrom(
            IERC20(underlying),
            msg.sender,
            address(this),
            required
        );

        // Swap the underlying for principal tokens via the pool
        uint128 sold = IMarketPlace(marketplace).buyPrincipalToken(
            underlying,
            maturity,
            Cast.u128(s),
            Cast.u128(m)
        );

        // Transfer the principal tokens to the desired receiver
        _transfer(address(this), r, s);

        return sold;
    }

    function _withdraw(
        uint256 a,
        address r,
        address o,
        uint256 m
    ) internal returns (uint256) {
        // Determine how many principal tokens are needed to purchase the underlying
        uint256 needed = previewWithdraw(a);

        // Pre maturity
        if (block.timestamp < maturity) {
            // Receive the shares from the caller
            _transfer(o, address(this), needed);

            // If owner is the sender, sell PT without allowance check
            if (o == msg.sender) {
                uint128 returned = IMarketPlace(marketplace).buyUnderlying(
                    underlying,
                    maturity,
                    Cast.u128(a),
                    Cast.u128(m)
                );

                // Transfer the underlying to the desired receiver
                Safe.transfer(IERC20(underlying), r, a);

                return returned;
            } else {
                // Else, sell PT with allowance check
                // Get the allowance of the user spending the tokens
                uint256 allowance = _allowance[o][msg.sender];

                // Check for sufficient allowance
                if (allowance < needed) {
                    revert Exception(20, allowance, a, address(0), address(0));
                }

                // Update the caller's allowance
                _allowance[o][msg.sender] = allowance - needed;

                // Sell the principal tokens for underlying
                uint128 returned = IMarketPlace(marketplace).buyUnderlying(
                    underlying,
                    maturity,
                    Cast.u128(a),
                    Cast.u128(m)
                );

                // Transfer the underlying to the desired receiver
                Safe.transfer(IERC20(underlying), r, returned);

                return returned;
            }
        }
        // Post maturity
        else {
            // If owner is the sender, redeem PT without allowance check
            if (o == msg.sender) {
                // Execute the redemption to the desired receiver
                return
                    IRedeemer(redeemer).authRedeem(
                        underlying,
                        maturity,
                        msg.sender,
                        r,
                        needed
                    );
            } else {
                // Get the allowance of the user spending the tokens
                uint256 allowance = _allowance[o][msg.sender];

                // Check for sufficient allowance
                if (allowance < needed) {
                    revert Exception(
                        20,
                        allowance,
                        needed,
                        address(0),
                        address(0)
                    );
                }

                // Update the callers's allowance
                _allowance[o][msg.sender] = allowance - needed;

                // Execute the redemption to the desired receiver
                return
                    IRedeemer(redeemer).authRedeem(
                        underlying,
                        maturity,
                        o,
                        r,
                        needed
                    );
            }
        }
    }

    function _redeem(
        uint256 s,
        address r,
        address o,
        uint256 m
    ) internal returns (uint256) {
        // Pre-maturity
        if (block.timestamp < maturity) {
            // Receive the funds from the user
            _transfer(o, address(this), s);

            // If owner is the sender, sell PT without allowance check
            if (o == msg.sender) {
                // Swap principal tokens for the underlying asset
                uint128 returned = IMarketPlace(marketplace).sellPrincipalToken(
                    underlying,
                    maturity,
                    Cast.u128(s),
                    Cast.u128(m)
                );

                // Transfer underlying to the desired receiver
                Safe.transfer(IERC20(underlying), r, returned);
                return returned;
                // Else, sell PT with allowance check
            } else {
                // Get the allowance of the user spending the tokens
                uint256 allowance = _allowance[o][msg.sender];

                // Check for sufficient allowance
                if (allowance < s) {
                    revert Exception(20, allowance, s, address(0), address(0));
                }

                // Update the caller's allowance
                _allowance[o][msg.sender] = allowance - s;

                // Sell the principal tokens for the underlying
                uint128 returned = IMarketPlace(marketplace).sellPrincipalToken(
                    underlying,
                    maturity,
                    Cast.u128(s),
                    Cast.u128(m)
                );

                // Transfer the underlying to the desired receiver
                Safe.transfer(IERC20(underlying), r, returned);
                return returned;
            }
            // Post-maturity
        } else {
            // If owner is the sender, redeem PT without allowance check
            if (o == msg.sender) {
                // Execute the redemption to the desired receiver
                return
                    IRedeemer(redeemer).authRedeem(
                        underlying,
                        maturity,
                        msg.sender,
                        r,
                        s
                    );
            } else {
                // Get the allowance of the user spending the tokens
                uint256 allowance = _allowance[o][msg.sender];

                // Check for sufficient allowance
                if (allowance < s) {
                    revert Exception(20, allowance, s, address(0), address(0));
                }

                // Update the caller's allowance
                _allowance[o][msg.sender] = allowance - s;

                // Execute the redemption to the desired receiver
                return
                    IRedeemer(redeemer).authRedeem(
                        underlying,
                        maturity,
                        o,
                        r,
                        s
                    );
            }
        }
    }
}
