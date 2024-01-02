// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract CustomMultiSigWallet {
    // Array to store the addresses of authorized users
    address[3] public authorizedUsers;

    // Counter for tracking the number of proposed transactions
    uint public transactionCount;

    // Struct representing a proposed transaction
    struct Transaction {
        uint id; // Unique identifier for the transaction
        address payable receiver; // Address to which the funds will be sent
        uint amount; // Amount of ether to be sent in the transaction
        uint approvals; // Number of approvals received for the transaction
    }

    // Mapping to store proposed transactions using their unique IDs
    mapping(uint => Transaction) public transactions;

    // Constructor to initialize the authorized users of the wallet
    constructor(address[3] memory _authorizedUsers) {
        authorizedUsers = _authorizedUsers;
    }

    // Function to propose a new transaction
    function proposeNewTransaction(
        address payable receiver,
        uint amount
    ) public {
        // Ensure that the sender is one of the authorized users
        require(
            isAuthorizedUser(msg.sender),
            "Only authorized users can propose transactions"
        );

        // Increment the transaction count
        transactionCount++;

        // Create a new transaction and store it in the transactions mapping
        transactions[transactionCount] = Transaction(
            transactionCount,
            receiver,
            amount,
            0
        );
    }

    // Function for an authorized user to approve a proposed transaction
    function approveProposedTransaction(uint transactionId) public {
        // Ensure that the sender is one of the authorized users
        require(
            isAuthorizedUser(msg.sender),
            "Only authorized users can approve transactions"
        );

        // Ensure that the transaction is not already fully approved
        require(
            transactions[transactionId].approvals < 2,
            "Transaction is already approved"
        );

        // Increment the approvals for the specified transaction
        transactions[transactionId].approvals++;
    }

    // Function to execute a proposed transaction after it has received enough approvals
    function executeApprovedTransaction(uint transactionId) public {
        // Ensure that the transaction has received at least 2 approvals
        require(
            transactions[transactionId].approvals >= 2,
            "Transaction is not approved"
        );

        // Transfer the specified amount of ether to the receiver address
        transactions[transactionId].receiver.transfer(
            transactions[transactionId].amount
        );
    }

    // Function to check if an address is one of the authorized users
    function isAuthorizedUser(address sender) public view returns (bool) {
        // Iterate through the authorized users array and return true if the address is found
        for (uint i = 0; i < authorizedUsers.length; i++) {
            if (authorizedUsers[i] == sender) {
                return true;
            }
        }
        // Return false if the address is not found among the authorized users
        return false;
    }
}
