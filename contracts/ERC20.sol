// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SUSDC is ERC20 {
    constructor(
       string memory _tokenName,
       string memory _ticker,
      uint256 _initialSupply
    ) ERC20(_tokenName, _ticker) {
        _mint(msg.sender, _initialSupply);
    }
}