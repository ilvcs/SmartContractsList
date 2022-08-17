// SPDX-License-Identifier: MIT"
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
//

import "hardhat/console.sol";


contract NFTMarketplace is ReentrancyGuard {
  // We allow only this contract addrss to deposit
   IERC721 public NFTContract;
  // For the only stable coin that we are acceptiong here
   IERC20 public SUSDC;

  using Counters for Counters.Counter;
  Counters.Counter private _itemCounter;

 enum State {Listed , Sold }
 // The market Item struct containt the tokenid, seller address,
 // owners address and price and status of the selling(sold or not)
  struct MarketItem {
    uint256 marketId;
    uint256 tokenId;
    address seller;
    address owner;
    uint256 price;
    State state;
   }
  // Mapping of token id and market items
  mapping(uint256 => MarketItem) private marketItems;
 

  // EVENTS
   event MarketItemListed (
    uint256  marketId,
    uint256 indexed tokenId,
    address indexed seller,
    address indexed buyer,
    uint256 price,
    State   state
  );

  event MarketItemSold (
    uint256  marketId,
    uint256 indexed tokenId,
    address indexed seller,
    address indexed buyer,
    uint256 price,
    State  state
    );


  constructor(address _nftMinterAddress, address _stableCoinAddress){
    require(_nftMinterAddress != address(0), "NFT Minter Address Should not be Null");
    require(_stableCoinAddress != address(0), "Stable Coin Address Should not be Null");
    NFTContract = IERC721(_nftMinterAddress);
    SUSDC = IERC20(_stableCoinAddress);
    // For making sure the item counter will start from 1 not zero
    _itemCounter.increment();
  }

  function listNFT( uint256 _tokenId, uint256 _price) public isNFTOwner(_tokenId, msg.sender) nonReentrant {
    require(_price > 0, "Price Must be atleast 1 wei");
    require(msg.sender != address(0), "Address should be an user");
    require(NFTContract.getApproved(_tokenId) == address(this),"NFT Must be approved to list in the market");
   
    uint256 id = _itemCounter.current();
    marketItems[id] = MarketItem(id, _tokenId, msg.sender, address(this), _price, State.Listed);
    //Transfer token to reciver
   
    _itemCounter.increment();

    //Emits the listed
    emit MarketItemListed(
      id,
      _tokenId,
      msg.sender,
      address(this),
      _price,
      State.Listed
    );


  }

  function buyNFT(uint256 _id) public nonReentrant {
    require(msg.sender != address(0), "ZERO_ADDRESS");

    MarketItem storage item = marketItems[_id];
    uint256 price = item.price;
    uint256 tokenId = item.tokenId;

    require(NFTContract.getApproved(tokenId) == address(this),"NFT Must be approved to list in the market");
    // Require to transfer the tokens to
    // Tokens should be approved to the NFTMarketplace address so that 
    // The marketplace contract can transfer tokens to the seller
    require(SUSDC.allowance(msg.sender, address(this)) >= price,"Insuficient Allowance");
    require(SUSDC.transferFrom(msg.sender,item.seller,price),"transfer Failed");
    NFTContract.transferFrom(item.seller, msg.sender, tokenId);

    item.owner = msg.sender;
    item.state = State.Sold;
    // Deletes the market item after it soldout
    delete marketItems[tokenId];
    emit MarketItemSold(
        _id,
        tokenId,
        item.seller,
        msg.sender,
        price,
        item.state
        );

  }

  // Fetches all the nfts listed in the marketplace
  // @dev: This is not scalable try to have something for pagination.
  function fetchAllListedItems() public view returns(MarketItem[] memory) {
    uint total = _itemCounter.current();
    MarketItem[] memory items = new MarketItem[](total);
    // For the item arry index
    uint index = 0;
    for(uint i = 1; i <= total ; i++){
      if(marketItems[i].marketId > 0){
         items[index] = marketItems[i];
      }
     
      index++;
    }

    return items;

  }

  modifier isNFTOwner(
    uint256 tokenId,
    address spender
) {
    address owner = NFTContract.ownerOf(tokenId);
    require(spender == owner, "Only Owner Can List items");
    _;
}

}
