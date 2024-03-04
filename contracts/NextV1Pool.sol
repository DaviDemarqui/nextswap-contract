// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

contract NextV1Pool {

    event newLiquidityProvider(address);
    event newPool(address token1, address token2);

    mapping(address => uint256) public liquidityProviders;

    /*

        First of all we must have an function to contribute  
    
    */
    
    function contribute() payable public {

    }

    function withdraw() public {

    }
}