// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Pool} from "contracts/types/Pool.sol";
import {Currency} from "contracts/types/Currency.sol";


interface INextV1Pool {

    error PoolNotInitialized();

    // @notice: Emitted when a new pool is initialized
    event initialize(
        bytes32 indexed id,
        Currency indexed currency0,
        Currency indexed currency1,
        address creator,
        int24 fee
    );

    // @notice: Emitted for swaps between currency0 and currency1
    event Swap(
        address indexed sender,
        int128 amount0,
        int128 amount1,
        uint24 fee
    );

    // event LiquidityChanged(

    // );

    event feeRateChanged(
        uint256 feeRate
    );

    // @notice: return the reserves of that currency in the pool
    function reservesOf(address currency) external view returns (int256);

    // @notice: return the liquidity of that currency in the pool
    function liquidityOf(address currency) external view returns (int256);

    // @notice: provide to the reserve of the liquidity pool
    function provide(address currency0, address currency1, address provider) external payable;

    // @notice: withdraw of the reserve of the liquidity pool
    function withdraw(address currency) external;

    // @notice: swapping one token to another in the pool
    function swap(address currency0, address currency1, uint256 amount0, uint256 amount1) external;

    // @notice: creating liquidity tokens
    function createLiquidityTokens(address to, uint256 id, uint256 amount) external;

    // @notice: called by the user to pay what is owed
    function providerPayment(Currency memory token) external payable returns (uint256 paid);

    // @notice
    // function feeRateChange(int256 feeRate) external;

}