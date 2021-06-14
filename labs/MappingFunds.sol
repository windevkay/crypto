// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract MappingFunds {
    struct Payment {
        uint amount;
        uint timestamp;
    }
    
    struct Balance {
        uint totalBalance;
        uint numOfPayments;
        mapping(uint => Payment) payments;
    }
    // main map in this contract
    mapping(address => Balance) public balanceReceived;
    
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }
    
    function depositMoney() public payable {
        balanceReceived[msg.sender].totalBalance += msg.value;
        // create a new Payment representing this deposit and reference in memory
        Payment memory payment = Payment(msg.value, block.timestamp);
        
        balanceReceived[msg.sender].payments[balanceReceived[msg.sender].numOfPayments] = payment;
        balanceReceived[msg.sender].numOfPayments++;
    }
    
    function withdrawAllFunds(address payable _to) public {
        uint availableBalance = balanceReceived[msg.sender].totalBalance;
        balanceReceived[msg.sender].totalBalance = 0;
        _to.transfer(availableBalance);
    }
    
    function withdrawSomeMoney(address payable _to, uint _amount) public {
        require(balanceReceived[msg.sender].totalBalance >= _amount, "not enough funds available");
        balanceReceived[msg.sender].totalBalance -= _amount;
        _to.transfer(_amount);
    }
}