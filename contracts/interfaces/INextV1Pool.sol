// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface INextV1Pool {

    error PoolNotInitialized();

    // @notice: Emitted when a new pool is initialized
    event initialize(
        address indexed currency0,
        address indexed currency1,
        uint256 fee
    );

    event Swap(
        address indexed sender,
        address currency0,
        address currency1,
        int128 amount0,
        int128 amount1,
        uint24 fee
    );

    // @notice: Emitted when some change is made in the liquidity of the pool
    event LiquidityChanged(
        address currency0,
        address currency1,
        uint256 liquidity0,
        uint256 liquidity1
    );

    // @notice: Emitted when some change is made in the feeRate of the pool
    event feeRateChanged(
        uint256 feeRate
    );

    // @notice: return the reserves of that currency in the pool
    function reservesOf(address _currency) external view returns (uint256);

    // @notice: return the liquidity of that currency in the pool
    function liquidityOf(address _currency) external view returns (uint256);

    // @notice: provide to the reserve of the liquidity pool
    function provide(address _currency0, address _currency1, uint256 _amount) external;

    // @notice: withdraw of the reserve of the liquidity pool
    function withdraw(address _currency0, address _currency1, uint256 _amount) external;

    // @notice: swapping one token to another in the pool
    function swap(address _currency0, address _currency1, uint256 _amount0, uint256 _amount1) external;

    // @notice: create or mint liquidity tokens
    function mintTokens(address _to, address _currency, uint256 _amount) external;
    
    // @notice: burn liquidity tokens
    function burnTokens(address _to, address _currency, uint256 _amount) external;

    // @notice: called by the user to pay what is owed
    function providerPayment(address _token) external returns (uint256 paid);

    // @notice: change the fee rate of the pool
    function feeRateChange(uint256 _feeRate) external;

}