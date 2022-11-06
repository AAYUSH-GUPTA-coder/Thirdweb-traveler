// SPDX-License-Identifier: MIT

/** @author Aayush gupta
 * `TravelQuest` is a POV (Proof-of-visit) dapp that allow user to mint 1 NFT per collection
 * using `ERC1155LazyMint` library of `ThirdWeb`.
 */
pragma solidity ^0.8.0;


/**
 * Importing `ERC1155LazyMint` library of `ThirdWeb`.
 */
import "@thirdweb-dev/contracts/base/ERC1155LazyMint.sol";

/**
 * @title TravelQuest
 * @dev inherite and using `ERC1155LazyMint` in the our smart contract
 *  
 */
contract TravelQuest is ERC1155LazyMint{ 
    // Total number NFTs per Bundle Collection
    uint256[] private supplies = [50,50];
    // Total number of NFTs minted
    uint256[] private minted = [0,0];

    // nested mapping to check user can mint only one NFT per NFT Collection
    mapping(uint256 => mapping(address => bool)) public member;

    /**
     * @dev ERC1155LazyMint library takes four Parameters
     * _name of the NFT, _symbol of the NFT,
     *  _royaltyRecipient (address) who will get royalty on secondary sale, _royaltyBps (royality percentage)
     * we don't need to set Royality for the purpose of our smart contract. setting _royaltyBps to Zero
     * @param _name: name of the whole NFT bundle Collection
     * @param _symbol: symbol of the whole NFT bundle Collection
     */
    constructor(
        string memory _name,
        string memory _symbol
    ) ERC1155LazyMint (_name, _symbol, msg.sender, 0){}


    /**
     * @dev Mint NFT and also check various conditions
     * 1. One user can mint only one NFT per Bundle Collection
     * 2. Give error if _tokenId is wrong
     * 3. Check and give error if all the NFTs are Minted
     * 
     * @param _tokenId: tokenId of the NFT Bundle collection 
     */
    function mintNFT(uint256 _tokenId) 
        external
        {
         require(
            !member[_tokenId][msg.sender],
            "You have already claimed this NFT."
        );    
        require(_tokenId <= supplies.length-1,"NFT does not exist");
        uint256 index = _tokenId;

        require (minted[index] + 1 <= supplies[index], "All the NFT have been minted");
        _mint(msg.sender, _tokenId, 1, "");
        // "" is data which is set empty
        minted[index] += 1;
        member[_tokenId][msg.sender] = true;
    }

    /**
     * @dev Give the total number of NFTs minted per NFT Bundle Collection
     * @param _tokenId: tokenId of the NFT Bundle collection 
     */
    function totalNftMinted(uint256 _tokenId) public view returns(uint256){
        return minted[_tokenId];
    }
}
