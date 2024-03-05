// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {INextV1Pool} from "contracts/interfaces/INextV1Pool.sol";
import {Currency} from "contracts/types/Currency.sol";

abstract contract NextV1Pool is INextV1Pool {

    address public creator;
    uint256 public feeRate;

    // @inheritdoc: INextV1Pool
    mapping(address currency => int256 reserve) public override reservesOf;
    // @inheritdoc: INextV1Pool
    mapping (address currency => int256 liquidity) public override liquidityOf;

    constructor() {}
}