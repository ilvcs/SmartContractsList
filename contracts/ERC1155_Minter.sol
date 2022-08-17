// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.4;

// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/utils/Counters.sol";
// import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

// contract ERC1155NFTMinter is Ownable{

//    using Counters for Counters.Counter;
//   Counters.Counter private _tokenIds;

//   constructor(string _baseUriString) ERC1155( _baseUriString){
//      // nextTokenId is initialized to 1, since starting at 0 leads to higher gas cost for the first minter
//     //TOKENS IDS starts from 1(not 0)
//     _tokenIds.increment();
//   }

//   //@dev:  Main Minter function that mints ERC721 nfts
//   // @requere: _tokenURI; A URI string that contrains the token metadata.
//   // @returns: Newly minted token id
//   function mintNFT(
//     uint256 _initialSupply, 
//     string calldata _tokenURI
//     ) public returns(uint256){
//     uint256 tokenId = createNFT(msg.sender,_initialSupply,_tokenURI);
//     return tokenId;
//   }

//   function createNFT(address _owner, uint _count, string _uri ) internal returns(uint256){
//     uint256 newItemId = _tokenIds.current();
//      _tokenIds.increment();
//      _mint(_owner, newItemId, _count, _uri);
//      return newItemId;
//   }


// }