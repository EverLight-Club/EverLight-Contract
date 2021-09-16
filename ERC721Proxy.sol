// SPDX-License-Identifier: MIT
// eyJuYW1lIjoiME4xIC0gTWV0YWRhdGEiLCJkZXNjcmlwdGlvbiI6IlRoaXMgc2hvdWxkIE5PVCBiZSByZXZlYWxlZCBiZWZvcmUgYWxsIGFyZSBzb2xkLiBJbWFnZXMgY29udGFpbmVkIGJlbG93IiwiaW1hZ2VzIjoiMHg1MTZENTU0ODYxMzQ0QTc3NEI1MDY3NjY0ODcxNDM1ODMxNTQ3ODMyNTc2OTRBNTg2NDYzNEM2MzY1NTM3NDZGNTEzNjY1Nzg1NTU4Mzg1NDRBNkE0NjYxNjE1MSJ9
pragma solidity ^0.8.0;

import './ERC721Enumerable.sol';
import './Ownable.sol';
import './utils/Strings.sol';
import "./utils/Base64.sol";
import "./interfaces/IEverLight.sol";

contract ERC721Proxy is ERC721Enumerable, Ownable {
  using Strings for uint256;

  IEverLight public everLightContract;                    

  string private _contractURI = '';
  string private _tokenBaseURI = '';

  modifier onlyEverLight() {
    require(address(everLightContract) == _msgSender(), "caller is not the everLight");
    _;
  }
 
  constructor(string memory name, string memory symbol) ERC721(name, symbol) {

  }

  function mintBy(address owner, uint256 tokenId) external onlyEverLight {
    require(!_exists(tokenId), 'tokenId exist already');
     _safeMint(owner, tokenId);
  }

  function burnBy(uint256 tokenId) external onlyEverLight {
    require(_exists(tokenId), 'tokenId not exist');
     _burn(tokenId);
  }

  function withdraw() external onlyOwner {
    uint256 balance = address(this).balance;

    payable(msg.sender).transfer(balance);
  }

  function setEverLightContract(address _everLightContract) external onlyOwner {
    require(_everLightContract != address(0), "addr invalid");
    everLightContract = IEverLight(_everLightContract);
  }

  function setContractURI(string calldata URI) external onlyOwner {
    _contractURI = URI;
  }

  function setBaseURI(string calldata URI) external onlyOwner {
    _tokenBaseURI = URI;
  }

  function contractURI() public view returns (string memory) {
    return _contractURI;
  }

  function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory output) {
    require(_exists(tokenId), 'Token does not exist');
    uint8 tokenType = everLightContract.queryTokenType(tokenId);
    if(tokenType == 1){ // for charactor
      output = tokenURIForCharacter(tokenId);
    }
    if(tokenType == 2){ // for parts
      output = tokenURIForParts(tokenId);
    }
    if(tokenType == 3){ // for luckyStone
      // ....
      output = tokenURIForParts(tokenId);
    }
    //
    string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Bag #', tokenId.toString(), '", "description": "EverLight description.", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
    output = string(abi.encodePacked('data:application/json;base64,', json));
    return output;
  }

  function tokenURIForCharacter(uint256 tokenId) internal view returns (string memory) {
    
    (, uint32 powerFactor, uint256[] memory tokenList, uint32 totalPower) = everLightContract.queryCharacter(tokenId);
    string[] memory parts = new string[](2 * tokenList.length + 3);
    parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; } </style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="base">';
    
    uint256 index = 1;
    uint256 yValue = 20;
    for(uint i = 0; i < tokenList.length; i++) {
      yValue = yValue + 20;
      parts[index] = pluck(tokenList[i], uint8(i));
      index = index + 1;
      parts[index] = string(abi.encodePacked('</text><text x="10" y="',yValue.toString(),'" class="base">')); // '</text><text x="10" y="40" class="base">';
      index++;
    }
    parts[index] = string(abi.encodePacked("totalPower:[", uint256(totalPower).toString(), "]"));
    index = index + 1;
    parts[index] = '</text></svg>';

    string memory output = "";
    uint n = 0;
    while(n < parts.length){  // 5
      if(n % 2 == 0){ // 0, 2, 4, 6, 8
        output = string(abi.encodePacked(output, parts[n], parts[n+1]));
      }
      n = n + 2;
      if(n == (parts.length - 1)){
        output = string(abi.encodePacked(output, parts[n]));
        break;
      }
      if(n >= parts.length){
        break;
      } 
    }
    return output;
  }

  function tokenURIForParts(uint256 tokenId) internal view returns (string memory) {
    string[3] memory parts;
    parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; } </style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="base">';
    parts[1] = pluck(tokenId, 0);
    parts[2] = '</text></svg>';
  
    return string(abi.encodePacked(parts[0], parts[1], parts[2]));
  }

  function pluck(uint256 tokenId, uint8 position) internal view returns (string memory output) {
    LibEverLight.TokenInfo memory tokenInfo = everLightContract.queryToken(tokenId);
    if(tokenInfo._tokenId == 0){
      output = string(abi.encodePacked(uint256(position).toString(), ":?"));
      return output;
    }
    if(tokenInfo._position == 99){
      output = string(abi.encodePacked(uint256(tokenInfo._position).toString(), ":", tokenInfo._name));
      return output;
    }
    if(tokenInfo._createFlag) {
      output = string(abi.encodePacked(uint256(tokenInfo._position).toString(), ":", tokenInfo._name, "(+", uint256(tokenInfo._level).toString(), "E)[", uint256(tokenInfo._power).toString(), "]"));
    } else {
      output = string(abi.encodePacked(uint256(tokenInfo._position).toString(), ":", tokenInfo._name, "(+", uint256(tokenInfo._level).toString(), ")[", uint256(tokenInfo._power).toString(), "]"));
    }
    
    string memory color = everLightContract.queryColorByRare(tokenInfo._rare);
    if(bytes(color).length > 0) {
      output = string(abi.encodePacked('<a style="fill:', color, ';">', output, '</a>'));
    }
    return output;
  }

}