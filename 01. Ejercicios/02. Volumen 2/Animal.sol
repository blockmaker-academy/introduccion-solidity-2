// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Animal {
    string public nombreAnimal;

    constructor(string memory nombreAnimal_) {
        nombreAnimal = nombreAnimal_;
    }

    function comer() public pure returns(string memory) {
        return "comiendo";
    }

    function dormir() public pure returns(string memory) {
        return "durmiendo";
    }
}