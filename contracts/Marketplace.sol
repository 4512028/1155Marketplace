// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
 
contract  Marketplace is ERC1155Holder {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    Counters.Counter private _nftSold;
    IERC1155 private nftContract;
    address private owner;
    uint256 private platformFee = 25;
    uint256 private deno = 1000;

    constructor(address _nftContract) {
        nftContract = IERC1155(_nftContract);
    }

    struct NFTMarketItem{
        uint256 tokenId;
        uint256 nftId;
        uint256 amount;
        uint256 price;
        uint256 royalty;
        address payable seller;
        address payable owner;
        bool sold;
    }

    mapping(uint256 => NFTMarketItem) private marketItem;

       
    function listNft(uint256 nftId,uint256 amount, uint256 price, uint256 royalty) external {

        require(nftId > 0, "Token doesnot exist");
        require(royalty >= 0, 'royalty should be between 0 to 30');
        require(royalty < 29, 'royalty should be less than 30');
        
        _tokenIds.increment();
        uint256 tokenId = _tokenIds.current();

        marketItem[tokenId] = NFTMarketItem(
            tokenId,
            nftId,
            amount,
            price,
            royalty,
            payable(msg.sender),
            payable(msg.sender),
            false
        );

        IERC1155(nftContract).safeTransferFrom(msg.sender, address(this), nftId, amount, "");
    }
 
    function buyNFT(uint256 tokenId, uint256 amount) external payable {
         require(
            msg.value == marketItem[tokenId].price,
            "market:Not enough funds sent"
        );
         require(
            msg.sender != marketItem[tokenId].seller,
            "market:Owner can't buy"
        ); 
        payable( marketItem[tokenId].owner).transfer(marketItem[tokenId].price);
        marketItem[tokenId].owner = payable(msg.sender);
        marketItem[tokenId].sold=true;
        _nftSold.increment();
        onERC1155Received(address(this), msg.sender, tokenId, amount, "");
        nftContract.safeTransferFrom(address(this), msg.sender, tokenId, amount, "");
    }

}