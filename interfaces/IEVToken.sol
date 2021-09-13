// SPDX-License-Identifier: GPL
pragma solidity ^0.8.0;

import './IERC20.sol';

interface IEVToken is IERC20 { 

  function rules() external view returns (string memory rules);

  function stake(uint256 tokenId) external;

  function redeem(uint256 tokenId) external;
}
