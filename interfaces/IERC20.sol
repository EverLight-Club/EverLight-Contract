// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
interface IERC20Basic {
    function totalSupply() external view returns (uint);
    function balanceOf(address who) external view returns (uint);
    function transfer(address to, uint value) external;
    event Transfer(address indexed from, address indexed to, uint value);
}

/**
 * @title IERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
interface IERC20 is IERC20Basic {
    function allowance(address owner, address spender) external view returns (uint);
    function transferFrom(address from, address to, uint value) external;
    function approve(address spender, uint value) external;
    event Approval(address indexed owner, address indexed spender, uint value);
}