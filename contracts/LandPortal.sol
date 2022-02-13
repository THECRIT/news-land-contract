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

    function _triggerCooldown(Land storage _land) internal {
      _land.readyTime = uint32(block.timestamp + cooldownTime);
    }

    function _isReady(Land storage _land) internal view returns (bool) {
      return (_land.readyTime <= block.timestamp);
    }

    function getLandById(uint32 _landId) public view returns (Land memory) {
        return lands[_landId];
    }

    function getContentById(uint32 _landId) public view returns (string memory) {
      return lands[_landId].content;
    }

    function getOwnerById(uint32 _landId) public view returns (address) {
      return ownerOf(_landId);
    }

// logics
    function writeContent(uint32 _landId, string memory _content) public onlyLandOwner(_landId) returns (string memory) {
      Land storage myLand = lands[_landId];
      require(_isReady(myLand), "It's not ready to write! It is decided by DAO to write an article once a day.");

      myLand.content = _content;

      _triggerCooldown(myLand);

      return myLand.content;
    }
}
