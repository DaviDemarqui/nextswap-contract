// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Currency} from "../types/Currency.sol";

interface INextV1Pool {

    error PoolNotInitialized();

    // @notice: Emitted when a new pool is initialized
    event initialize(
        bytes32 indexed id,
        Currency indexed currency0,
        Currency indexed currency1,
        address creator,
        uint256 fee
    );

    event Swap(
        address indexed sender,
        Currency currency0,
        Currency currency1,
        int128 amount0,
        int128 amount1,
        uint24 fee
    );

    // @notice: Emitted when some change is made in the liquidity of the pool
    event LiquidityChanged(
        Currency currency,
        uint256 liquidity
    );

    // @notice: Emitted when some change is made in the feeRate of the pool
    event feeRateChanged(
        uint256 feeRate
    );

    // @notice: return the reserves of that currency in the pool
    function reservesOf(Currency memory currency) external view returns (uint256);

    // @notice: return the liquidity of that currency in the pool
    function liquidityOf(Currency memory currency) external view returns (uint256);

    // @notice: provide to the reserve of the liquidity pool
    function provide(Currency memory currency0, Currency memory currency1, address provider) external payable;

    // @notice: withdraw of the reserve of the liquidity pool
    function withdraw(Currency memory currency) external;

    // @notice: swapping one token to another in the pool
    function swap(Currency memory currency0, Currency memory currency1, uint256 amount0, uint256 amount1) external;

    // @notice: create or mint liquidity tokens
    function mintTokens(address to, Currency memory Currency, uint256 amount) external;
    
    // @notice: burn liquidity tokens
    function burnTokens(address to, Currency memory Currency, uint256 amount) external;

    // @notice: called by the user to pay what is owed
    function providerPayment(Currency memory token) external payable returns (uint256 paid);

    // @notice: change the fee rate of the pool
    function feeRateChange(uint256 feeRate) external;

}