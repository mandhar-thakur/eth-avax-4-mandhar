# eth-avax-4-mandhar

## DegenGamingToken
DegenGamingToken is an ERC-20 token contract designed for a gaming platform. It includes functionalities for minting tokens, transferring tokens, burning tokens, and managing a store with purchasable items.

Contract Overview
The DegenGamingToken contract includes the following functionalities:

Minting Tokens: The owner can mint new tokens and assign them to a specified address.
Transferring Tokens: Users can transfer tokens to other addresses.
Burning Tokens: Users can burn their tokens, reducing the total supply.
Store Management: The owner can add items to a store, and users can purchase these items using tokens.
Contract Structure
State Variables
tokenName: Name of the token.
symbol: Symbol of the token.
decimals: Number of decimal places for the token.
totalSupply: Total supply of the token.
owner: Address of the contract owner.
balanceOf: Mapping of addresses to their token balances.
storeItems: Mapping of item IDs to store items.
nextItemId: ID for the next item to be added to the store.
Structs
Item: Represents a store item with an ID, name, price, and stock.
Events
Transfer: Emitted when tokens are transferred.
Mint: Emitted when new tokens are minted.
Burn: Emitted when tokens are burned.
ItemAdded: Emitted when a new item is added to the store.
ItemPurchased: Emitted when an item is purchased from the store.
Modifiers
onlyOwner: Restricts function access to the contract owner.
Functions
mint(address to, uint value): Mints new tokens and assigns them to the specified address.
transfer(address to, uint value): Transfers tokens to the specified address.
burn(uint value): Burns tokens, reducing the total supply.
balance(address account): Returns the token balance of the specified account.
addItem(string memory itemName, uint price, uint stock): Adds a new item to the store.
getItem(uint itemId): Returns the details of a store item.
purchaseItem(uint itemId, uint quantity): Purchases a specified quantity of an item from the store.
Creating the ERC-20 Token
To create the ERC-20 token with the name "Degen" and symbol "DGN", follow these steps:

Set the Token Name and Symbol

In the DegenGamingToken contract, set tokenName to "Degen" and symbol to "DGN".
Test the Smart Contract

Write unit tests to verify the functionality of the smart contract. Ensure all tests pass.
Deploy the Contract to Avalanche Fuji Testnet

Use a tool like Hardhat or Truffle to deploy the contract to the Avalanche Fuji Testnet.
Test on Testnet

Perform tests on the deployed contract to ensure it works as expected on the testnet.
Deployment Instructions
Prerequisites
Node.js and npm installed.
Hardhat or Truffle installed.
Avalanche Fuji Testnet setup.
