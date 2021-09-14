// SPDX-License-Identifier: GPL
pragma solidity ^0.8.0;

interface IERC721Proxy {

  function mintBy(address owner, uint256 tokenId) external;
  function burnBy(uint256 tokenId) external;
  function ownerOf(uint256 tokenId) external view returns (address owner);
}