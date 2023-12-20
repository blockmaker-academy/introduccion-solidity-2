// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BancoSimple {

    function depositar() public payable {
        require(msg.value > 0, "ERROR: No has enviado suficientes fondos");
    }

    function retirar(uint256 cantidadARetirar) public {
        payable(msg.sender).transfer(cantidadARetirar);
    }

}