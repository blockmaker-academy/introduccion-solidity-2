// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RegistroDeEmpleados {
    // Paso 2: Crear variable propietario
    address public propietario;

    // Paso 3: Crear constructor
    constructor() {
        propietario = msg.sender; // msg.sender es la dirección que despliega el contrato
    }

    // Paso 4: Crear struct
    struct Empleado {
        uint idEmpleado; // Identificación del empleado
        string nombre; // Nombre del empleado
        uint salario; // Salario del empleado
    }

    // Paso 5: Crear mapping
    mapping(uint => Empleado) public empleados;

    // Paso 6: Implementar función agregarEmpleado
    function agregarEmpleado(
        uint256 _idEmpleado,
        string memory _nombre,
        uint256 _salario
    ) public {
        require(
            msg.sender == propietario,
            "Solo el propietario puede agregar empleados"
        );
        require(
            empleados[_idEmpleado].idEmpleado == 0,
            "El ID del empleado ya existe"
        );

        empleados[_idEmpleado] = Empleado(_idEmpleado, _nombre, _salario);
    }

    // Paso 7: Implementar función obtenerEmpleado
    function obtenerEmpleado(
        uint _idEmpleado
    ) public view returns (Empleado memory) {
        require(
            empleados[_idEmpleado].idEmpleado != 0,
            "Empleado no encontrado"
        );
        return empleados[_idEmpleado];
    }

    // Paso 8: Implementar función actualizarSalarioEmpleado
    function actualizarSalarioEmpleado(
        uint256 _idEmpleado,
        uint256 _nuevoSalario
    ) public {
        require(
            msg.sender == propietario,
            "Solo el propietario puede actualizar el salario"
        );
        require(
            empleados[_idEmpleado].idEmpleado != 0,
            "Empleado no encontrado"
        );

        empleados[_idEmpleado].salario = _nuevoSalario;
    }

    // Paso 9: Implementar función eliminarEmpleado
    function eliminarEmpleado(uint256 _idEmpleado) public {
        require(
            msg.sender == propietario,
            "Solo el propietario puede eliminar empleados"
        );
        require(
            empleados[_idEmpleado].idEmpleado != 0,
            "Empleado no encontrado"
        );

        delete empleados[_idEmpleado];
    }
}
