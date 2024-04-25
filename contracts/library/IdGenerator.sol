// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

library IdGenerator {
    function providerId(address _user) internal view returns (bytes32) {
        return keccak256(abi.encodePacked(
            _user,
            block.timestamp
        ));
    }
}