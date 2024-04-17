// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

struct LiquidityProvider {
    bytes32 id;
    address providerAddress;
    uint256 amountProvided0;
    uint256 amountProvided1;
}