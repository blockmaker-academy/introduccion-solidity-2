// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Subasta {
    // VARIABLES DE ESTADO/GLOBALES
    // Gestor del contrato inteligente
    address public administrador;

    // Vendedor que obtendrá el monto final de la subasta
    address payable public beneficiario;

    // Marca de tiempo en la que terminará la subasta (e.g., 12/09/2024, 08:15:45)
    uint256 public finSubasta;

    // Ganador actual de la subasta
    address public mejorPostor;
    // Puja máxima actual de la subasta
    uint256 public mejorOferta;

    // Almacena los address y la cantidad que les debemos a los mismos
    mapping(address => uint256) devolucionesPendientes; // "0x5253" = 50;
    
    // Variable que almacena 'true' en caso de que la subasta haya finalizado
    bool public finalizada;

    // EVENTOS
    event OfertaMasAltaIncrementada(address indexed postor, uint256 cantidad);
    event SubastaFinalizada(address ganador, uint256 cantidad);

    // ERRORES
    // La subasta ya ha finalizado.
    error SubastaYaFinalizada();
    // Ya existe una oferta igual o superior.
    error OfertaNoSuficientementeAlta(uint256 mejorOferta);
    // La subasta aún no ha finalizado.
    error SubastaNoFinalizadaTodavia();
    // La función auctionEnd ya ha sido llamada.
    error FinSubastaYaLlamado();

    // MODIFIERS
    modifier soloAdministrador() {
        require(msg.sender == administrador, "ERROR: No tienes permisos de administrador");
        _;
    }

    constructor(uint256 tiempoOferta, address payable beneficiario_) {
        administrador = msg.sender;
        beneficiario = beneficiario_;
        // 5 days * 24 horas * 60 minutos * 60 segundos = xxxx segundos
        finSubasta = block.timestamp + tiempoOferta;
    }

    function ofertar() public payable {
        if(block.timestamp >= finSubasta) {
            revert SubastaYaFinalizada();
        }

        if(msg.value <= mejorOferta) {
           revert OfertaNoSuficientementeAlta(mejorOferta); 
        }

        if(mejorOferta != 0) {
            devolucionesPendientes[mejorPostor] += mejorOferta;
        }

        mejorPostor = msg.sender;
        mejorOferta = msg.value;

        emit OfertaMasAltaIncrementada(mejorPostor, mejorOferta);
    }

    function retirar() public returns(bool) {
        // Comprobamos si el emisor tiene cantidad pendiente de retirar
        uint256 cantidadADevolver = devolucionesPendientes[msg.sender];
        if(cantidadADevolver > 0) {
            // ENVIAMOS EL ETHER PENDIENTE
            // Si falla el envío de ether
            if(payable(msg.sender).send(cantidadADevolver) == false) {
                return false;
            }
            // Si no falla el envío de ether
            devolucionesPendientes[msg.sender] = 0;
            return true;
        }
        return false;
    }

    function finalizarSubasta() public soloAdministrador {
        // Comprobamos si el tiempo límite de la subasta se ha sobrepasado o es igual
        if(block.timestamp < finSubasta) {
            // error
            revert SubastaNoFinalizadaTodavia();
        }

        if(finalizada == true) {
            // error
            revert FinSubastaYaLlamado();
        }

        // comprobaciones realizadas
        // enviar los fondos al beneficiario (transfer)
        beneficiario.transfer(mejorOferta);
        finalizada = true;

        // emitir evento
        emit SubastaFinalizada(mejorPostor, mejorOferta);
    }

    // TO-DO: function retirarOferta
    
}