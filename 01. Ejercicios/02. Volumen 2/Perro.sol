// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Animal.sol";

contract Perro is Animal {
    address public owner;

    constructor() Animal("Rocky") {
        owner = msg.sender;
    }
}