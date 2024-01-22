// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BancoDescentralizado2 {
    address private _propietario;
    mapping(address => uint256) private _saldos; // _saldos[0x53...] => 50 wei

    constructor() {
        _propietario = msg.sender;
    }

    function depositar() public payable {
        require(msg.value > 0, "ERROR: No hay fondos a depositar");
        _saldos[msg.sender] += msg.value;
    }

    function retirar(uint256 cantidad) public {
        require(_saldos[msg.sender] >= cantidad, "ERROR: El saldo es insuficiente");

        // Opción 1
        payable(msg.sender).transfer(cantidad);

        // Opción 2
        // require(payable(msg.sender).send(cantidad), "ERROR: Al enviar la cantidad establecida");

        // actualizar saldo
        _saldos[msg.sender] -= cantidad;
    }

    function obtenerSaldo() public view returns(uint256) {
        return _saldos[msg.sender];
    }

    //  Opción 2
    // function obtenerSaldo() public view returns(uint256 saldoDelUsuario) {
    //    saldoDelUsuario = _saldos[msg.sender];
    // }

}