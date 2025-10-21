KipuBank Smart Contract 
KipuBank es una bóveda digital segura en la blockchain para depositar y retirar ETH.

¿Cómo se usa?
  Puedes interactuar con el contrato directamente en Etherscan una vez desplegado.

Depositar (deposit)
  Envía ETH (Ether) a la función deposit para guardarlo en tu bóveda personal.

Retirar (withdraw)
  Llama a la función withdraw especificando la cantidad que quieres retirar.

Importante: Solo puedes retirar hasta un límite (prefijado al inicio de vida del contrato) por transacción (ej: 1 ETH).

Consultar Saldo (getVaultBalance)
  Llama a esta función para ver cuánto ETH tienes guardado.

Contrato en Testnet (Sepolia)
  Dirección: 0x4d4e9bdd3daafb2058f20c70017015ad2ae38cce
  Ver en Etherscan: https://sepolia.etherscan.io/address/0x4d4e9bdd3daafb2058f20c70017015ad2ae38cce

Despliegue (con Remix)
1.Abre KipuBank.sol en Remix IDE.

2.Compila el contrato.
  Ve a la pestaña Compiler (icono S) y haz clic en "Compile".

3.Despliega.
  Ve a la pestaña Deploy (icono de Ethereum).
  Elige "Injected Provider - MetaMask" para conectar tu billetera.
  Ingresa los límites del banco en wei.
  Haz clic en "Deploy" y confirma en MetaMask.
