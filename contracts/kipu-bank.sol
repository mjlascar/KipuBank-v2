// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/**
 * @title KipuBank
 * @author Marcos
 * @notice contrato para depositar y retirar Ether,  con fines educativos.
 */

 
contract KipuBank {
 
    /**
     * @notice limite inmutable de retiro
     */
    uint256 public immutable i_retiroMax;
    /**
     * @notice limite inmutable de depositos
     */
    uint256 public immutable i_bankCap;
    /**
    * @notice Saldos de los usuarios
    */
    mapping(address => uint256) private s_saldos;

    /**
    * @notice Total de ETH depositado en el contrato
    */
    uint256 private s_totalDepositado;

    /**
    * @notice Contador de depositos
    */
    uint256 private s_contadorDepositos;

    /** 
    * @notice Contador de retiros
    */
    uint256 private s_contadorRetiros;
 
    // Modificadores
    
    /**
     * @notice Revisa si el monto del depósito es válido y si no excede el tope del banco.
     */
    modifier depositoValido() {
        if (msg.value == 0) revert KipuBank__MontoDepositoEsCero();
        if (s_totalDepositado + msg.value > i_bankCap) revert KipuBank__TopeDelBancoExcedido(s_totalDepositado, i_bankCap, msg.value);
        _;
    }


    ///eventos
    event Deposito(address indexed usuario, uint256 monto);
    event Retiro(address indexed usuario, uint256 monto);
 
    /// errores personalizados

    /** 
    * @notice  Se activa si el monto del depósito es cero
    */
    error KipuBank__MontoDepositoEsCero();

    /** 
    * @notice si el deposito excede el limite total del banco
    */
    error KipuBank__TopeDelBancoExcedido(uint256 totalDepositado, uint256 topeBanco, uint256 monto);

    /** 
    * @notice si el monto a retirar es cero
    */
    error KipuBank__MontoRetiroEsCero();

    /** 
    * @notice si el monto a retirar excede el umbral por transaccion
    */
    error KipuBank__UmbralDeRetiroExcedido(uint256 monto, uint256 umbral);

    /** 
    * @notice si el usuario no tiene saldo suficiente para el retiro
    */
    error KipuBank__SaldoInsuficiente(uint256 saldo, uint256 monto);

    /** 
    * @notice si la transferencia de ETH al usuario falla
    */
    error KipuBank__TransferenciaFallida();


 
     constructor(uint256 _retiroMax, uint256 _bankCap) {
        i_retiroMax = _retiroMax;
        i_bankCap = _bankCap;
    }
 
 
    // Funciones Receive y Fallback

    /**
     * @notice Acepta depositos de ETH. Se activa al enviar ETH al contrato sin datos de funcion
       */
    receive() external payable depositoValido {
        _depositar();
    }

    /**
     * @notice Se activa si se envia ETH con datos a una funcion que no existe
     */
    fallback() external payable depositoValido {
        _depositar();
    }
 
 
    // Funciones Externas

    /**
     * @notice Permite a un usuario retirar su ETH
     */
    function retirar(uint256 _monto) external {
        // Chequeos (podrian ser un modificador pero los dejo asi para variedad)
        if (_monto == 0) revert KipuBank__MontoRetiroEsCero();
        if (_monto > i_bankCap) revert KipuBank__TopeDelBancoExcedido(_monto, i_bankCap);
        if (_monto > i_retiroMax) revert KipuBank__UmbralDeRetiroExcedido(_monto, i_retiroMax);
        uint256 saldoUsuario = s_saldos[msg.sender];
        if (_monto > saldoUsuario) revert KipuBank__SaldoInsuficiente(saldoUsuario, _monto);

        // Efectos
        s_saldos[msg.sender] -= _monto;
        s_totalDepositado -= _monto;
        s_contadorRetiros++;
        
        // Interacción
        _transferenciaSegura(msg.sender, _monto);
        emit Retiro(msg.sender, _monto);
    }
    
    // Funciones de Vista (View)

    /**
     * @notice Devuelve el saldo de un usuario
     */
    function obtenerSaldoUsuario(address _usuario) external view returns (uint256) {
        return s_saldos[_usuario];
    }
    
    
    /**
     * @notice Devuelve el saldo de un usuario
     */
    function obtenerEstadoBanco() external view returns (uint256 totalDepositado, uint256 topeDelBanco, uint256 numDepositos, uint256 numRetiros) {
        return (s_totalDepositado, i_bankCap, s_contadorDepositos, s_contadorRetiros);
    }
 
    // Funciones Privadas

    /**
     * @notice Logica interna para manejar los depositos
     */
    function _depositar() private {
        // chequeos se realizan en el modifier 

        // Efectos
        s_saldos[msg.sender] += msg.value;
        s_totalDepositado += msg.value;
        s_contadorDepositos++;

        // Interacción
        emit Deposito(msg.sender, msg.value);
    }

    
    /**
     * @notice Transfiere ETH de forma segura
     */
    function _transferenciaSegura(address _para, uint256 _monto) private {
        (bool success, ) = _para.call{value: _monto}("");
        if (!success) revert KipuBank__TransferenciaFallida();
    }
}
