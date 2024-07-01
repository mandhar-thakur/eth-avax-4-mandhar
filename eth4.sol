// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2;

contract DegenGamingToken {
    string public tokenName = "Degen Gaming Token";
    string public symbol = "DGT";
    uint public decimals = 18;
    uint public totalSupply;
    address public owner;

    mapping(address => uint) public balanceOf;
    mapping(uint => Item) public storeItems;
    uint256 public nextItemId;

    struct Item {
        uint id;
        string name;
        uint price;
        uint stock;
    }

    event Transfer(address indexed from, address indexed to, uint value);
    event Mint(address indexed to, uint value);
    event Burn(address indexed from, uint value);
    event ItemAdded(uint256 id, string name, uint price, uint256 stock);
    event ItemPurchased(address indexed buyer, uint itemId, uint256 quantity);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function mint(address to, uint value) public onlyOwner {
        totalSupply += value;
        balanceOf[to] += value;
        emit Mint(to, value);
    }

    function transfer(address to, uint value) public returns (bool success) {
        require(balanceOf[msg.sender] >= value, "Insufficient balance");
        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function burn(uint value) public returns (bool success) {
        require(balanceOf[msg.sender] >= value, "Insufficient balance");
        balanceOf[msg.sender] -= value;
        totalSupply -= value;
        emit Burn(msg.sender, value);
        return true;
    }

    function balance(address account) public view returns (uint) {
        return balanceOf[account];
    }

    function addItem(string memory itemName, uint price, uint stock) public onlyOwner {
        storeItems[nextItemId] = Item(nextItemId, itemName, price, stock);
        emit ItemAdded(nextItemId, itemName, price, stock);
        nextItemId++;
    }

    function getItem(uint itemId) public view returns (Item memory) {
        return storeItems[itemId];
    }

    function purchaseItem(uint itemId, uint quantity) public {
        Item storage item = storeItems[itemId];
        require(item.stock >= quantity, "Insufficient item stock");
        uint totalPrice = item.price * quantity;
        require(balanceOf[msg.sender] >= totalPrice, "Insufficient balance to purchase item");

        balanceOf[msg.sender] -= totalPrice;
        totalSupply -= totalPrice;
        item.stock -= quantity;

        emit ItemPurchased(msg.sender, itemId, quantity);
    }
}
