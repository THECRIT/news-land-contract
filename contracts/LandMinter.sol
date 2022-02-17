pragma solidity ^0.8.0;


import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

// We need to import the helper functions from the contract that we copy/pasted.
import { Base64 } from "./libraries/Base64.sol";

// When we need ERC721Enumerable, go import it.
contract LandMinter is ERC721URIStorage, ERC2981, Ownable {
  string public contractURI;
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

  // todo: 2 necessary args => add to deploy.js (Refer to ERC 2981 page on notion)
  constructor(uint96 _royaltyFeesInBips, string memory _contractURI) ERC721 ("NewsLand", "NLD") {
    setRoyaltyInfo(owner(), _royaltyFeesInBips);
    contractURI = _contractURI;
  }

// ERC2981
  function setRoyaltyInfo(address _receiver, uint96 _royaltyFeesInBips) public onlyOwner {
        _setDefaultRoyalty(_receiver, _royaltyFeesInBips);
  }
    // Figure out how to make contractURI which is a type of base 64
  function setContractURI(string calldata _contractURI) public onlyOwner {
        contractURI = _contractURI;
  }


// ERC721 minting 
  function mint() public {
    _mintNewsLand();
  }

  function batchMint(uint96 numberOfTimes) public {
    for (uint96 i; i < numberOfTimes; i++) {
      mint();
    }
  }

  function _mintNewsLand() internal {
    uint256 newItemId = _tokenIds.current();

    require(newItemId < 900, "Tokens are sold out!");

    string memory finalSvg = string(abi.encodePacked(baseSvg, "Land", newItemId, "</text></svg>"));

    // Get all the JSON metadata in place and base64 encode it.
    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "Land',
                    // We set the title of our NFT as the generated word.
                    newItemId,
                    '", "description": "The first decentralized newspaper with priceless lands", "image": "data:image/svg+xml;base64,',
                    // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                    Base64.encode(bytes(finalSvg)),
                    '"}'
                )
            )
        )
    );

    // Just like before, we prepend data:application/json;base64, to our data.
    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );

    _safeMint(msg.sender, newItemId);
    
    // Update your URI!!!
    _setTokenURI(newItemId, finalTokenUri);
    
    _tokenIds.increment();
    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
  }

  // The following functions are overrides required by Solidity.

  function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC2981)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}