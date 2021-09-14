// SPDX-License-Identifier: GPL
pragma solidity ^0.8.0;

import './LibEverLight.sol';

interface IEverLight {
  // event list
  event NewTokenType(address indexed creator, uint8 position, uint8 rare, string indexed name, uint256 suitId);

  // read function list
  function queryColorByRare(uint8 rare) external view returns (string memory color);

  function queryAccount(address owner) external view returns (LibEverLight.Account memory account);

  // returns the type for tokenId(1 charactor, 2 parts, 3 lucklyStone)
  function queryTokenType(uint256 tokenId) external view returns (uint8 tokenType);
  
  function queryCharacter(uint256 characterId) external view returns (address owner, uint32 powerFactor, uint256[] memory tokenList, uint32 totalPower);

  function queryToken(uint256 tokenId) external view returns (LibEverLight.TokenInfo memory tokenInfo);

  function queryCharacterCount() external view returns (uint32 num);

  function queryLuckyStonePrice() external view returns (uint32 price);

  function queryMapInfo() external view returns (address[] memory addresses);

  function querySuitOwner(uint32 suitId) external view returns (address owner);

  function isNameExist(string memory name) external view returns (bool result);

  function queryCharacterExtra(uint256 characterId, uint256 extraKey) external view returns (string memory);

  // write function list
  function setCharacterExtra(uint256 characterId, uint256 extraKey, string memory extraValue) external;

  function mint() external payable;

  function wear(uint256 characterId, uint256[] memory tokenList) external;

  function takeOff(uint256 characterId, uint8[] memory positions) external;

  function upgradeToken(uint256 firstTokenId, uint256 secondTokenId) external;

  function upgradeWearToken(uint256 characterId, uint256 tokenId) external;

  function exchangeToken(uint32 mapId, uint256[] memory mapTokenList) external;

  function buyLuckyStone(uint8 count) external;

  function useLuckyStone(uint256[] memory tokenId) external;

  function newTokenType(uint256 tokenId, string memory name, uint32 suitId) external;
}
