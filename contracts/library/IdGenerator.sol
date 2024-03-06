// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {LiquidityProvider} from "contracts/types/LiquidityProvider.sol";

// @notice: library to compute id for the pools
library IdGenerator {

    // @notice: compute id for the LiquidityProvider
    function providerId(LiquidityProvider memory _provider) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(
            _provider.amountProvided,
            _provider.providerAddress
        ));
    }
}