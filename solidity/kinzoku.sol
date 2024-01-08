// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IOwnableNft {
    function ownerOf(uint256 tokenId) external view returns (address);
}

contract GetFounderOwners {
    IOwnableNft public nftAddress;

    constructor() {
        nftAddress = IOwnableNft(0x011ff409BC4803eC5cFaB41c3Fd1db99fD05c004);
    }

    function getFounderOwners() public view returns (address[] memory) {
        address[] memory owners = new address[](99);
        for (uint i = 1; i <= 99; i++) {
            if (i == 67 || i == 87 || i == 92) {
                owners[i-1] = address(0);
            } else {
                owners[i-1] = nftAddress.ownerOf(i);
            }
        }
        return owners;
    }
}