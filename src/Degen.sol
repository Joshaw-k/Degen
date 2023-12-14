// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract DegenGamingToken is ERC20 {
    address public s_owner;
    uint itemCount;

    struct Item {
        address owner;
        string name;
        uint256 cost;
    }

    mapping(uint => Item) public items;

    constructor() ERC20("DegenGamingToken", "DGT") {
        s_owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == s_owner, "You are not the owner");
        _;
    }

    function mint(address to, uint256 value) public onlyOwner {
        _mint(to, value);
    }


    function addItem(string memory _name, uint _cost) public onlyOwner {
        items[itemCount] = Item({owner: msg.sender, name: _name, cost: _cost});
        itemCount++;
    }

    function burn(uint value) public {
        require(balanceOf(msg.sender) >= value, "Insufficient balance");
        _burn(msg.sender, value);
    }

    function redeem(uint8 _itemCount) public {
        require(_itemCount <= itemCount, "itemCount is out of bounds");
        transfer(items[_itemCount].owner, items[_itemCount].cost);
        items[_itemCount].owner = msg.sender;
    }
}
