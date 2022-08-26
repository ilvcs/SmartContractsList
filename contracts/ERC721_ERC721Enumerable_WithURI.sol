// SPDX-License-Identifier: MIT    
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";   
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract UserAwards is ERC721, ERC721Enumerable{

  using Counters for Counters.Counter;
   Counters.Counter private _tokenIds;
   // mapping for token URIs
   mapping(uint256 => string) private _tokenURIs;
   constructor () ERC721("UserAwards", "AWARD") {
       _tokenIds.increment();
   }


// For setting token URI
function _setTokenURI(uint _tokenId, string memory _tokenURI) private {
    require(_exists(_tokenId), " URI set of nonexistent token");
    _tokenURIs[_tokenId] = _tokenURI;
}
    // For returning token URI
function tokenURI(uint _tokenId) public view  override returns (string memory){
    return _tokenURIs[_tokenId];
}

  function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
    super._beforeTokenTransfer(from, to, tokenId);
  }

  function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
    return super.supportsInterface(interfaceId);
  }

   function mintAward(address player, string memory _tokenURI)
        public
        returns (uint256)
    {
        uint256 newItemId = _tokenIds.current();
        _mint(player, newItemId);
        _setTokenURI(newItemId, _tokenURI);

        _tokenIds.increment();
        return newItemId;
    }
}