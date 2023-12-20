// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract PruebaConstructorStructMapping {
    uint256 public suministroInicialTokens;

    /**
     * STRUCT
     */
    struct Coche {
        string matricula;
        string fechaFabricacion;
    }

    // instanciar struct
    Coche public coche1 = Coche("683958294K", "12/06/2023");

    // acceder a los campos de un struct
    // coche1.matricula;
    // coche1.fechaFabricacion;

    // actualizar los campos de un struct
    // coche1.matricula = "39502043H";

    // mapping => struct => datos

    /**
     * MAPPING
     */
    mapping(address => uint256) saldos;

    // provisionar de valor
    // saldos["0x5353..."] = 50;

    // obtener valor
    // saldos["0x5353..."];

    // eliminar clave-valor
    // delete saldos["0x5353..."];

    constructor(uint256 suministro) {
        suministroInicialTokens = suministro;
    }

    function obtenerSuministro() public view returns (uint256) {
        return suministroInicialTokens;
    }

    function cantidadPar(uint256 cantidad) public pure returns (bool){
        require((cantidad % 2) == 0, "El numero no es par");
        return true;
    }

}