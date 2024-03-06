// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

struct LiquidityProvider {
    bytes32 id;
    address providerAddress;
    uint256 amountProvided;
}