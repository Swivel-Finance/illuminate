// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import 'src/tokens/ERC20Permit.sol';
import 'src/interfaces/IERC5095.sol';
import 'src/interfaces/IRedeemer.sol';
import 'src/interfaces/IMarketPlace.sol';
import 'src/interfaces/IYield.sol';
import 'src/errors/Exception.sol';
import 'src/lib/Cast.sol';

contract ERC5095 is ERC20Permit, IERC5095 {
    /// @dev unix timestamp when the ERC5095 token can be redeemed
    uint256 public immutable override maturity;
    /// @dev address of the ERC20 token that is returned on ERC5095 redemption
    address public immutable override underlying;
    /// @dev address of the minting authority
    address public immutable lender;
    /// @dev address of the "marketplace" YieldSpace AMM router
    address public immutable marketplace;
    ///@dev Interface to interact with the pool
    address public immutable pool;

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
        address _redeemer,
        address _lender,
        address _marketplace,
        string memory name_,
        string memory symbol_,
        uint8 decimals_
    ) ERC20Permit(name_, symbol_, decimals_) {
        underlying = _underlying;
        maturity = _maturity;
        redeemer = _redeemer;
        lender = _lender;
        marketplace = _marketplace;
        pool = IMarketPlace(marketplace).pools(underlying, maturity);
    }

    /// @notice Post or at maturity converts an amount of principal tokens to an amount of underlying that would be returned.
    /// @param s The amount of principal tokens to convert
    /// @return uint256 The amount of underlying tokens returned by the conversion
    function convertToUnderlying(uint256 s)
        external
        view
        override
        returns (uint256)
    {
        if (block.timestamp < maturity) {
            return previewRedeem(s);
        }
        return s;
    }

    /// @notice Post or at maturity converts a desired amount of underlying tokens returned to principal tokens needed.
    /// @param a The amount of underlying tokens to convert
    /// @return uint256 The amount of principal tokens returned by the conversion
    function convertToShares(uint256 a)
        external
        view
        override
        returns (uint256)
    {
        if (block.timestamp < maturity) {
            return previewWithdraw(a);
        }
        return a;
    }

    /// @notice Post or at maturity returns user's PT balance. Pre maturity, returns a previewRedeem for owner's PT balance.
    /// @param o The address of the owner for which redemption is calculated
    /// @return uint256 The maximum amount of principal tokens that `owner` can redeem.
    function maxRedeem(address o) external view override returns (uint256) {
        if (block.timestamp < maturity) {
            return previewRedeem(_balanceOf[o]);
        }
        return _balanceOf[o];
    }

    /// @notice Post or at maturity returns user's PT balance. Pre maturity, returns a previewWithdraw for owner's PT balance.
    /// @param  o The address of the owner for which withdrawal is calculated
    /// @return uint256 maximum amount of underlying tokens that `owner` can withdraw.
    function maxWithdraw(address o) external view override returns (uint256) {
        if (block.timestamp < maturity) {
            return previewWithdraw(_balanceOf[address(this)]);
        }
        return _balanceOf[o];
    }

    /// @notice Post or at maturity returns 0. Pre maturity returns the amount of `shares` when spending `assets` in underlying on a YieldSpace AMM.
    /// @param a The amount of underlying spent
    /// @return uint256 The amount of PT purchased by spending `assets` of underlying
    function previewDeposit(uint256 a) public view returns (uint256) {
        if (block.timestamp < maturity) {
            return IYield(pool).sellBasePreview(Cast.u128(a));
        }
        return 0;
    }

    /// @notice Post or at maturity returns 0. Pre maturity returns the amount of `assets` in underlying spent on a purchase of `shares` in PT on a YieldSpace AMM.
    /// @param s the amount of principal tokens bought in the simulation
    /// @return uint256 The amount of underlying spent to purchase `shares` of PT
    function previewMint(uint256 s) public view returns (uint256) {
        if (block.timestamp < maturity) {
            return IYield(pool).buyFYTokenPreview(Cast.u128(s));
        }
        return 0;
    }

    /// @notice Post or at maturity simulates the effects of redeemption at the current block. Pre maturity returns the amount of `assets from a sale of `shares` in PT from a sale of PT on a YieldSpace AMM.
    /// @param s the amount of principal tokens redeemed in the simulation
    /// @return uint256 The amount of underlying returned by `shares` of PT redemption
    function previewRedeem(uint256 s) public view override returns (uint256) {
        if (block.timestamp > maturity) {
            return s;
        }
        return IYield(pool).sellFYTokenPreview(Cast.u128(s));
    }

    /// @notice Post or at maturity simulates the effects of withdrawal at the current block. Pre maturity simulates the amount of `shares` in PT necessary to receive `assets` in underlying from a sale of PT on a YieldSpace AMM.
    /// @param a the amount of underlying tokens withdrawn in the simulation
    /// @return uint256 The amount of principal tokens required for the withdrawal of `assets`
    function previewWithdraw(uint256 a) public view override returns (uint256) {
        if (block.timestamp > maturity) {
            return a;
        }
        return IYield(pool).buyBasePreview(Cast.u128(a));
    }

    /// @notice Before maturity spends `assets` of underlying, and sends `shares` of PTs to `receiver`. Post or at maturity, reverts.
    /// @param r The receiver of the underlying tokens being withdrawn
    /// @param a The amount of underlying tokens withdrawn
    /// @return uint256 The amount of principal tokens burnt by the withdrawal
    function deposit(address r, uint256 a) external override returns (uint256) {
        if (block.timestamp > maturity) {
            revert Exception(
                21,
                block.timestamp,
                maturity,
                address(0),
                address(0)
            );
        }
        uint128 shares = Cast.u128(previewDeposit(a));
        IERC20(underlying).transferFrom(msg.sender, address(this), a);
        // consider the hardcoded slippage limit, 4626 compliance requires no minimum param.
        uint128 returned = IMarketPlace(marketplace).sellUnderlying(
            underlying,
            maturity,
            Cast.u128(a),
            shares - (shares / 100)
        );
        _transfer(address(this), r, returned);
        return returned;
    }

    /// @notice Before maturity mints `shares` of PTs to `receiver` and spending `assets` of underlying. Post or at maturity, reverts.
    /// @param r The receiver of the underlying tokens being withdrawn
    /// @param s The amount of underlying tokens withdrawn
    /// @return uint256 The amount of principal tokens burnt by the withdrawal
    function mint(address r, uint256 s) external override returns (uint256) {
        if (block.timestamp > maturity) {
            revert Exception(
                21,
                block.timestamp,
                maturity,
                address(0),
                address(0)
            );
        }
        uint128 assets = Cast.u128(previewMint(s));
        IERC20(underlying).transferFrom(msg.sender, address(this), assets);
        // consider the hardcoded slippage limit, 4626 compliance requires no minimum param.
        uint128 returned = IMarketPlace(marketplace).sellUnderlying(
            underlying,
            maturity,
            assets,
            assets - (assets / 100)
        );
        _transfer(address(this), r, returned);
        return returned;
    }

    /// @notice At or after maturity, Burns `shares` from `owner` and sends exactly `assets` of underlying tokens to `receiver`. Before maturity, sends `assets` by selling shares of PT on a YieldSpace AMM.
    /// @param a The amount of underlying tokens withdrawn
    /// @param r The receiver of the underlying tokens being withdrawn
    /// @param o The owner of the underlying tokens
    /// @return uint256 The amount of principal tokens burnt by the withdrawal
    function withdraw(
        uint256 a,
        address r,
        address o
    ) external override returns (uint256) {
        // Pre maturity
        if (block.timestamp < maturity) {
            uint128 shares = Cast.u128(previewWithdraw(a));
            // If owner is the sender, sell PT without allowance check
            if (o == msg.sender) {
                uint128 returned = IMarketPlace(marketplace).sellPrincipalToken(
                    underlying,
                    maturity,
                    shares,
                    Cast.u128(a - (a / 100))
                );
                IERC20(underlying).transfer(r, returned);
                return returned;
                // Else, sell PT with allowance check
            } else {
                uint256 allowance = _allowance[o][msg.sender];
                if (allowance < shares) {
                    revert Exception(
                        20,
                        allowance,
                        shares,
                        address(0),
                        address(0)
                    );
                }
                _allowance[o][msg.sender] = allowance - shares;
                uint128 returned = IMarketPlace(marketplace).sellPrincipalToken(
                    underlying,
                    maturity,
                    Cast.u128(shares),
                    Cast.u128(a - (a / 100))
                );
                IERC20(underlying).transfer(r, returned);
                return returned;
            }
        }
        // Post maturity
        else {
            if (o == msg.sender) {
                return
                    IRedeemer(redeemer).authRedeem(
                        underlying,
                        maturity,
                        msg.sender,
                        r,
                        a
                    );
            } else {
                uint256 allowance = _allowance[o][msg.sender];
                if (allowance < a) {
                    revert Exception(20, allowance, a, address(0), address(0));
                }
                _allowance[o][msg.sender] = allowance - a;
                return
                    IRedeemer(redeemer).authRedeem(
                        underlying,
                        maturity,
                        o,
                        r,
                        a
                    );
            }
        }
    }

    /// @notice At or after maturity, burns exactly `shares` of Principal Tokens from `owner` and sends `assets` of underlying tokens to `receiver`. Before maturity, sends `assets` by selling `shares` of PT on a YieldSpace AMM.
    /// @param s The number of shares to be burned in exchange for the underlying asset
    /// @param r The receiver of the underlying tokens being withdrawn
    /// @param o Address of the owner of the shares being burned
    /// @return uint256 The amount of underlying tokens distributed by the redemption
    function redeem(
        uint256 s,
        address r,
        address o
    ) external override returns (uint256) {
        // Pre-maturity
        if (block.timestamp < maturity) {
            uint128 assets = Cast.u128(previewRedeem(s));
            // If owner is the sender, sell PT without allowance check
            if (o == msg.sender) {
                uint128 returned = IMarketPlace(marketplace).sellPrincipalToken(
                    underlying,
                    maturity,
                    Cast.u128(s),
                    assets - (assets / 100)
                );
                IERC20(underlying).transfer(r, returned);
                return returned;
                // Else, sell PT with allowance check
            } else {
                uint256 allowance = _allowance[o][msg.sender];
                if (allowance < s) {
                    revert Exception(20, allowance, s, address(0), address(0));
                }
                _allowance[o][msg.sender] = allowance - s;
                uint128 returned = IMarketPlace(marketplace).sellPrincipalToken(
                    underlying,
                    maturity,
                    Cast.u128(s),
                    assets - (assets / 100)
                );
                IERC20(underlying).transfer(r, returned);
                return returned;
            }
            // Post-maturity
        } else {
            if (o == msg.sender) {
                return
                    IRedeemer(redeemer).authRedeem(
                        underlying,
                        maturity,
                        msg.sender,
                        r,
                        s
                    );
            } else {
                uint256 allowance = _allowance[o][msg.sender];
                if (allowance < s) {
                    revert Exception(20, allowance, s, address(0), address(0));
                }
                _allowance[o][msg.sender] = allowance - s;
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

    /// @param f Address to burn from
    /// @param a Amount to burn
    /// @return bool true if successful
    function authBurn(address f, uint256 a)
        external
        authorized(redeemer)
        returns (bool)
    {
        _burn(f, a);
        return true;
    }

    /// @param t Address recieving the minted amount
    /// @param a The amount to mint
    /// @return bool true if successful
    function authMint(address t, uint256 a)
        external
        authorized(lender)
        returns (bool)
    {
        _mint(t, a);
        return true;
    }

    /// @param o Address having its approvals edited 
    /// @param a The amount to mint
    /// @return bool true if successful
    function authApproval(address o, uint256 a)
        external
        authorized(redeemer)
        returns (bool)
    {
        _allowance[o][redeemer] = a;
        return true;
    }
}
