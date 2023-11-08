// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "../tokens/ERC20Permit.sol";
import "../interfaces/IERC5095.sol";
import "../errors/Exception.sol";
import "../interfaces/IMarketPlace.sol";

import "../lib/Cast.sol";
import "../lib/Safe.sol";

contract Term5095 is ERC20Permit {
    /// @dev unix timestamp when the ERC5095 token can be redeemed
    uint256 public immutable maturity;
    /// @dev address of the ERC20 token that is returned on ERC5095 redemption
    address public immutable underlying;

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
    ) external view returns (uint256) {
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
    ) external view returns (uint256) {
        if (block.timestamp < maturity) {
            return previewWithdraw(a);
        }
        return a;
    }

    /// @notice Returns user's PT balance
    /// @param o The address of the owner for which redemption is calculated
    /// @return uint256 The maximum amount of principal tokens that `owner` can redeem.
    function maxRedeem(address o) external view returns (uint256) {
        return _balanceOf[o];
    }

    /// @notice Post or at maturity, returns user's PT balance. Prior to maturity, returns 0.
    /// @param  o The address of the owner for which withdrawal is calculated
    /// @return uint256 maximum amount of underlying tokens that `owner` can withdraw.
    function maxWithdraw(address o) external view returns (uint256) {
        if (block.timestamp < maturity) {
            return 0;
        }
        return _balanceOf[o];
    }

    /// @notice After maturity, returns 0. Prior to maturity, returns the amount of `shares` when depositing `a` of an external protocol's PTs
    /// @param a The amount of underlying spent
    /// @return uint256 The amount of PT purchased by spending `a` of underlying
    function previewDeposit(uint256 a) public view returns (uint256) {
        if (block.timestamp < maturity) {
            return 1;
        }
        return 0;
    }

    /// @notice After maturity, returns 0. Prior to maturity, returns the amount of `assets` in underlying spent on acquiring `s` of the wrapped PTs
    /// @param s The amount of principal tokens bought in the simulation
    /// @return uint256 The amount of underlying required to purchase `s` of PT
    function previewMint(uint256 s) public view returns (uint256) {
        if (block.timestamp < maturity) {
            return 1;
        }
        return 0;
    }

    /// @notice Post or at maturity, simulates the effects of redemption. Prior to maturity, returns 0
    /// @param s The amount of principal tokens redeemed in the simulation
    /// @return uint256 The amount of underlying returned by `s` of PT redemption
    function previewRedeem(uint256 s) public view returns (uint256) {
        if (block.timestamp >= maturity) {
            // After maturity, the amount redeemed is based on the Redeemer contract's holdings of the underlying TODO: implement this feature? Its not in v1
            return 1;
        }
        // Prior to maturity, return 0
        return 0;
    }

    /// @notice Post or at maturity, simulates the effects of withdrawal at the current block. Prior to maturity, returns 0
    /// @param a The amount of underlying tokens withdrawn in the simulation
    /// @return uint256 The amount of principal tokens required for the withdrawal of `a`
    function previewWithdraw(uint256 a) public view returns (uint256) {
        if (block.timestamp >= maturity) {
            // After maturity, the amount redeemed is based on the Redeemer contract's holdings of the underlying TODO: implement this feature? Its not in v1
            return 1;
        }
        // Prior to maturity, return a a preview of a swap on the pool
        return 0;
    }

    function deposit(
        address r,
        uint256 a,
        uint256 m
    ) external returns (uint256) {
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

        // Ensure maturity is < 5095 maturity

        // Mint at a 1-1 ratio
        uint256 returned;

        // Pass the received shares onto the intended receiver
        _transfer(address(this), r, returned);

        return returned;
    }

    /// @notice Before maturity mints `shares` of PTs to `receiver` by spending underlying. Post or at maturity, reverts.
    /// @param s The amount of shares being minted
    /// @param r The receiver of the underlying tokens being withdrawn
    /// @return uint256 The amount of principal tokens purchased
    function mint(uint256 s, address r) external returns (uint256) {
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

        // Receive the funds from the sender (depends on ERC v NFT)

        // Ensure maturity is < 5095 maturity

        // Mint into iPT at a 1-1 ratio or TODO: create a wrap + mint method?
        uint256 returned;
        
        // Transfer the principal tokens to the desired receiver
        // TODO: consider just minting iPT?
        _transfer(address(this), r, s);

        return returned;
    }

    /// @notice At or after maturity, burns PTs from owner and sends `a` underlying to `r`.
    /// @param a The amount of underlying tokens withdrawn
    /// @param r The receiver of the underlying tokens being withdrawn
    /// @param o The owner of the underlying tokens
    /// @return uint256 The amount of principal tokens burnt by the withdrawal
    function withdraw(
        uint256 a,
        address r,
        address o
    ) external returns (uint256) {
        // Determine how many principal tokens are needed to purchase the underlying
        uint256 needed = previewWithdraw(a);

        // Post maturity
        // If owner is the sender, redeem PT without allowance check
        if (o == msg.sender) {
            // Execute the redemption through Term
            return
                (1);
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

            // Execute the redemption through Term
            return
                (1);
        }
    }

    /// @notice At or after maturity, burns exactly `shares` of Principal Tokens from `owner` and sends `assets` of underlying tokens to `receiver`.
    /// @param s The number of shares to be burned in exchange for the underlying asset
    /// @param r The receiver of the underlying tokens being withdrawn
    /// @param o Address of the owner of the shares being burned
    /// @return uint256 The amount of underlying tokens distributed by the redemption
    function redeem(
        uint256 s,
        address r,
        address o
    ) external returns (uint256) {
        // If owner is the sender, redeem PT without allowance check
        if (o == msg.sender) {
            // Execute the redemption through Term
            return (1);
        } else {
            // Get the allowance of the user spending the tokens
            uint256 allowance = _allowance[o][msg.sender];

            // Check for sufficient allowance
            if (allowance < s) {
                revert Exception(20, allowance, s, address(0), address(0));
            }

            // Update the caller's allowance
            _allowance[o][msg.sender] = allowance - s;

            // Execute the redemption through Term

            // Return funds to user
            return (1);
        }
    }
}
