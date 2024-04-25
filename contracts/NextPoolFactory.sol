// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./NextPool.sol";
import "./types/NPContract.sol";

// @author: Dave
// @notice: This is the factory contract reponsable for creating
// new NextPool contracts and store info about them
contract NextPoolFactory {

    NPContract[] deployedPoolAddresses;

    event NewPoolCreated(address _newPool, address _creator);
    error PoolWithChosenTokensAlreadyExists(address _token0, address _token1);

    // Check the array if a pool with the same tokens already exists
    modifier checkExistingPool(address _token0, address _token1) {
        for (uint256 i = 0; i < deployedPoolAddresses.length; i++) {
            if(deployedPoolAddresses[i].token0 == _token0 && deployedPoolAddresses[i].token1 == _token1) {
                revert PoolWithChosenTokensAlreadyExists(_token0, _token1);
            }
        }
        _;
    }

    function createNextPool(string memory _name, address _token0, address _token1) public {
        address newPool = address(new NextPool(_token0, _token1, msg.sender));
        NPContract memory npContract = NPContract({
            name: _name,
            token0: _token0,
            token1: _token1,
            creator: msg.sender,
            contractAddress: newPool 
        });

        deployedPoolAddresses.push(npContract);
        emit NewPoolCreated(newPool, msg.sender);
    }

    function getDeployedPools() public view returns (NPContract[] memory) {
        return deployedPoolAddresses;
    }
    
}