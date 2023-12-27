// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CowboyHead is ERC721, Ownable {

    // price to mint a CowboyHead NFT
    uint256 public mintPrice;

    // current total supply of CowboyHead NFTs already minted
    uint256 public totalSupply;

    // maximum supply of CowboyHead NFTs that can ever be minted
    uint256 public maxSupply;

    // list of minters
    address [] public cowboys;

    // keep track of the number of mints each wallet has done
        // this is smarter than checking balance as a wallet can mint,
        // and then transfer the NFT out of the wallet, thus exploiting the smart contract
    mapping(address => uint256) public mintedWallets;

    constructor(address initialOwner)
        payable
        ERC721("CowboyHead", "CBH")
        Ownable(initialOwner)
    {
        // initialize maxSupply to 5 
        maxSupply = 5;

        // initialize mintPrice to 0.01e18;
        mintPrice = 0.01e18;
    }

    function setMintPrice(uint256 mintPrice_) external onlyOwner {
        mintPrice = mintPrice_;
    }

    function setMaxSupply(uint256 maxSupply_) external onlyOwner {
        maxSupply = maxSupply_;
    }

    function mint() payable external {
        require(mintedWallets[msg.sender] < 1, "Max CowboyHead NFT mint per wallet exceeded!");
        require(msg.value == mintPrice, "Input accurate price of one CowboyHead NFT!");
        require(totalSupply < maxSupply, "All CowboyHead NFTs have been minted!");

        mintedWallets[msg.sender]++;
        cowboys.push(msg.sender);
        totalSupply++;
        uint256 tokenId = totalSupply;
        _safeMint(msg.sender, tokenId);
    }

    function getAllCowboys() external view onlyOwner returns(address[] memory) {
        return cowboys;
    }

    function withdraw() external onlyOwner {
        for(uint256 minterIndex = 0; minterIndex < cowboys.length; minterIndex++) {
            address minter = cowboys[minterIndex];
            mintedWallets[minter] = 0;
        }
        cowboys = new address[](0);
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed!");
    }

}
