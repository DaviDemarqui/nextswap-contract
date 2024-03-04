// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Pool} from "contracts/types/Pool.sol";
import {Currency} from "contracts/types/Currency.sol";


interface INextV1Pool {

    error PoolNotInitialized();

    event initialize(
        bytes32 id,
        Currency currency0,
        Currency currency1,
        address creator,
        int24 fee
    );

    struct swapParams {
        bool zeroForOne; // The direction of the swap;
        int256 amoutSpecified; // The amout being Bought or Sold;
    }

    // @notice - return the reserves of that currency in the pool
    function reservesOf(address currency) external view returns (int256);

    function provideLiquidity(address currency0, address currency1) external payable;

    function removeLiquidity(address currency) external;

    // @notice: swapping one token to another in the pool
    function take(Currency memory currency, address to, uint256 amount) external;

    // @notice: creating liquidity tokens
    function mint(address to, uint256 id, uint256 amount) external;

    // @notice: burning tokens or permanently removing from circulation
    function burn(address from, uint256 id, uint256 amount) external;

    // @notice: called by the user to pay what is owed
    function settle(Currency memory token) external payable returns (uint256 paid);

    // @notice: swap against the given pool
    function swap(bytes32 poolId, swapParams memory params) external;



}