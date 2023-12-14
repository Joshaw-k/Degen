// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract DegenGamingToken is ERC20 {
    address public owner;
    uint itemCount;

    struct StoreItem {
        uint id;
        address itemOwner;
        string name;
        uint256 price;
    }

    mapping(uint => StoreItem) public storeItems;

    constructor() ERC20("DegenGamingToken", "DGT") {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    function mint(address to, uint256 value) public onlyOwner {
        _mint(to, value);
    }


    function addToStore(string memory _name, uint _price) public onlyOwner {
        itemCount++;
        StoreItem storage storeItem = storeItems[itemCount];
        storeItem.id = itemCount;
        storeItem.itemOwner = msg.sender;
        storeItem.name = _name;
        storeItem.price = _price;
    }

    function burn(uint value) public {
        require(balanceOf(msg.sender) >= value, "Insufficient balance");
        _burn(msg.sender, value);
    }

    function redeem(uint8 _id) public {
        require(_id <= itemCount, "id is out of bounds");
        approve(address(this),storeItems[_id].price);
        transferFrom(msg.sender,storeItems[_id].itemOwner,storeItems[_id].price);
        storeItems[_id].itemOwner = msg.sender;
    }
}
