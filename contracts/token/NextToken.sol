// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// @author: Dave
// @notice: This is the LP Token contract for the Nextswap project.
contract NextToken is ERC20 {

    address public owner;
    uint256 public _totalSupply;

    modifier onlyOwner {
        require(msg.sender == owner, "invalid sender");
        _;
    }

    constructor(uint256 _initialSuppy) ERC20("NEXT Token", "NXT") {
        _mint(msg.sender, _initialSuppy);
        owner = msg.sender;
    }

    function mint(address to, uint256 amount) onlyOwner external {
        require(msg.sender == owner, "Only the owner can mint");
        _mint(to, amount);
        _totalSupply += amount;
    }

    function burn(address from, uint256 amount) onlyOwner external {
        require(msg.sender == owner, "Only the owner can burn");
        _burn(from, amount);
        _totalSupply += amount;
    }

}