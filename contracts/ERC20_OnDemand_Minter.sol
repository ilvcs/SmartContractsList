// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SUSDC_Minter_OnDemand is ERC20, Ownable {
    // For minting minimum supply of the tokens
    constructor(uint256 initialSupply) ERC20("Shine USDC Stable Coin", "SUSDC") {
        _mint(msg.sender, initialSupply);
    }

    // @dev: For restricting the access to the genaral public
    // just add onlyOwner, so that only owner of the contract
    // can mint the tokens
    // @dev: Can add Accesscontrol to provide access roles for minting
    // and buring using Accesscontroll library
    function mintForUser(uint256 _amount) public{
      require(msg.sender != address(0), "Not a valid smart contract");
      _mint(address(msg.sender), _amount);
    }

}