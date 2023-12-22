// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CompraRemota {
    uint256 public valor;
    address payable public vendedor;
    address payable public comprador;

    enum Estado { 
        Creado, 
        EnCurso, 
        Recibido, 
        Inactivo
    }
    Estado public estado;

    event Abortado();
    event CompraConfirmada();
    event ArticuloRecibido();
    event VendedorReembolsado();

    error SoloComprador();
    error SoloVendedor();
    error EstadoInvalido();
    error ValorNoPar();

    // prefijo (_x) => variables/functiones internal & private
    // sufijo (x_) => colisión de nombres (variables, funciones, modifier, etc.)
    modifier condicion(bool condicion_) {
        require(condicion_, "ERROR: La condicion no se cumple");
        _;
    }

    modifier soloComprador() {
        if(msg.sender != comprador) {
            revert SoloComprador();
        }
        _;
    }

    modifier soloVendedor() {
        if(msg.sender != vendedor) {
            revert SoloVendedor();
        }
        _;
    }

    modifier enEstado(Estado estado_) {
        // require(estado_ == estado, "ERROR: EstadoInvalido");
        if(estado_ != estado) {
            revert EstadoInvalido();
        }
        _;
    }

    // Valor introducido (ether) debe ser par
    constructor() payable {
        vendedor = payable(msg.sender);
        // Señor Patata = 50 ether => msg.value = 100 ether (depósito)
        valor = msg.value / 2;
        if ( (valor * 2) != msg.value) {
            revert ValorNoPar();
        }
        estado = Estado.Creado;
    }

    function abortarVenta()
        public
        soloVendedor
        enEstado(Estado.Creado)
    {
        emit Abortado();
        estado = Estado.Inactivo;
        // vendedor.transfer(address(this).balance);
        vendedor.transfer(valor * 2);
    }

    function confirmarCompra()
        public
        payable
        enEstado(Estado.Creado)
        condicion(msg.value == (2 * valor))
    {
        emit CompraConfirmada();
        comprador = payable(msg.sender);
        estado = Estado.EnCurso;
    }

    function confirmarRecibido()
        public
        soloComprador
        enEstado(Estado.EnCurso)
    {
        emit ArticuloRecibido();
        estado = Estado.Recibido;
        comprador.transfer(valor);
    }

    function retirarFondosVendedor()
        public
        soloVendedor
        enEstado(Estado.Recibido)
    {
        emit VendedorReembolsado();
        estado = Estado.Inactivo;
        // he depositado el doble del valor del artículo
        // he vendido el artículo
        vendedor.transfer(valor * 3);
    }

}