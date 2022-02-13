// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract LandFactory {
    event NewQuestion(string id, address indexed from, uint256 reward);

    uint cooldownTime = 1 days;

    struct Land {
        // uint256 id; // Display on web for users to search for questions on the blockchain.
        string content;
        uint32 readyTime; // ref : CryptoZombie
    }

    // mapping(uint32 => Land) public idToLand; // id => Land
    Land[] public lands;

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
        return idToLand[_landId];
    }

    function getContentById(uint32 _landId) public view returns (string memory) {
      return idToLand[_landId].content;
    }

    function getOwnerById(uint32 _landId) public view returns (address) {
      return ownerOf(_landId);
    }

    function writeContent(uint32 _landId, string memory _content) public onlyLandOwner(_landId) returns (string memory) {
      Land storage myLand = idToLand[_landId];
      require(_isReady(myLand), "It's not ready to write");

      myLand.content = _content;

      _triggerCooldown(myLand);

      return myLand.content;
    }
}
