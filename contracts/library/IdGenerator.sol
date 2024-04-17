// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { LiquidityProvider } from "contracts/types/LiquidityProvider.sol";

// @notice: library to compute id for the pools
library IdGenerator {

    // @notice: compute id for the LiquidityProvider
    function providerId(LiquidityProvider memory _provider) internal view returns (bytes32) {
        return keccak256(abi.encodePacked(
            _provider.amountProvided0,
            _provider.amountProvided1,
            _provider.providerAddress,
            block.timestamp
        ));
    }
}