// contracts/GameItems.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract CustomERC1155BatchTransfer is ERC1155 {
    uint256 public constant GOLD = 0;
    uint256 public constant SILVER = 1;
    uint256 public constant THORS_HAMMER = 2;
    uint256 public constant SWORD = 3;
    uint256 public constant SHIELD = 4;

    constructor() ERC1155("https://someExampleUrl/{id}.json") {
        _mint(msg.sender, GOLD, 10**18, "");
        _mint(msg.sender, SILVER, 10**27, "");
        _mint(msg.sender, THORS_HAMMER, 10**18, "");
        _mint(msg.sender, SWORD, 10**9, "");
        _mint(msg.sender, SHIELD, 10**9, "");
    }

    // @dev: This funciton is for transfering multiple token to multiple addresse 
    // length of token ids and token addresses should be similar 
    function bachTransferMultipleTokensForMultipleUsers(address [] memory _toAddresses, uint256 [] memory _tokenIDs) public {
        require(_toAddresses.length == _tokenIDs.length, "Addresses and ids should be similer");
        for(uint i = 0; i < _toAddresses.length; i++){
            //safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes data)
            safeTransferFrom(msg.sender, _toAddresses[i], _tokenIDs[i], 1, "");
        }
    }

    //@dev: This function is for transfering same token for multiple addresses
    function batchTransferSingleTokenForMultipleAddresses(uint _id, address [] memory _toAddresses, uint [] memory _quantity) public {
        require(_toAddresses.length == _quantity.length, "Addresses and quantity should be same");
         for(uint i = 0; i < _toAddresses.length; i++){
            safeTransferFrom(msg.sender, _toAddresses[i], _id, _quantity[i],"");
        }
    }
}

// ["0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2", "0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db"]
// [1,2]

//["0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2", "0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db", "0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB", "0x617F2E2fD72FD9D5503197092aC168c91465E7f2"]
// [1,2,3,4]

//["0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2", "0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db", "0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB", "0x617F2E2fD72FD9D5503197092aC168c91465E7f2", "0x17F6AD8Ef982297579C203069C1DbfFE4348c372", "0x17F6AD8Ef982297579C203069C1DbfFE4348c372", "0x17F6AD8Ef982297579C203069C1DbfFE4348c372", "0x17F6AD8Ef982297579C203069C1DbfFE4348c372", "0x17F6AD8Ef982297579C203069C1DbfFE4348c372", "0x17F6AD8Ef982297579C203069C1DbfFE4348c372", "0x17F6AD8Ef982297579C203069C1DbfFE4348c372", "0x17F6AD8Ef982297579C203069C1DbfFE4348c372", "0x17F6AD8Ef982297579C203069C1DbfFE4348c372", "0x17F6AD8Ef982297579C203069C1DbfFE4348c372"]
// [1,2,3,4,0,1,2,3,4,0,1,2,3,4]

