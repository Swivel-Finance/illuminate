// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.20;

import {IAdapter} from 'src/interfaces/IAdapter.sol';
import {ISwivel} from 'src/interfaces/ISwivel.sol';
import {IERC20} from 'src/interfaces/IERC20.sol';
import {IYield} from 'src/interfaces/IYield.sol';
import {IMarketPlace} from 'src/interfaces/IMarketPlace.sol';

import {Swivel} from 'src/lib/Swivel.sol';
import {Exception} from 'src/errors/Exception.sol';
import {Safe} from 'src/lib/Safe.sol';

// NOTE: The storage of the adapter _must_ exactly match the storage layout of the Lender
contract SwivelAdapter is IAdapter {
    /// @notice minimum wait before the admin may withdraw funds or change the fee rate
    uint256 public constant HOLD = 3 days;

    /// @notice address that is allowed to set and withdraw fees, disable principals, etc. It is commonly used in the authorized modifier.
    address public admin;
    /// @notice address of the MarketPlace contract, used to access the markets mapping
    address public marketPlace;
    /// @notice mapping that determines if a principal has been paused by the admin
    mapping(uint8 => bool) public paused;
    /// @notice flag that allows admin to stop all lending and minting across the entire protocol
    bool public halted;

    /// @notice protocol specific addresses that adapters reference when executing lends
    /// @dev these addresses are references by an implied enum; adapters hardcode the index for their protocol
    address[] public protocolRouters;

    /// @notice a mapping that tracks the amount of unswapped premium by market. This underlying is later transferred to the Redeemer during Swivel's redeem call
    mapping(address => mapping(uint256 => uint256)) public premiums;

    /// @notice this value determines the amount of fees paid on loans
    uint256 public feenominator;
    /// @notice represents a point in time where the feenominator may change
    uint256 public feeChange;
    /// @notice represents a minimum that the feenominator must exceed
    uint256 public constant MIN_FEENOMINATOR = 500;

    /// @notice maps underlying tokens to the amount of fees accumulated for that token
    mapping(address => uint256) public fees;
    /// @notice maps a token address to a point in time, a hold, after which a withdrawal can be made
    mapping(address => uint256) public withdrawals;

    // Reantrancy protection
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;
    uint256 private _status = _NOT_ENTERED;

    // Rate limiting protection
    /// @notice maximum amount of value that can flow through a protocol in a day (in USD)
    uint256 public maximumValue = 250_000e27;
    /// @notice maps protocols to how much value, in USD, has flowed through each protocol
    mapping(uint8 => uint256) public protocolFlow;
    /// @notice timestamp from which values flowing through protocol has begun
    mapping(uint8 => uint256) public periodStart;
    /// @notice estimated price of ether, set by the admin
    uint256 public etherPrice = 2_500;

    function approve(address[] calldata a) external {
        address[] memory underlyings = abi.decode('', (address[]));

        for (uint256 i = 0; i < underlyings.length; ) {
            IERC20(underlyings[i]).approve(
                protocolRouters[0],
                type(uint256).max
            );
            unchecked {
                i++;
            }
        }
    }

    function lend(bytes calldata d) external returns (uint256, uint256) {
        // Parse the calldata into the arguments
        (
            uint256[] memory amounts,
            Swivel.Order[] memory orders,
            Swivel.Components[] memory components,
            address pool,
            uint256 slippage,
            bool swapFlag
        ) = abi.decode(
                d,
                (
                    uint256[],
                    Swivel.Order[],
                    Swivel.Components[],
                    address,
                    uint256,
                    bool
                )
            );

        // Cache a couple oft-referenced variables
        address underlying = orders[0].underlying;
        uint256 maturity = orders[0].maturity;
        address pt = IMarketPlace(marketPlace).markets(underlying, maturity, 1);

        // verify orders are for the same underlying
        {
            for (uint256 i = 0; i < orders.length; ) {
                if (
                    underlying != orders[i].underlying ||
                    maturity != orders[i].maturity
                ) {
                    revert Exception(0, 0, 0, address(0), address(0)); // TODO: assign exception code
                }

                unchecked {
                    i++;
                }
            }
        }

        // get the amount of the orders
        uint256 total;
        uint256 fee;
        {
            for (uint256 i = 0; i < amounts.length; ) {
                total += amounts[i];

                // extract fee
                if (i == amounts.length - 1) {
                    fee = total / feenominator;
                    amounts[i] = amounts[i] - fee;
                    total = total - fee;
                    fees[underlying] += fee;
                }

                unchecked {
                    i++;
                }
            }
        }

        // receive the underlying funds from the user
        Safe.transferFrom(
            IERC20(underlying),
            msg.sender,
            address(this),
            total + fee
        );

        // store amount of iPTs to be minted to user
        uint256 received = IERC20(pt).balanceOf(address(this));

        // execute the orders
        uint256 premium = IERC20(underlying).balanceOf(address(this));
        ISwivel(protocolRouters[0]).initiate(orders, amounts, components);
        premium = IERC20(underlying).balanceOf(address(this)) - premium;
        received = IERC20(pt).balanceOf(address(this)) - received;

        // Swap the premium for iPTs or return premium to the sender
        if (swapFlag) {
            received += swap(pool, underlying, premium, slippage);
        } else {
            premiums[underlying][maturity] += premium;
            received += premium;
        }

        return (received, total);
    }

    /// @notice facilitates a swap for Illuminate's principal tokens
    /// @param p Yield Space pool for the market
    /// @param u underlying asset being sold for PTs
    /// @param a amount of underlying to be swapped
    /// @param m minimum number of tokens to receive
    /// @return received amount of PTs received in swap
    function swap(
        address p,
        address u,
        uint256 a,
        uint256 m
    ) internal returns (uint256) {
        // transfer funds to the pool
        Safe.transfer(IERC20(u), p, a);

        uint256 received = IYield(p).sellBase(address(this), uint128(a));
        if (received < m) {
            revert Exception(0, 0, 0, address(0), address(0)); // TODO: add exception code
        }

        return received;
    }
}
