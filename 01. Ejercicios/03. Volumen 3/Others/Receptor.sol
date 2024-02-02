// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import "./OperacionesMatematicas4.sol";
import {OperacionesMatematicas} from "./OperacionesMatematicas4.sol";

contract Receptor {
    address public propietario;
    mapping(address => bool) public administradores;

    event FondosRecibidos(address indexed remitente, uint256 monto);

    modifier soloPropietario() {
        require(msg.sender == propietario, "Error: no eres el propietario");
        _;
    }

    modifier soloAdmin() {
        require(administradores[msg.sender], "Error: no tiene permisos de administrador");
        _;
    }

    constructor() {
        propietario = msg.sender;
        administradores[msg.sender] = true;
    }

    receive() external payable {
        emit FondosRecibidos(msg.sender, msg.value);
    }

    function agregarAdmin(address nuevoAdministrador) external soloPropietario {
        require(nuevoAdministrador != address(0), "Error: el address 0 no esta permitido");
        require(!administradores[nuevoAdministrador], "Error: el administrador ya esta dado de alta");
        administradores[nuevoAdministrador] = true;
    }

    function retirar() external soloPropietario {
        // Con transfer
        payable(propietario).transfer(address(this).balance);
    }

    function sumarDiez(uint256 valor) external pure returns (uint256 resultado) {
        resultado = OperacionesMatematicas.suma(valor, 10);
        // resultado es par ¿?
        assert(resultado % 2 == 0);
        return resultado;
    }

}