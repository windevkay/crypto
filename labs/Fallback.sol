// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Fallback {
    address payable owner;
    constructor() {
        owner = payable(msg.sender);
    }
    
    mapping(address => uint) public balanceReceived;
    
    function receiveMoney() payable public {
        assert(balanceReceived[msg.sender] + msg.value > balanceReceived[msg.sender]);
        balanceReceived[msg.sender] += msg.value;
    }
    
    function withdrawMoney(address payable _to, uint _amount) public {
        require(_amount <= balanceReceived[msg.sender], "not enough funds");
        assert(balanceReceived[msg.sender] >= balanceReceived[msg.sender] - _amount);
        balanceReceived[msg.sender] -= _amount;
        _to.transfer(_amount);
    }
    
    function destroyContract() public {
        require(msg.sender == owner, "Denied");
        selfdestruct(owner);
    }
    // view functions act solely as getters
    function getOwner() public view returns(address){
        return owner;
    }
    // pure functions do not make use of any other memebers or variables in the contract
    function convertWeiToEther(uint _value) public pure returns(uint){
        return _value / 1 ether;
    }
    // the payable fallback will be triggered for calls to the contract where there is no receive ether function
    fallback () external payable{
        //receiveMoney();
    }
    // the receive is triggerd for calls to the contract on plain ether transfers
    receive () external payable{
        receiveMoney();
    }
}