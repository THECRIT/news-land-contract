// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./LandMinter.sol";


contract LandPortal is LandMinter {
    // event NewQuestion(string id, address indexed from, uint256 reward);

    constructor() {
        console.log("land on .. !");
    }

    modifier onlyLandOwner(uint32 _landId) {
        require(ownerOf(_landId) == msg.sender, "The user is not an onwer of this land!");
        _;
    }

    function getOwnerById(uint32 _landId) public view returns (address) {
      return ownerOf(_landId);
    }

    function getLatestTokenId() public view returns (uint32) {
    }
}
