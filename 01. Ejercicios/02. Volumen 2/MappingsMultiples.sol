// import básico
import "./OperacionesMatematicas.sol";

// import avanzado
import {OperacionesSuma, OperacionesResta} from "./OperacionesMatematicas.sol";

OperacionesSuma.sumar();

//////////// OperacionesMatematicas.sol ////////////
contract OperacionesSuma {

} 


contract OperacionesResta {

}
///////////////////////////////////////////////////////

// mapping simple
mapping(address => string) tokens;
tokens["0x5242"] = "USDT";

mapping(string => uint256) saldoToken;
saldoToken["USDT"] = 50;

// ¿cuánto saldo tengo de dicho token?

// mapping doble
mapping(address => mapping(string => uint256)) saldoTokens;
// "0x5242" => "USDT" => 50;
saldoTokens["0x5242"]["USDT"] = 50;
Usuarios => (Tokens => Saldos)
mapping(address => mapping(string => uint256)) saldoTokens;

// Iván Manso Arenal => Cuenta 1 | Cuenta 2 => Cuenta 1: 50€ / Cuenta 2: 60€

// dueño(address) => token(uint256)

mapping(address => mapping(string => mapping(string => uint256))) notaAlumno;
Alumno => (Asignatura => (Trimestre => Nota))
Dueño => Token => Saldo