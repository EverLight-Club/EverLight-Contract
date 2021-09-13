// SPDX-License-Identifier: GPL
pragma solidity ^0.8.0;

interface IEVGover {

  function propose(uint256 proposeId) external;

  function vote(uint256 proposeId) external;

  function decide(uint256 proposeId) external;
}