// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Receptor.sol";

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

    // string[] nombres = ["Mati", "María", "José"];
    // uint256[] numeros = [1, 2, 3, 4];
    // bool[] respuestasTest = [true, false, false, true, false];
    // Propuestas[] propus = [Propuesta("Candidato1", 0), Propuesta("Candidato2", 5)];
    Propuesta[] public propuestas; // propuestas[1] => Propuesta("Feijó", 2);
    
    event DerechoVotoOtorgado(address indexed votante);
    event VotoDelegado(address indexed remitente, address indexed delegado);
    event VotoEmitido(address indexed votante, uint256 indexed propuesta);

    modifier soloAdministrador() {
        require(msg.sender == administrador, "Solo el administrador puede acceder"); 
        _;
    }
    // ["C1", "C2", "C3"] => [Propuesta("C1", 0), Propuesta("C2", 0), Propuesta("C3", 0)]
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
        // 1. Bloque 1: Comprobar si podemos delegar
        require(votantes[msg.sender].peso > 0, "El usuario no puede votar");
        require(votantes[msg.sender].votado == false, "El usuario ya ha votado");
        require(msg.sender != receptor, "El usuario no puede delegar en si mismo");

        // 2. Bloque 2: Comprobar si el receptor de la delegación ha delegado en otra persona 
        // con el objetivo de conocer el receptor final
        while(votantes[receptor].delegado != address(0)) {
            receptor = votantes[receptor].delegado;
            require(receptor != msg.sender, "No pueden existir bucles hacia el emisor");
        }

        // 3. Bloque 3: Comprobar si el receptor tiene derecho a voto
        require(votantes[receptor].peso >= 1, "El receptor no tiene derecho a voto");

        votantes[msg.sender].votado = true;
        votantes[msg.sender].delegado = receptor;
        
        // 4. Bloque 4: Comprobar si el receptor a votado o no
        if(votantes[receptor].votado) {
            uint256 indiceCandidatoVotado = votantes[receptor].voto;
            propuestas[indiceCandidatoVotado].cantidadVotos += votantes[msg.sender].peso;
        } else {
            votantes[receptor].peso += votantes[msg.sender].peso;
        }

        votantes[msg.sender].peso = 0;

        emit VotoDelegado(msg.sender, receptor);
    }
    
    function votar(uint256 indiceCandidato) public {
        // 1. Bloque: Comprobamos que el emisor pueda votar
        require(votantes[msg.sender].peso > 0, "No tenemos votos disponibles");
        require(!votantes[msg.sender].votado, "No tenemos votos disponibles");

        votantes[msg.sender].votado = true;
        votantes[msg.sender].voto = indiceCandidato;

        // 2. Bloque: Mandamos nuestros votos al candidato elegido
        propuestas[indiceCandidato].cantidadVotos += votantes[msg.sender].peso;

        votantes[msg.sender].peso = 0;

        emit VotoEmitido(msg.sender, indiceCandidato);
    }

    function nombreGanador() public view returns(string memory) {
        // uint256 indiceGanador = _propuestaGanadora();
        // return propuestas[indiceGanador].nombre;
        return propuestas[_propuestaGanadora()].nombre;
    }

    function devolverStruct() public view returns(Propuesta memory) {
        return propuestas[0]; // nombre + cantidadVotos
    }

    function _propuestaGanadora() private view returns(uint256) {
        // cantidadVotosGanador = 0; // 5000 cantidadVotos >= cantidadVotosGanador
        // indiceCandidatoGanador;
        uint256 cantidadVotosGanadores = 0;
        uint256 indicePropuestaGanadora = 0;
        for(uint256 i=0; i < propuestas.length; i++) {
            // i=0 // i=1 // i=2
            // propuestas[i];
            if(propuestas[i].cantidadVotos > cantidadVotosGanadores) {
                cantidadVotosGanadores = propuestas[i].cantidadVotos;
                indicePropuestaGanadora = i;
            }
        }
        return indicePropuestaGanadora; // 0, 1, 2, 3, 4
    }
}