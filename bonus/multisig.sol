// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MultiSig {

    // The NF42 token contract that this multisig holds and transfers
    IERC20 public token;

    // List of the addresses allowed to sign (the owners)
    address[] public owners;

    // Quick check: true if an address is one of the owners
    mapping(address => bool) public isOwner;

    // Number of confirmations needed to execute a transaction (e.g. 2 of 3)
    uint256 public requiredConfirmations;

    // A transaction proposed by an owner, waiting for confirmations
    struct Transaction {
        address to;            // who will receive the NF42
        uint256 amount;        // how many NF42 (in units, with 18 decimals)
        uint256 confirmations; // how many owners have confirmed it
        bool executed;         // true once the NF42 have been sent
    }

    // All proposed transactions; the index in the list is the transaction number (0, 1, 2...)
    Transaction[] public transactions;

    // For each transaction number: which owner has already confirmed it
    mapping(uint256 => mapping(address => bool)) public isConfirmed;

    // Events: public announcements shown on BscScan
    event TransactionProposed(uint256 indexed txId, address indexed owner, address indexed to, uint256 amount);
    event TransactionConfirmed(uint256 indexed txId, address indexed owner);
    event TransactionExecuted(uint256 indexed txId, address indexed owner);

    // Only an owner can call a function marked with this modifier
    modifier onlyOwner() {
        require(isOwner[msg.sender], "Not an owner");
        _;
    }

    /**
     * @notice Runs only once, when the multisig is deployed.
     * @param tokenAddress Address of the NF42 token contract
     * @param ownersList Addresses allowed to sign (e.g. 3 accounts)
     * @param required Number of confirmations needed (e.g. 2)
     */
    constructor(address tokenAddress, address[] memory ownersList, uint256 required) {
        require(tokenAddress != address(0), "Invalid token address");
        require(ownersList.length > 0, "Owners required");
        require(required > 0 && required <= ownersList.length, "Invalid number of required confirmations");

        // Register each owner, refusing address 0 and duplicates
        for (uint256 i = 0; i < ownersList.length; i++) {
            address owner = ownersList[i];
            require(owner != address(0), "Invalid owner");
            require(!isOwner[owner], "Owner not unique");

            isOwner[owner] = true;
            owners.push(owner);
        }

        token = IERC20(tokenAddress);
        requiredConfirmations = required;
    }

    /**
     * @notice Proposes a new NF42 transfer from the multisig.
     * @param to Address that will receive the NF42
     * @param amount Number of NF42 in units (1 NF42 = 10**18 units)
     * @return txId Number of the new transaction
     */
    function propose(address to, uint256 amount) external onlyOwner returns (uint256 txId) {
        require(to != address(0), "Invalid recipient");
        require(amount > 0, "Amount must be greater than 0");

        txId = transactions.length;
        transactions.push(Transaction({to: to, amount: amount, confirmations: 0, executed: false}));

        emit TransactionProposed(txId, msg.sender, to, amount);
    }

    /**
     * @notice Confirms a proposed transaction. Each owner can confirm only once.
     * @param txId Number of the transaction to confirm
     */
    function confirm(uint256 txId) external onlyOwner {
        require(txId < transactions.length, "Transaction does not exist");
        require(!transactions[txId].executed, "Transaction already executed");
        require(!isConfirmed[txId][msg.sender], "Transaction already confirmed by this owner");

        isConfirmed[txId][msg.sender] = true;
        transactions[txId].confirmations += 1;

        emit TransactionConfirmed(txId, msg.sender);
    }

    /**
     * @notice Executes a transaction once it has enough confirmations:
     *         the multisig sends the NF42 by calling transfer() on the token.
     * @param txId Number of the transaction to execute
     */
    function execute(uint256 txId) external onlyOwner {
        require(txId < transactions.length, "Transaction does not exist");

        Transaction storage transaction = transactions[txId];
        require(!transaction.executed, "Transaction already executed");
        require(transaction.confirmations >= requiredConfirmations, "Not enough confirmations");

        transaction.executed = true;
        require(token.transfer(transaction.to, transaction.amount), "Token transfer failed");

        emit TransactionExecuted(txId, msg.sender);
    }

}
