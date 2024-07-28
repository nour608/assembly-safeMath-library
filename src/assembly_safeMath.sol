// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

library SafeMath {
    // Custom errors
    error AdditionOverflow(int256 lhs, int256 rhs);
    error AdditionUnderflow(int256 lhs, int256 rhs);
    error SubtractionOverflow(int256 lhs, int256 rhs);
    error SubtractionUnderflow(int256 lhs, int256 rhs);
    error MultiplicationOverflow(int256 lhs, int256 rhs);
    error DivisionByZero();
    error DivisionOverflow(int256 lhs, int256 rhs);

    /// @notice Returns lhs + rhs.
    /// @dev Reverts on overflow / underflow.
    function add(int256 lhs, int256 rhs) internal pure returns (int256 result) {
        assembly {
            result := add(lhs, rhs)
            // Check for overflow when both inputs are positive
            if and(sgt(lhs, 0), sgt(rhs, 0)) {
                if slt(result, lhs) {
                    mstore(0, 0x7e1eb7fc00000000000000000000000000000000000000000000000000000000) // AdditionOverflow selector
                    mstore(32, lhs)
                    mstore(64, rhs)
                    revert(0, 96)
                }
            }
            // Check for underflow when both inputs are negative
            if and(slt(lhs, 0), slt(rhs, 0)) {
                if sgt(result, lhs) {
                    mstore(0, 0x5d29679300000000000000000000000000000000000000000000000000000000) // AdditionUnderflow selector
                    mstore(32, lhs)
                    mstore(64, rhs)
                    revert(0, 96)
                }
            }
        }
    }

    /// @notice Returns lhs - rhs.
    /// @dev Reverts on overflow / underflow.
    function sub(int256 lhs, int256 rhs) internal pure returns (int256 result) {
        assembly {
            result := sub(lhs, rhs)
            if and(sgt(lhs, 0), slt(rhs, 0)) {
                if slt(result, lhs) {
                    mstore(0, 0x43ce8a4200000000000000000000000000000000000000000000000000000000) // SubtractionOverflow selector
                    mstore(32, lhs)
                    mstore(64, rhs)
                    revert(0, 96)
                }
            }
            // Check for overflow when lhs is negative and rhs is positive
            if and(slt(lhs, 0), sgt(rhs, 0)) {
                if sgt(result, lhs) {
                    mstore(0, 0x8c10517700000000000000000000000000000000000000000000000000000000) // SubtractionUnderflow selector
                    mstore(32, lhs)
                    mstore(64, rhs)
                    revert(0, 96)
                }
            }
        }
    }

    /// @notice Returns lhs * rhs.
    /// @dev Reverts on overflow.
    function mul(int256 lhs, int256 rhs) internal pure returns (int256 result) {
        // Convert this to assembly
        assembly {
            // Check if either input is zero
            if or(iszero(lhs), iszero(rhs)) { revert(0, 0) }
            // Perform multiplication
            result := mul(lhs, rhs)
            // Check for overflow
            if iszero(eq(sdiv(result, lhs), rhs)) {
                mstore(0, 0x0ac8e39d00000000000000000000000000000000000000000000000000000000) // MultiplicationOverflow selector
                mstore(32, lhs)
                mstore(64, rhs)
                revert(0, 96)
            }
            if iszero(eq(sdiv(result, rhs), lhs)) {
                mstore(0, 0x0ac8e39d00000000000000000000000000000000000000000000000000000000) // MultiplicationOverflow selector
                mstore(32, lhs)
                mstore(64, rhs)
                revert(0, 96)
            }
        }
    }

    /// @notice Returns lhs / rhs.
    /// @dev Reverts on division by zero and overflow.
    function div(int256 lhs, int256 rhs) internal pure returns (int256 result) {
        assembly {
            // Check for division by zero or division of zero
            if or(iszero(rhs), iszero(lhs)) {
                // If rhs is zero, it's division by zero. If lhs is zero, we can return early.
                if iszero(rhs) {
                    // Store "Division by zero" error
                    mstore(0, 0x18b69439) // DivisionByZero selector
                    revert(0, 4)
                }
                // If lhs is zero, return zero (no need to revert)
                result := 0
            }
            // 2. Check if lhs == INT256_MIN && rhs == -1 -> revert
            if and(
                eq(lhs, 0x8000000000000000000000000000000000000000000000000000000000000000),
                eq(rhs, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
            ) {
                // Store "Division overflow" error
                mstore(0, 0x91aa53a800000000000000000000000000000000000000000000000000000000) // DivisionOverflow selector
                mstore(32, lhs)
                mstore(64, rhs)
                revert(0, 96)
            }
            // Perform the division
            result := sdiv(lhs, rhs)
        }
    }
}
