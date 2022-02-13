// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract LandFactory {
    // event NewQuestion(string id, address indexed from, uint256 reward);

    uint cooldownTime = 1 days;

    struct Land {
        string content;
        uint32 readyTime;
    }
    
    Land[] public lands;

    constructor() {
        console.log("land on .. !");
    }

    function _createLand() internal returns (uint32) {
      lands.push(Land("", uint32(block.timestamp)));
      uint32 id = uint32(lands.length - 1);
      // emit NewLand(id);
      return id;
    }
}
