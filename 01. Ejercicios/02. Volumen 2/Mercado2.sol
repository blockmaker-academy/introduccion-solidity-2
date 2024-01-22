// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Mercado2 {
    address public propietario;
    struct Producto {
        uint256 id;
        string nombre;
        uint256 precio;
        uint256 cantidad;
        address vendedor;
    }
    mapping(uint256 => Producto) private _productos;
    uint256 public contadorProductos; // = 3 (1, 2, 3)

    // No hay productos t0: contadorProductos = 0
    // Se registra el 1er producto t1: registroProducto | contadorProductos++ // 1 | Productos(1, xxxx)
    // Se registra el 2o producto t2: registroProducto | contadorProductos++ // 2 | Productos(2, xxxx)

    event ProductoAgregado(
        uint256 id,
        string indexed nombre,
        uint256 indexed precio,
        uint256 cantidad,
        address indexed vendedor
    );
    event ProductoComprado(
        uint256 id,
        string indexed nombre,
        uint256 indexed precio,
        uint256 cantidad,
        address indexed comprador
    );

    modifier soloPropietario() {
        require(msg.sender == propietario, "ERROR: No eres el propietario");
        _;
    }

    modifier productoExistente(uint256 idProducto) {
        require(idProducto > 0 && idProducto <= contadorProductos, "ERROR: El producto no existe");
        _;
    }

    // modifier productoNoExistente(uint256 idProducto) {
    //    require(idProducto <= 0 && idProducto > contadorProductos, "ERROR: El producto existe");
    //    _;
    // }

    constructor() {
        propietario = msg.sender;
        contadorProductos = 0;
    }

    function agregarProducto(
        string memory nombre,
        uint256 precio,
        uint256 cantidad
    ) public {
        // establecer identificador
        contadorProductos++;
        // dar de alta producto
        _productos[contadorProductos] = Producto(
            contadorProductos,
            nombre,
            precio,
            cantidad,
            msg.sender
        );
        // emitir evento
        emit ProductoAgregado(
            contadorProductos,
            nombre,
            precio,
            cantidad,
            msg.sender
        );
    }

    // CONTRATO SUBASTA
    // 1. FUNCIONALIDADES
    // 1.1. PUJAR
    // 1.2. RETIRAR PUJA
    // 1.3. FINALIZAR PUJA
    // 1.4. RETIRAR FONDOS PENDIENTES

    // FUNCIÓN
    // COMPRAR PRODUCTO
    // 1. CABECERA
    // 1.1 PARÁMETROS DE ENTRADA: ID PRODUCTO Y CANTIDAD A COMPRAR => (uint256 idProduct, uint256 cantidadAComprar)
    // 1.2 VISIBILIDAD+MUTABILIDAD+MODIFICADORES: PUBLIC+PAYABLE+PRODUCTOEXISTENTE
    // 2 COMPROBACIONES:
    // 2.1 HAY STOCK SUFICIENTE PARA CUBRIR MI DEMANDA
    // 2.2. ENVÍO SUFICIENTE DINERO PARA COMPRAR
    // 2.3. EL COMPRADOR Y VENDEDOR NO COINCIDEN
    // 3. ACCIONES:
    // 3.1. DISMINUIR EL STOCK
    // 3.2. TRANSFERIR DINERO AL VENDEDOR
    // 3.3. EMITIR EVENTO DE PRODUCTO COMPRADO

    function comprarProducto(
        uint256 idProducto,
        uint256 cantidadComprar
    )
        public
        payable
        productoExistente(idProducto)
    {      
        // variable local que almacena los datos del producto
        Producto storage producto = _productos[idProducto];
        // variable local precio total a pagar
        uint256 precioAPagar = producto.precio * cantidadComprar;

        require(producto.cantidad > 0 && producto.cantidad >= cantidadComprar, "ERROR: No hay existencias del producto");
        require(precioAPagar <= msg.value, "ERROR: Faltan fondos");

        // reducir el stock o cantidad del producto disponible 
        producto.cantidad -= cantidadComprar;

        // transfiero el dinero al vendedor
        address vendedor_ = producto.vendedor;
        payable(vendedor_).transfer(precioAPagar);

        // emito evento
        emit ProductoComprado(
            idProducto,
            producto.nombre,
            producto.precio,
            producto.cantidad,
            producto.vendedor
        ); 
    }

}