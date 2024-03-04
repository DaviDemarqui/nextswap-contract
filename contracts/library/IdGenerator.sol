// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Pool} from "contracts/types/Pool.sol";

// @notice library to compute id for the pools
library IdGenerator {
    function toId(Pool memory pool) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(
            pool.creator,
            pool.currency0.currency,
            pool.currency1.currency,
            pool.fee
        ));
    }
}