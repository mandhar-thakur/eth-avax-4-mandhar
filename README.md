# ETH-AVAX-4-Mandhar

## Create and Deploy a Custom Token on Avalanche Fuji Testnet

Welcome to the ETH+AVAX Proof Intermediate course project by Metacrafters! In this project, you'll develop a custom ERC20 token using Solidity and deploy it to the Avalanche Fuji Testnet utilizing Hardhat.

### Table of Contents

- [Prerequisites](#prerequisites)
- [Installation and Setup](#installation-and-setup)
- [Deployment](#deployment)
- [Verification](#verification)
- [Interacting with Your Token](#interacting-with-your-token)

---

## Prerequisites

Before you begin, ensure you have the following:

- **Web3 Wallet**: Install a Web3-compatible wallet like [MetaMask](https://metamask.io/).
- **Fuji Testnet AVAX**: Acquire AVAX tokens for the Avalanche Fuji Testnet to cover transaction fees. You can obtain them from an [Avalanche Fuji Faucet](https://faucet.avax-test.network/).

---

## Installation and Setup

### 1. Open Remix IDE

Navigate to [Remix IDE](https://remix.ethereum.org/) in your web browser. Remix is a powerful online IDE for Solidity development.

### 2. Configure the Network

In your deployment scripts or configurations, replace the placeholder `"SELECTED_NETWORK"` with your desired network:

- **Fuji Testnet**: Use `fuji`
- **Mainnet**: Use `mainnet`

Ensure your configuration aligns with the network you intend to deploy to.

## IERC20 token contract

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


## Deployment

Once your environment is set up:

1. **Write Your Smart Contract**: Develop your ERC20 token contract in Remix.
2. **Compile the Contract**: Use Remix's compiler to ensure your contract is error-free.
3. **Deploy the Contract**: Connect your MetaMask wallet to Remix and deploy the contract to the chosen network.

Upon successful deployment, Remix will display the contract address. Make sure to copy and save this address for future reference.

---

## Verification

After deploying your token:

1. **Confirm Deployment**: The deployment script will output the contract address.
2. **Verify on Snowtrace**: Visit [Snowtrace](https://snowtrace.io/) and enter your contract address to view and verify your token on the Avalanche network.

---

## Interacting with Your Token

To interact with your newly deployed token, follow these steps:

1. **Access Remix IDE**: Open [Remix](https://remix.ethereum.org/) in your browser.
2. **Upload Your Contract**: Load the same ERC20 contract you deployed.
3. **Compile the Contract**: Press `Ctrl+S` to save and compile your contract.
4. **Connect Your Wallet**: Approve the connection between Remix and your Web3 wallet (e.g., MetaMask). Remix will automatically detect and load your account connected to the selected network.
5. **Load Your Token**:
   - Enter your token's contract address in the "At Address" field.
   - Click the **At Address** button to load the contract.
6. **Interact**: Once loaded, you can call the contract's functions directly from Remix, such as transferring tokens, checking balances, and more.

---

## Additional Tips

- **Testing**: Before deploying to the mainnet, thoroughly test your contract on the Fuji Testnet to ensure all functionalities work as expected.
- **Security**: Consider auditing your smart contract or using established libraries like OpenZeppelin to enhance security.
- **Documentation**: Keep your contract's documentation up-to-date to assist users and developers interacting with your token.


# License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

# Acknowledgments

- [Metacrafters](https://www.metacrafters.io/) for providing the course and resources.
- [Remix IDE](https://remix.ethereum.org/) for being an excellent development tool.
- The Avalanche community for their support and resources.
