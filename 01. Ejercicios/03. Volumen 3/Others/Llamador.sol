// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Llamador {

    event LlamadaExitosa(
        address indexed llamador,
        address indexed receptor,
        uint256 monto
    );

    function llamarYPagar(address payable receptor) external payable {
        require(msg.value > 0, "El valor no puede ser 0");
        // (success, data) = direccionDestino.call{value: <Valor>}(abi.encodeWithSignature(<firma>, <parámetros>));
        (bool success, ) = receptor.call{value: msg.value}("");

        require(success, "La llamada call no ha tenido exito");

        emit LlamadaExitosa(msg.sender, receptor, msg.value);
    }

}