// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./NextPool.sol";

// @author: Dave
// @notice: This is the factory contract reponsable for creating
// new NextPool contracts
contract NextPoolFactory {

    address[] public deployedPools;

    event NewPoolCreated(address _newPool, address _creator);

    function createNextPool(address _token0, address _token1) public {
        address newPool = address(new NextPool(_token0, _token1, msg.sender));
        deployedPools.push(newPool);
        emit NewPoolCreated(newPool, msg.sender);
    }

    function getDeployedPools() public view returns (address[] memory) {
        return deployedPools;
    }
    
}