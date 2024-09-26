// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

interface IERC20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function transfer(address recipient, uint amount) external returns (bool);
    
    event Transfer(address indexed from, address indexed to, uint amount);
}

contract ERC20 is IERC20 {
    address public immutable owner;
    uint public override totalSupply;
    mapping (address => uint) public override balanceOf;

    struct Transaction {
        uint transactionId;
        address sender;
        address receiver;
        uint amount;
        uint timestamp;
    }
    
    mapping(uint => Transaction) public transactions;
    uint public transactionCount;

    // Event to log transaction data
    event TransactionRecorded(uint indexed transactionId, address indexed sender, address indexed receiver, uint amount, uint timestamp);

    // Armor related structures and events
    enum ArmorLevel { None, Level1, Level2, Level3, Level4, Level5 }
    
    struct Armor {
        ArmorLevel level;
        uint purchaseTimestamp;
    }
    
    mapping(address => Armor[]) public userArmors;
    
    // Event to log armor purchases
    event ArmorPurchased(address indexed buyer, ArmorLevel level, uint cost, uint timestamp);

    // Define armor costs (in tokens)
    mapping(ArmorLevel => uint) public armorCosts;

    // Token metadata
    string public constant name = "Degen";
    string public constant symbol = "DGN";
    uint8 public constant decimals = 0;

    constructor() {
        owner = msg.sender;
        totalSupply = 0;

        // Initialize armor costs
        armorCosts[ArmorLevel.Level1] = 100; 
        armorCosts[ArmorLevel.Level2] = 200;
        armorCosts[ArmorLevel.Level3] = 300;
        armorCosts[ArmorLevel.Level4] = 400;
        armorCosts[ArmorLevel.Level5] = 500;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only the contract owner can execute this function");
        _;
    }

    function transfer(address recipient, uint amount) external override returns (bool) {
        require(balanceOf[msg.sender] >= amount, "The balance is insufficient");

        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;

        // Record the transaction
        recordTransaction(msg.sender, recipient, amount);

        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function mint(address receiver, uint amount) external onlyOwner {
        balanceOf[receiver] += amount;
        totalSupply += amount;
        emit Transfer(address(0), receiver, amount);
    }

    function burn(uint amount) external {
        require(amount > 0, "Amount should not be zero");
        require(balanceOf[msg.sender] >= amount, "The balance is insufficient");
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;

        emit Transfer(msg.sender, address(0), amount);
    }

    function recordTransaction(address sender, address receiver, uint amount) internal {
        transactionCount++;
        transactions[transactionCount] = Transaction({
            transactionId: transactionCount,
            sender: sender,
            receiver: receiver,
            amount: amount,
            timestamp: block.timestamp
        });
        emit TransactionRecorded(transactionCount, sender, receiver, amount, block.timestamp);
    }

    function getTransactions() external view returns (Transaction[] memory) {
        Transaction[] memory allTransactions = new Transaction[](transactionCount);
        
        for (uint i = 1; i <= transactionCount; i++) {
            allTransactions[i - 1] = transactions[i];
        }
        
        return allTransactions;
    }

    // Function to purchase armor
    function purchaseArmor(ArmorLevel level) external returns (bool) {
        require(level >= ArmorLevel.Level1 && level <= ArmorLevel.Level5, "Invalid armor level");

        uint cost = armorCosts[level];
        require(balanceOf[msg.sender] >= cost, "Insufficient token balance to purchase armor");

        // Deduct the cost from the user's balance
        balanceOf[msg.sender] -= cost;
        totalSupply -= cost; // Assuming tokens are burned upon purchase

        emit Transfer(msg.sender, address(0), cost);

        // Record the armor purchase
        userArmors[msg.sender].push(Armor({
            level: level,
            purchaseTimestamp: block.timestamp
        }));

        emit ArmorPurchased(msg.sender, level, cost, block.timestamp);

        return true;
    }

    // Function to get a user's armor details
    function getUserArmors(address user) external view returns (Armor[] memory) {
        return userArmors[user];
    }

    // Optional: Function for the owner to update armor costs
    function setArmorCost(ArmorLevel level, uint cost) external onlyOwner {
        require(level >= ArmorLevel.Level1 && level <= ArmorLevel.Level5, "Invalid armor level");
        armorCosts[level] = cost;
    }
}
