// SPDX-License-Identifier: MIT
// @dev: This is the simple ERC721 token minter, and having token Burning functionality 
// built in the smart contract. 
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract ERC721NFTMinter is Ownable, ERC721URIStorage{
 
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;
  
  // We are creating the constructor to take Name of the NFT and the symbol of the NFT 
  // That are passing through the constructor. 
   constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol){
    // nextTokenId is initialized to 1, since starting at 0 leads to higher gas cost for the first minter
    //TOKENS IDS starts from 1(not 0)
    _tokenIds.increment();

   }

  //@dev:  Main Minter function that mints ERC721 nfts
  // @requere: _tokenURI; A URI string that contrains the token metadata.
  // @returns: Newly minted token id
  function mintNFT(string memory _tokenURI) public returns(uint256){
    require(msg.sender != address(0), "ERC721NFTMinter#mintNFT: ZERO_ADDRESS");
    uint256 newItemId = _tokenIds.current();
     
    // mint function to mint the tokens for the sender
    _safeMint(address(msg.sender), newItemId);
    // sent the token URI for the metadata
    _setTokenURI(newItemId, _tokenURI);
    _tokenIds.increment();
    return newItemId;
  }

  //@dev: For burning token
  //@note: Only owner can burn the token
  function burn(uint256 _tokenId) public  {
    require(msg.sender != address(0), "ERC721NFTMinter#burn: ZERO_ADDRESS");
    require(ownerOf(_tokenId) == msg.sender || owner() == msg.sender, "ERC721NFTMinter#burn: ONLY_OWNER");
    _burn(_tokenId);
  }
 /**
    @dev Returns the total tokens minted so far.
    1 is always subtracted from the Counter since it tracks the next available tokenId.
  */
  function totalSupply() public view returns (uint256) {
      return _tokenIds.current() - 1;
  }


}




