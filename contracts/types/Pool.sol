// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Currency} from "contracts/types/Currency.sol";

type LiquidityProvider is address;

struct Pool {
    bytes32 id;
    Currency currency0;
    Currency currency1;
    address creator;
    int24 fee;
}