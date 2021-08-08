// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

// only the account that deploys this contract should have access to create and delivery 
import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol';

contract Item {
    uint public priceInWei;
    uint public pricePaid;
    uint public index;
    ItemManager parentContract;
    
    constructor(ItemManager _parentContract, uint _priceInWei, uint _index) {
        priceInWei = _priceInWei;
        index = _index;
        parentContract = _parentContract;
    }
    
    // the receive is triggerd for calls to the contract on plain ether transfers
    receive () external payable{
        require(pricePaid == 0, 'Item has already been paid for');
        require(priceInWei == msg.value, 'A full payment for the item is required');
        pricePaid += msg.value;
        // send money to the parent contracts trigger payment method
        (bool success, ) = address(parentContract).call{value:msg.value}(abi.encodeWithSignature('triggerPayment(uint256)',index));
        // if the transaction wasnt successful then cancel
        require(success, 'The transaction was not successful, cancelling...');
    }
    
    fallback() external payable {}
}

contract ItemManager is Ownable {
    // state enum to denote state of an item 
    enum SupplyChainState { Created, Paid, Delivered }
    
    // data structure to hold generic created items
    struct S_Item {
        Item _item;
        string _identifier; 
        uint _itemPrice;
        ItemManager.SupplyChainState _state;
    }
    
    // mapping to hold/store created items
    mapping(uint => S_Item) public items;
    uint itemIndex;
    
    // event for supply chain functions 
    event SupplyChainstep(uint _itemIndex, uint _step, address _itemAddress);
    
    // function to create an item
    function createItem(string memory _identifier, uint _itemPrice) public onlyOwner {
        // create new Item 
        Item item = new Item(this, _itemPrice, itemIndex);
        
        items[itemIndex]._item = item;
        items[itemIndex]._identifier = _identifier;
        items[itemIndex]._itemPrice = _itemPrice;
        items[itemIndex]._state = SupplyChainState.Created;
        
        // emit operation event 
        emit SupplyChainstep(itemIndex, uint(items[itemIndex]._state), address(item));
        itemIndex++;
    }
    
    // function to handle payment for the item 
    function triggerPayment(uint _itemIndex) public payable {
        // check that the price being paid matches the price of the item
        require(items[_itemIndex]._itemPrice == msg.value, 'Payment needs to be in full');
        // check that the item is still in the Created state 
        require(items[_itemIndex]._state == SupplyChainState.Created, 'Item is further in the supply chain');
        
        // if all requirements are met, then set the item state to paid 
        items[_itemIndex]._state = SupplyChainState.Paid;
        
        // emit operation event 
        emit SupplyChainstep(_itemIndex, uint(items[_itemIndex]._state), address(items[_itemIndex]._item));
    }
    
    // function to handle the delivery of the item 
    function triggerDelivery(uint _itemIndex) public onlyOwner {
        // check that the item has been paid for 
        require(items[_itemIndex]._state == SupplyChainState.Paid, 'Item is not in paid state');
        
        // if all requirements are met, then set the item state to delivered
        items[_itemIndex]._state = SupplyChainState.Delivered;
        
        // emit operation event 
        emit SupplyChainstep(_itemIndex, uint(items[_itemIndex]._state), address(items[_itemIndex]._item));
    }
}