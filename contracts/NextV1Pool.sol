// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {INextV1Pool} from "contracts/interfaces/INextV1Pool.sol";
import {IdGenerator} from "contracts/library/IdGenerator.sol";
import {LiquidityProvider} from "contracts/types/LiquidityProvider.sol";

abstract contract NextV1Pool is INextV1Pool {

    address immutable public token0;
    address immutable public token1;
    uint256 immutable public feeRate;
    LiquidityProvider[] public provider;

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
    function provide(address _currency0, address _currency1, uint256 _amount) external override  {
        require(_currency0 == token0 && _currency1 == token1, "Invalid Currency");
        require(IERC20(_currency0).transferFrom(msg.sender, address(this), _amount), "Transfer Failed");

        reservesOf[_currency0] += uint256(_amount);
        liquidityOf[_currency0] += uint256(_amount);

        LiquidityProvider memory newestProvider;
        newestProvider.providerAddress = msg.sender;
        newestProvider.amountProvided = _amount;
        newestProvider.id = IdGenerator.providerId(newestProvider);
        provider.push(newestProvider);
    }

    // @inheritdoc: INextV1Pool
    function withdraw(uint256 _amount) external override {

    }

    // @inheritdoc: INextV1Pool
    function swap(address _currency0, address _currency1, uint256 _amount0, uint256 _amount1) external override {

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