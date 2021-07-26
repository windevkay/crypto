// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract ItemManager {
    // state enum to denote state of an item 
    enum SupplyChainState { Created, Paid, Delivered }
    
    // data structure to hold created items
    struct S_Item {
        string _identifier; 
        uint _itemPrice;
        ItemManager.SupplyChainState _state;
    }
    
    // mapping to hold/store created items
    mapping(uint => S_Item) public items;
    uint itemIndex;
    
    // event for supply chain functions 
    event SupplyChainstep(uint _itemIndex, uint _step);
    
    // function to create an item
    function createItem(string memory _identifier, uint _itemPrice) public {
        items[itemIndex]._identifier = _identifier;
        items[itemIndex]._itemPrice = _itemPrice;
        items[itemIndex]._state = SupplyChainState.Created;
        
        // emit operation event 
        emit SupplyChainstep(itemIndex, uint(items[itemIndex]._state));
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
        emit SupplyChainstep(itemIndex, uint(items[itemIndex]._state));
    }
    
    // function to handle the delivery of the item 
    function triggerDelivery(uint _itemIndex) public {
        // check that the item has been paid for 
        require(items[_itemIndex]._state == SupplyChainState.Paid, 'Item is not in paid state');
        
        // if all requirements are met, then set the item state to delivered
        items[_itemIndex]._state = SupplyChainState.Delivered;
        
        // emit operation event 
        emit SupplyChainstep(itemIndex, uint(items[itemIndex]._state));
    }
}