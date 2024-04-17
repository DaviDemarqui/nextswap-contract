// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// author: @DaviDemarqui
// @notice: This is the LP Token contract for the Nextswap project.

contract NextToken is ERC20 {

    address public owner;
    uint256 public _totalSupply;

    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {
        owner = msg.sender;
    }

    function mint(address to, uint256 amount) external {
        require(msg.sender == owner, "Only the owner can mint");
        _mint(to, amount);
        _totalSupply += amount;
    }

    function burn(address from, uint256 amount) external {
        require(msg.sender == owner, "Only the owner can burn");
        _burn(from, amount);
        _totalSupply += amount;
    }

}