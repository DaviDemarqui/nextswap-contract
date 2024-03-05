// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {INextV1Pool} from "contracts/interfaces/INextV1Pool.sol";
import {Currency} from "contracts/types/Currency.sol";

 abstract contract NextV1Pool is INextV1Pool {

    address immutable public token0;
    address immutable public token1;
    uint256 immutable public feeRate;

    // @inheritdoc: INextV1Pool
    mapping(address currency => int256 reserve) public reservesOf;
    // @inheritdoc: INextV1Pool
    mapping (address currency => int256 liquidity) public liquidityOf;

    constructor(
        address _token0,
        address _token1,
        uint256 _feeRate
    ) {
        token0 = _token0;
        token1 = _token1;
        feeRate = _feeRate;
    }

}