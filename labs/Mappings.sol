// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Mappings{
    mapping(uint => bool) public myMapping;
    mapping(address => bool) public myAddressMapping;
    
    //set the boolean value of an index
    function setValue(uint _index) public {
        myMapping[_index] = true;
    }
    
    function setMyAddressMapping() public {
        myAddressMapping[msg.sender] = true;
    }
}