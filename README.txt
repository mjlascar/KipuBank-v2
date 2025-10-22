(+) agregado ERRORES y EVENTOS nuevos

(+) agregado control de Reentrancy con estandar de OpenZeppelin

(+) agregado control de acceso (OpenZeppelin -> AccessControl) para que solo ciertas direcciones puedan ejecutar funciones críticas
	-Elegi AccessControl sobre Ownable ya que permite separacion de responsabilidades, y ayuda a la descentralizacion (no es una unica wallet que hace todo)
	-Para ejecutar determinadas funciones administrativas, ahora hay un filtro de rol

(+) agregado capacidad de Pausa (OpenZeppelin -> Pausable) para, en caso de emergencia o falla de seguridad, poder pausar la entrada y salida de dinero

(+) agregado soporte multi-token:
	-Se cambio el anterior mapping simple address -> amount, con uno anidado, que aunque contenga una variable mas, es mas ordenado y cumple para nuestra necesidad de multiples tokens
		ejemplo si queremos saber la cantidad de USDC de un usuario estaria en s_saldos[direccionSOL][direccionUsuario]
	-Adoptando la convencion de que address(0) referencia a Ether nativo (ETH).
	-Se tiene una whitelist (mapping), modificable por los roles ADMIN de los tokens permitidos
	-Se utiliza SafeERC20 (Openzeppelin) para interactuar con tokens ERC-20. manejando las posibles inconsistencias en las interfaces de los tokens
	-Funcion retirar se generaliza para aceptar diferentes tokens
	-Ahora para depositar hay dos metodos, enviando simplemente al contrato (receive() y fallback()) caera en _depositarEth(), depositando ETH
		y sino, con depositarToken() el cual utiliza safeTransferFrom de IIERC20, esto trae el paso extra de que el usuario debe dar 'approve'
		al contrato del token, para ser transferido por nuestra app KipuBank, dando un paso mas pero volviendo el sistema mucho mas seguro.

(+) agregado oraculo de Chainlink, para el cual cada token tendra respectivamente su oraculo asociado.
	-La base de contabilidad de mi sistemade es en USD, use 18 decimales para mejorar la precision y adecuarme al estandar ETH y DeFi
	-La logica de precios la aisle a una funcion compacta tokenEnUSD() que devuelve el valor en USD de cierta cantidad de tokens ERC20
	-Es costoso, porque por cada transaccion se llama a un oraculo externo, pero es la manera mas precisa y segura
	-La variable s_totalDepositado, no refleja correctamente la volatilidad del mercado!! problema dificil de resolver, tal vez para una entrega siguiente

(!) se elimino la caracterizacion inmutable del bankCap y retiroMax, ya que con esta no iba a ser posible modificarlas en el futuro, lo cual considere importante,
		para lograr asi una mayor escalabilidad en el futuro, o cualquier necesidad de flexibilidad frente a cambios


Despliegue (con Remix)
1.Abre KipuBank-v2.sol en Remix IDE.

2.Compila el contrato.
  Ve a la pestaña Compiler (icono S) y haz clic en "Compile".

3.Despliega.
  Ve a la pestaña Deploy (icono de Ethereum).
  Elige "Injected Provider - MetaMask" para conectar tu billetera.
  Ingresa los límites del banco en usd con 18 decimales ejemplo ($100): 100000000000000000000 (100 + 18 ceros).
  Ingresa el price feed de ETH para tu red (sepolia: 0x694AA1769357215DE4FAC081bf1f309aDC325306)
  Haz clic en "Deploy" y confirma en MetaMask.

Etherscan de mi deploy con codigo verificado: https://sepolia.etherscan.io/address/0xbb85b8d8bfff39c6d6382307e04adc372e2023a2
Para testear se agrego WBTC, y 
--agregue LINK (token 0x779877A7B0D9E8603169DdbD7836e478b4624789, priceFeed 0xc59E3633BAAC79493d908e63626716e204A45EdF)
--aprobe el uso de LINK por parte de mi KIPU BANK desde https://sepolia.etherscan.io/token/0x779877A7B0D9E8603169DdbD7836e478b4624789#writeContract
	con transaccion https://sepolia.etherscan.io/tx/0xac5b4c4caa0dddcf7db37b5c5201d95ee239ca4cc670e2f77dbdc0deb9b1d402
--y envie 10LINK (token 0x779877A7B0D9E8603169DdbD7836e478b4624789, monto 10000000000000000000 por 18 decimales)
	con transaccion https://sepolia.etherscan.io/tx/0x9cacea5b06ba5eeaf87e6ad72acaa8d15cf80e5efb06b19e0b5aec1ed3ad7136
--y retire 5LINK (transaccion https://sepolia.etherscan.io/tx/0x446082a5708b90580bfb9816ee7181ed7208074678335a4e3c8e9d13ba90af29)

