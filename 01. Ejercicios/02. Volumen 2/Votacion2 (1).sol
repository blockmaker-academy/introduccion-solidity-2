// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Votacion2 {
    address public administrador;

    struct Votante {
        uint256 peso; // cantidad de votos: 1
        bool votado; // si he votado o no: true/false
        address delegado; // si delego en otra persona: address
        uint256 voto; // identificador del candidato: 1
    }

    struct Propuesta {
        string nombre; // cantidato o propuesta a votar: "Feijó"
        uint256 cantidadVotos; // nº de votos que tiene el candito: 2
    }

    mapping(address => Votante) public votantes; // 0x2495823 (Borja) => Votante(1, true, "", 1)

    Propuesta[] public propuestas; // propuestas[1] => Propuesta("Feijó", 2);
    
    event DerechoVotoOtorgado(address indexed votante);
    event VotoDelegado(address indexed remitente, address indexed delegado);
    event VotoEmitido(address indexed votante, uint256 indexed propuesta);

    modifier soloAdministrador() {
        require(msg.sender == administrador, "Solo el administrador puede acceder"); 
        _;
    }

    constructor(string[] memory nombrePropuestas) {
        administrador = msg.sender;
        // recorrer nombrePropuestas => arrays comienzan por 0 => 
        for(uint256 i=0; i < nombrePropuestas.length; i++) { // i=0 => i=1 => i=2 (longitud 3)
            // Opción 1
            // Propuesta memory propuestaAlRecorrer = Propuesta(nombrePropuestas[i], 0);
            // propuestas.push(propuestaAlRecorrer);

            // Opción 2
            propuestas.push(
                Propuesta(
                  nombrePropuestas[i],
                  0
                )  
            );
        }
        // nombrePropuestas.length = 3
        //  i:         0         1           2
        // Paso 1: ["Feijó", "Pedro S.", "Abascal"]
        // Paso 2: Recorrer esos nombres y crear propuestas => Propuesta("Feijó", 0), Propuesta("Pedro S.", 0)...
        // Paso 3: Almacenar dichas propuestas => propuestas[Propuesta, Propuesta, Propuesta]
    }

    function darDerechoAVotar(address votante_) public soloAdministrador {
        require(votantes[votante_].votado == false, "El usuario ya ha votado");
        // require(!votantes[votante_].votado, "El usuario ya ha votado");
        require(votantes[votante_].peso == 0, "El usuario ya tiene permiso para votar");
        // le doy peso al votante para ejercer su derecho a voto
        votantes[votante_].peso = 1;

        emit DerechoVotoOtorgado(votante_);
    }

    function delegar(address receptor) public {
        require(votantes[msg.sender].peso > 0, "El usuario no puede votar");
        require(votantes[msg.sender].votado == false, "El usuario ya ha votado");
        require(msg.sender != receptor, "El usuario no puede delegar en si mismo");

        // bucle while
        // delegado del receptor(0x34958) = 0x49582 |  delegado de 0x49582 = 0x95823 | delegado de 0x95823 = 0 => le transmito mi peso

    }

}