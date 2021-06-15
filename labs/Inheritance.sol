// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Owned{
    address owner;
    
    constructor() {
        owner = msg.sender;
    }
    
    modifier verifyOwnership() {
        require(msg.sender == owner, "UNAUTHORIZED");
        _;
    }
}

contract Inherit is Owned {
    function getSomething() public view verifyOwnership returns(bool) {
        return true;
    }
}