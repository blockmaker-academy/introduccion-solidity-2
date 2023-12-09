// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RegistroDeEmpleadosBM {

    address public propietario;

    struct Empleado {
        uint256 idEmpleado;
        string nombre;
        uint256 salario;
    }
    // Empleado(35, "AR", 25000)

    mapping(uint256 => Empleado) public empleados;
    // 45 => Empleado(0, "", 0)
    // 35 => Empleado(35, "AR", 25000)
    // empleados[35]; // Empleado(35, "AR", 25000)
    // empleados[35].idEmpleado; // 35

    constructor() {
        propietario = msg.sender;
    }

    function agregarEmpleado(
        uint256 _idEmpleado,
        string memory _nombre,
        uint256 _salario
    ) public {
        // comprobar que el emisor es el propietario
        require(propietario == msg.sender, "Error: no eres el propietario");
        // 2a condición
        require(empleados[_idEmpleado].idEmpleado == 0, "Error: el empleado ya existe");
        // Agregar nuevo empleado al mapping
        empleados[_idEmpleado] = Empleado(
            _idEmpleado,
            _nombre,
            _salario
        );
    }

    function obtenerEmpleado(uint256 _idEmpleado) public view returns(
        uint256,
        string memory,
        uint256
    ){
        // Condición: Comprobar si el empleado existe
        // TO-DO

        // 1a opción: devolver datos del empleado
        // Empleado memory elEmpleado = empleados[_idEmpleado]; // Empleado(35, "AR", 25000)
        //return (elEmpleado.idEmpleado, elEmpleado.nombre, elEmpleado.salario);
        
        // 2a opción: devolver datos del empleado
        return(
            empleados[_idEmpleado].idEmpleado,
            empleados[_idEmpleado].nombre,
            empleados[_idEmpleado].salario
        );
    }

}