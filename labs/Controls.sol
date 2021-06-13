// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Controls{
    address owner;
    bool public paused;
    
    constructor() {
        owner = msg.sender;
    }
    function sendFunds() public payable {
        
    }
    
    function pauseContract(bool _paused) public {
        require(msg.sender == owner, "You cannot set the pause value of this contract");
        paused = _paused;
    }
    
    function withdrawAllFunds(address payable _to) public {
        // require is used like an if statement
        // here we use it to ensure only the original account that deployed the contract is able to make the transfer
        require(msg.sender == owner, "You are not the rightful owner");
        require(!paused, "Contract is paused");
        _to.transfer(address(this).balance);
    }
    
    function destroySmartContract(address payable _to) public {
        require(msg.sender == owner, "You cannot destroy this contract");
        selfdestruct(_to);
    }
}