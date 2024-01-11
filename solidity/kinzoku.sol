// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IOwnableNft {
    function ownerOf(uint256 tokenId) external view returns (address);
}

contract Kinzoku {
    address private owner;
    IOwnableNft public nftAddress;
    uint256 public constant MAX_NFT_ID = 99;

    struct Row {
        address requester;
        string addresshash;
        bool confirmed;
    }

    Row[MAX_NFT_ID] public rows;

    event RowSet(
        uint256 indexed nft_id,
        address requester,
        string addresshash,
        bool confirmed
    );
    event RowAdded(
        uint256 indexed nft_id,
        address requester,
        string addresshash
    );

    constructor() {
        owner = 0xB9b8EF61b7851276B0239757A039d54a23804CBb;
        nftAddress = IOwnableNft(0x011ff409BC4803eC5cFaB41c3Fd1db99fD05c004);
        for (uint i = 0; i < MAX_NFT_ID; i++) {
            rows[i] = Row(address(0), "", false);
        }
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "ERR_NOT_OWNER");
        _;
    }

    modifier onlyTokenOwner(uint256 tokenId) {
        require(
            msg.sender == nftAddress.ownerOf(tokenId),
            "ERR_NOT_TOKEN_OWNER"
        );
        _;
    }

    modifier validNFTId(uint256 nft_id) {
        require(nft_id > 0 && nft_id <= MAX_NFT_ID, "ERR_INVALID_NFT_ID");
        _;
    }

    function setRow(
        uint256 nft_id,
        address requester,
        string memory addresshash,
        bool confirmed
    ) public onlyOwner validNFTId(nft_id) {
        rows[nft_id - 1] = Row(requester, addresshash, confirmed);
        emit RowSet(nft_id, requester, addresshash, confirmed);
    }

    function addRow(
        uint256 nft_id,
        string memory addresshash
    ) public onlyTokenOwner(nft_id) validNFTId(nft_id) {
        require(!rows[nft_id - 1].confirmed, "ERR_ROW_CONFIRMED");
        rows[nft_id - 1] = Row(msg.sender, addresshash, false);
        emit RowAdded(nft_id, msg.sender, addresshash);
    }

    function getFounderOwners() public view returns (address[] memory) {
        address[] memory owners = new address[](99);
        for (uint i = 1; i <= 99; i++) {
            if (i == 67 || i == 87 || i == 92) {
                owners[i - 1] = address(0);
            } else {
                owners[i - 1] = nftAddress.ownerOf(i);
            }
        }
        return owners;
    }

    function getAllRows() public view returns (Row[MAX_NFT_ID] memory) {
        Row[MAX_NFT_ID] memory rowsCopy;
        for (uint i = 0; i < MAX_NFT_ID; i++) {
            rowsCopy[i] = rows[i];
        }
        return rowsCopy;
    }
}
