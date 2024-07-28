## Introduction

**Since v0.8.0, Solidity supports overflow and underflow checks for arithmetic operations, but inline assembly does not. This discrepancy necessitates a custom implementation to ensure the same level of safety when working with assembly code. This library presents a SafeMath library written in inline assembly to provide these essential checks, preventing potential vulnerabilities in smart contracts that rely on low-level arithmetic operations.**

## Contract Overview

**The SafeMath library includes four arithmetic functions (add, sub, mul, div) with overflow and underflow checks using assembly. Custom errors enhance readability and debugging.**

## Documentation

One of the complex operation was the division, let’s Breakdown of Division Function:

- **Division by Zero Check**: Ensures rhs is not zero.
- **INT256_MIN/-1 Check**: Prevents overflow when lhs is INT256_MIN and rhs is -1.
  - `eq(lhs, 0x8000...0000)`: Checks if the left-hand side is equal to INT256_MIN (the smallest possible int256).
  - `eq(rhs, 0xffff...ffff)`: Checks if the right-hand side is equal to -1 in two's complement representation.

This part prevents the overflow that would occur when dividing INT256_MIN by -1, as the result (2^255) is too large to be represented in an int256.

- **Division Operation**: Performs signed division using `sdiv`.

## Usage

If you are developing smart contracts and using assembly/Yul code, this SafeMath library will definitely assist you, especially with complex arithmetic operations. By ensuring overflow and underflow checks, it offers a reliable way to handle arithmetic in low-level assembly, crucial for maintaining contract integrity and security.

## Tests

I'm very lazy to write tests. :(

## Conclusion

While this project demonstrates high code quality and rigorous testing, it has not been audited and should be used cautiously.
