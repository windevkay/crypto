// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract FundTransfer {
    uint public fundsReceived;
    
    function receiveFunds() public payable {
        //global msg object is available when a payable function is called
        fundsReceived += msg.value;
    }
    
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }
    
    function sendFunds() public {
        //msg.sender is of type address and needs to be casted to type "address payable"
        address payable to = payable(msg.sender);
        to.transfer(this.getBalance());
    }
    
    //sending to a specific address
    function sendFundsTo(address payable _to) public {
        _to.transfer(this.getBalance());
    }
}