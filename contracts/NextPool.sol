// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IdGenerator} from "contracts/library/IdGenerator.sol";
import {LiquidityProvider} from "contracts/types/LiquidityProvider.sol";

// @author: Dave
// @notice: This is the Pool contract of the NextSwap project
// this is currently incomplete, so a lot of thing may change
// in the future :)
contract NextPool {

    // ========================  
    // *   EVENTS & ERRORS    *  
    // ========================

    event initialized(
        address creator,
        address indexed currency0,
        address indexed currency1,
        uint256 fee
    );

    event TokenSwap(
        address indexed sender,
        address currency0,
        address currency1,
        uint256 amount0,
        uint256 amount1,
        bool direction
    );

    event LiquidityChanged(
        address indexed currency0,
        address indexed currency1,
        uint256 liquidity0,
        uint256 liquidity1
    );

    error InvalidProviderAddress();
    error PoolNotInitialized();
    error InvalidCurrency();
    error InvalidWithdraw();

    // ========================
    // *       STORAGE        *  
    // ========================

    address immutable public token0;
    address immutable public token1;
    uint256 immutable public feeRate;

    mapping(address => LiquidityProvider) public provider;
    mapping(address currency => uint256 reserve) public reservesOf;
    mapping(address currency => uint256 liquidity) public liquidityOf;

    constructor(
        address _token0,
        address _token1,
        uint256 _feeRate
    ) {
        token0 = _token0;
        token1 = _token1;
        feeRate = _feeRate;

        emit initialized(msg.sender, token0, token1, feeRate);
    }

    function provide(address _currency0, address _currency1, uint256 _amount0, uint256 _amount1) external  {

        require(_currency0 == token0 && _currency1 == token1, "Invalid Currency");

        reservesOf[_currency0] += uint256(_amount0);
        liquidityOf[_currency0] += uint256(_amount0);
        reservesOf[_currency1] += uint256(_amount1);
        liquidityOf[_currency1] += uint256(_amount1);

        LiquidityProvider memory newestProvider;
        newestProvider.providerAddress = msg.sender;
        newestProvider.amountProvided0 = _amount0;
        newestProvider.amountProvided1 = _amount1;
        newestProvider.id = IdGenerator.providerId(newestProvider);
        provider[msg.sender] = newestProvider;

        require(ERC20(_currency0).transferFrom(msg.sender, address(this), _amount0), "Transfer Failed");
        emit LiquidityChanged(_currency0, _currency1, liquidityOf[_currency0], liquidityOf[_currency1]);
    }

    function withdraw(address _currency0, address _currency1,  uint256 _amount0, uint256 _amount1) external {

        require(_amount0 > 0 && _amount1 > 0, "Invalid Ammount");

        if (_currency0 != token0 || _currency1 != token1) { revert InvalidCurrency(); }
        else if(provider[msg.sender].providerAddress == address(0)) { revert InvalidProviderAddress(); }

        // In case the provider make a complete withdraw he will be removed as provider
        if(provider[msg.sender].amountProvided0 == _amount0 && provider[msg.sender].amountProvided1 == _amount1) {
            delete provider[msg.sender];            
        }        
        
        reservesOf[_currency0] -= uint256(_amount0);
        liquidityOf[_currency0] -= uint256(_amount0);
        reservesOf[_currency1] -= uint256(_amount1);
        liquidityOf[_currency1] -= uint256(_amount1);

        require(ERC20(_currency0).transfer(msg.sender, _amount0) && ERC20(_currency1).transfer(msg.sender, _amount1));
        emit LiquidityChanged(_currency0, _currency1, liquidityOf[_currency0], liquidityOf[_currency1]);
    }

    //@param: _direction sort the direction of the swap using a boolean, true: 0 => 1, false: 1 => 0
    function swap(address _currency0, address _currency1, uint256 _amount0, uint256 _amount1, bool _direction) external {

        require(_amount0 > 0 && _amount1 > 0, "The amount cannot be 0");

        if (_currency0 != token0 || _currency1 != token1) { revert InvalidCurrency(); }
        else if(provider[msg.sender].providerAddress == address(0)) { revert InvalidProviderAddress(); }
        
        if(_direction) { // Swap 0 to 1
            reservesOf[_currency0] += uint256(_amount0);
            reservesOf[_currency1] -= uint256(_amount0);

            ERC20(token0).transferFrom(msg.sender, address(this), _amount0);
            ERC20(token1).transfer(msg.sender, _amount0);
        } else { // Swap 1 to 0
            reservesOf[_currency1] += uint256(_amount1);
            reservesOf[_currency0] -= uint256(_amount1);

            ERC20(token1).transferFrom(msg.sender, address(this), _amount1);
            ERC20(token0).transfer(msg.sender, _amount1);
        }

        emit TokenSwap(msg.sender, _currency0, _currency1, _amount0, _amount1, _direction);
    }

}