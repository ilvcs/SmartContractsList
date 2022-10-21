// SPDX-License-Identifier: MIT    
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";   
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "hardhat/console.sol";

contract Onchain_Dynamic_NFT_ERC721 is ERC721, ERC721Enumerable{

  using Counters for Counters.Counter;
   Counters.Counter private _tokenIds;
   address public owner;
   uint score;
   // mapping for token URIs
   mapping(uint256 => string) private _tokenURIs;

   constructor () ERC721("UserAwards", "AWARD") {
       _tokenIds.increment();
       owner = msg.sender;
   }


// For returning token URI
function tokenURI(uint _tokenId) public view override  returns (string memory){

    return getTokenURI(_tokenId);
}

function getTokenURI(uint256 _id) public view returns (string memory){
    bytes memory dataURI = abi.encodePacked(
        '{',
            '"name": "Polygon Heros', Strings.toString(_id) , '",',
            '"description": "NFTs for Polygon Heros",',
            '"image": "', createDynamicImage(msg.sender, _id), '"',
            
        '}'
    );

    return string(
        abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(dataURI)
        )
    );
}

  function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
    super._beforeTokenTransfer(from, to, tokenId);
    
  }

  function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
    return super.supportsInterface(interfaceId);
  }

   function mintAward(address player)
        public
        returns (uint256)
    {
      //require(msg.sender == owner,"Only owner can mint the token");
        uint256 newItemId = _tokenIds.current();
        _mint(player, newItemId);

        _tokenIds.increment();
        return newItemId;
    }

    function substring( string memory str, uint startIndex, uint endIndex) private pure returns ( string memory) {
        bytes memory strBytes = bytes(str);
        bytes memory result = new bytes(endIndex-startIndex);
        for(uint i = startIndex; i < endIndex; i++) {
            result[i-startIndex] = strBytes[i];
        }
        return string(result);
    }

    function createDynamicImage(address _reciver, uint _tokenId) private view returns(string memory){

        string memory _reciverAddressAsString = Strings.toHexString(uint256(uint160(_reciver)), 20);
        string memory BACKGROUND = substring(_reciverAddressAsString, 2, 2+6);
        console.log("address", _reciverAddressAsString);
        console.log("Background", BACKGROUND);
        //string memory COLOUR1 = substring(_reciverAddressAsString, 9, 9+6);
       

        bytes memory svgImage = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
            '<rect width="100%" height="100%" fill="#',BACKGROUND,'"','/>',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',"Hero :",_reciverAddressAsString,'</text>',
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "TokenId: ", Strings.toString(_tokenId),'</text>',
            '</svg>'
        );

        //console.log("Image", Base64.encode(svgImage));

        return string(
            abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(svgImage)
            )
        );
    }
}