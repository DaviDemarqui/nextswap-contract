// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import {INextV1Pool} from "contracts/interfaces/INextV1Pool.sol";
import {IdGenerator} from "contracts/library/IdGenerator.sol";
import {LiquidityProvider} from "contracts/types/LiquidityProvider.sol";

// @author: 
contract NextV1Pool is INextV1Pool {

    address immutable public token0;
    address immutable public token1;
    uint256 immutable public feeRate;
    mapping(address => LiquidityProvider) public provider;

    // @inheritdoc: INextV1Pool
    mapping(address currency => uint256 reserve) public override reservesOf;
    // @inheritdoc: INextV1Pool
    mapping(address currency => uint256 liquidity) public override liquidityOf;

    constructor(
        address _token0,
        address _token1,
        uint256 _feeRate
    ) {
        token0 = _token0;
        token1 = _token1;
        feeRate = _feeRate;

        // @inheritdoc: INextV1Pool
        emit initialize(
            token0,
            token1,
            feeRate
        );
    }

    // @inheritdoc: INextV1Pool
    function provide(address _currency0, address _currency1, uint256 _amount0, uint256 _amount1) external override  {

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

        // @inheritdoc: INextV1Pool
        emit LiquidityChanged(_currency0, _currency1, liquidityOf[_currency0], liquidityOf[_currency1]);

        require(ERC20(_currency0).transferFrom(msg.sender, address(this), _amount0), "Transfer Failed");
    }

    // @inheritdoc: INextV1Pool
    function withdraw(address _currency0, address _currency1,  uint256 _amount0, uint256 _amount1) external override {

        require(_currency0 == token0 && _currency1 == token1, "Invalid Currency");
        require(msg.sender == provider[msg.sender].providerAddress, "This addres isn't from any provider");
        require(_amount0 <= provider[msg.sender].amountProvided0 && _amount1 <= provider[msg.sender].amountProvided1, "Can't withdraw more than provided");
        require(_amount0 > 0 && _amount1 > 0);

        // In case the provider make a complete withdraw he will be removed as provider
        if(provider[msg.sender].amountProvided0 == _amount0 && provider[msg.sender].amountProvided1 == _amount1) {
            delete provider[msg.sender];            
        }        
        
        reservesOf[_currency0] -= uint256(_amount0);
        liquidityOf[_currency0] -= uint256(_amount0);
        reservesOf[_currency1] -= uint256(_amount1);
        liquidityOf[_currency1] -= uint256(_amount1);

        // @inheritdoc: INextV1Pool
        emit LiquidityChanged(_currency0, _currency1, liquidityOf[_currency0], liquidityOf[_currency1]);

        require(ERC20(_currency0).transfer(msg.sender, _amount0) && ERC20(_currency1).transfer(msg.sender, _amount1));
    }

    // @inheritdoc: INextV1Pool
    function swap(address _currency0, address _currency1, uint256 _amount0, uint256 _amount1, bool _direction) external override {
        
        require(msg.sender == provider[msg.sender].providerAddress, "This addres isn't from any provider");
        require(_currency0 == token0 && _currency1 == token1, "Invalid Currency");
        require(_amount0 > 0 && _amount1 > 0, "The amount cannot be 0");
        
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

    }

    // @inheritdoc: INextV1Pool
    function mintTokens(address _to, address _currency, uint256 _amount) external override {

    }

    // @inheritdoc: INextV1Pool
    function burnTokens(address _to, address _currency, uint256 _amount) external override {

    }

    // @inheritdoc: INextV1Pool
    function providerPayment(address _token) external override returns (uint256 paid) {

    }

    // @inheritdoc: INextV1Pool
    function feeRateChange(uint256 _feeRate) external override {

    }

}