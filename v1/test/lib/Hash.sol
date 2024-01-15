// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.16;

/**
  @notice Encapsulation of the logic to produce EIP712 hashed domain and messages.
  Also to produce / verify hashed and signed Orders.
  See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-712.md
  See/attribute https://github.com/0xProject/0x-monorepo/blob/development/contracts/utils/contracts/src/LibEIP712.sol
*/

/// @notice typehash values apply to Swivel v2.0.0

library Hash {
    /// @dev struct represents the attributes of an offchain Swivel.Order
    struct Order {
        bytes32 key;
        uint8 protocol;
        address maker;
        address underlying;
        bool vault;
        bool exit;
        uint256 principal;
        uint256 premium;
        uint256 maturity;
        uint256 expiry;
    }

    // EIP712 Domain Separator typeHash
    // keccak256(abi.encodePacked(
    //     'EIP712Domain(',
    //     'string name,',
    //     'string version,',
    //     'uint256 chainId,',
    //     'address verifyingContract',
    //     ')'
    // ));
    bytes32 internal constant DOMAIN_TYPEHASH =
        0x33a944726038178b6e6e3425554538c8846b7d9376a33d0dd7bbb91f89cef01f;

    // EIP712 typeHash of an Order
    // keccak256(abi.encodePacked(
    //     'Order(',
    //     'bytes32 key,',
    //     'uint8 protocol,',
    //     'address maker,',
    //     'address underlying,',
    //     'bool vault,',
    //     'bool exit,',
    //     'uint256 principal,',
    //     'uint256 premium,',
    //     'uint256 maturity,',
    //     'uint256 expiry',
    //     ')'
    // ));
    bytes32 internal constant ORDER_TYPEHASH =
        0xbc200cfe92556575f801f821f26e6d54f6421fa132e4b2d65319cac1c687d8e6;

    /// @param n EIP712 domain name
    /// @param version EIP712 semantic version string
    /// @param i Chain ID
    /// @param verifier address of the verifying contract
    function domain(
        string memory n,
        string memory version,
        uint256 i,
        address verifier
    ) internal pure returns (bytes32) {
        bytes32 hash;

        assembly {
            let nameHash := keccak256(add(n, 32), mload(n))
            let versionHash := keccak256(add(version, 32), mload(version))
            let pointer := mload(64)
            mstore(pointer, DOMAIN_TYPEHASH)
            mstore(add(pointer, 32), nameHash)
            mstore(add(pointer, 64), versionHash)
            mstore(add(pointer, 96), i)
            mstore(add(pointer, 128), verifier)
            hash := keccak256(pointer, 160)
        }

        return hash;
    }

    /// @param d Type hash of the domain separator (see Hash.domain)
    /// @param h EIP712 hash struct (order for example)
    function message(bytes32 d, bytes32 h) internal pure returns (bytes32) {
        bytes32 hash;

        assembly {
            let pointer := mload(64)
            mstore(
                pointer,
                0x1901000000000000000000000000000000000000000000000000000000000000
            )
            mstore(add(pointer, 2), d)
            mstore(add(pointer, 34), h)
            hash := keccak256(pointer, 66)
        }

        return hash;
    }

    /// @param o A Swivel Order
    function order(Order memory o) internal pure returns (bytes32) {
        return
            keccak256(
                abi.encode(
                    Hash.ORDER_TYPEHASH,
                    o.key,
                    o.protocol,
                    o.maker,
                    o.underlying,
                    o.vault,
                    o.exit,
                    o.principal,
                    o.premium,
                    o.maturity,
                    o.expiry
                )
            );
    }
}
