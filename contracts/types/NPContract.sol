// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
@author: Dave
@notice: NPContract is a struct that help manage existing 
NextPool contracts in the factory contract */
struct NPContract {
    string name;
    address token0;
    address token1;
    address creator;
    address contractAddress;
}