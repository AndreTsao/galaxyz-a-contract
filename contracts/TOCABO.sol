// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract TOCABO is ERC721A, Ownable, ReentrancyGuard {
    enum Status {
        Waiting,
        WhitelistStarted,
        PublicStarted,
        Finished
    }
    using Strings for uint256;
    Status public status;
    string private baseURI;
    uint256 public MAX_MINT_PER_ADDR = 10;
    uint256 public PUBLIC_PRICE = 0.05 * 10**18;
    uint256 public WHITELIST_PRICE = 0.01 * 10**18;
    uint256 public constant MAX_SUPPLY = 5666;
    bytes32 private _whitelistMerkleRoot;

    event Minted(address minter, uint256 amount);

    constructor(string memory initBaseURI) ERC721A("Tocabo", "TOCABO") {
        baseURI = initBaseURI;
        _safeMint(msg.sender, MAX_MINT_PER_ADDR);
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    function setBaseURI(string calldata newBaseURI) external onlyOwner {
        baseURI = newBaseURI;
    }

    function setWhitelistMerkleRoot(bytes32 merkleRoot_) external onlyOwner {
        _whitelistMerkleRoot = merkleRoot_;
    }

    function setStatus(Status _status) external onlyOwner {
        status = _status;
    }
    
    function whitelistMint(bytes32[] memory merkleProof, uint256 quantity)
        external
        payable
        nonReentrant
    {
        require(status == Status.WhitelistStarted, "Tocabo:Not started yet-");
        require(tx.origin == msg.sender, "Tocabo: Contract call not allowed-");
        require(
            numberMinted(msg.sender) + quantity <= MAX_MINT_PER_ADDR,
            "Tocabo: This is more than allowed"
        );
        require(
            totalSupply() + quantity <= MAX_SUPPLY,
            "Tocabo: Not enough quantity"
        );
        require(
            _whitelistMerkleRoot != "",
            "Tocabo: Merkle tree root is not set-"
        );
        require(
            MerkleProof.verify(
                merkleProof,
                _whitelistMerkleRoot,
                keccak256(abi.encodePacked(msg.sender, quantity))
            ),
            "Tocabo: Merkle tree root validation failed"
        );
        uint256 _cost = WHITELIST_PRICE * quantity;
        require(msg.value >= _cost, "Tocabo: Not enough ETH");
        _safeMint(msg.sender, quantity);
        emit Minted(msg.sender, quantity);
    }

    function pulicMint(uint256 quantity) external payable nonReentrant {
        require(status == Status.PublicStarted, "Tocabo: Not started yet");
        require(tx.origin == msg.sender, "Tocabo: Contract call not allowed");
        require(
            numberMinted(msg.sender) + quantity <= MAX_MINT_PER_ADDR,
            "Tocabo: This is more than allowed"
        );
        require(
            totalSupply() + quantity <= MAX_SUPPLY,
            "Tocabo: Not enough quantity"
        );

        uint256 _cost = PUBLIC_PRICE * quantity;
        require(msg.value >= _cost, "Tocabo: Not enough ETH");
        _safeMint(msg.sender, quantity);
        emit Minted(msg.sender, quantity);
    }

    function numberMinted(address owner) public view returns (uint256) {
        return _numberMinted(owner);
    }

    function withdraw(address payable recipient)
        external
        onlyOwner
        nonReentrant
    {
        uint256 balance = address(this).balance;
        (bool success, ) = recipient.call{value: balance}("");
        require(success, "Tocabo: Withdraw failed");
    }

    function updatePrice(uint256 __price) external onlyOwner {
        PUBLIC_PRICE = __price;
    }

    function updateMaxMint(uint256 __maxmint) external onlyOwner {
        MAX_MINT_PER_ADDR = __maxmint;
    }
}
