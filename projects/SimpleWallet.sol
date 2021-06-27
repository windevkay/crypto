// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
// importing this way likely only works with Remix
import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol';

contract Allowance is Ownable {
    event AllowanceChanged(address indexed _to, address indexed _from, uint _oldAmount, uint _newAmount);
     // map to hold deposits of allowances
    mapping(address => uint) public allowances;
    
    function addAllowance(address _who, uint _amount) public onlyOwner {
        // emit event about the action
        emit AllowanceChanged(_who, msg.sender, allowances[_who], allowances[_who] + _amount);
        allowances[_who] = _amount;
    }
    
    // modifier for access to only contract owner or allowance depositor
    modifier ownerOrAllowed (uint _amount) {
        require(owner() || allowances[msg.sender] >= _amount, 'You are not allowed');
        _;
    }
    
    // reduce the allowance of a depositor after they make a withdrawal
    function reduceAllowance (address _withdrawer, uint _amount) internal {
        // emit event about the action
        emit AllowanceChanged(_withdrawer, msg.sender, allowances[_withdrawer], allowances[_withdrawer] + _amount);
        allowances[_withdrawer] -= _amount;
    }
}

contract SimpleWallet is Allowance {
    event MoneySent(address indexed _beneficiary, uint _amount);
    event MoneyReceived(address indexed _from, uint _amount);
    
    // withdrawal function, pass required arg to modifier
    function withdraw (address payable _to, uint _amount) public ownerOrAllowed(_amount) {
        require(_amount <= address(this).balance, 'Not enough funds in this smart contract');
        if(!owner()){
            reduceAllowance(msg.sender, _amount);
        }
        emit MoneySent(_to, _amount);
        // transfer to specified address
        _to.transfer(_amount);
    }
    
    function renounceOwnership () override public onlyOwner {
        revert("Cannot renounce ownership here");
    }
    
    // create a fallback function to accept deposits
    fallback () external payable {
        emit MoneyReceived(msg.sender, msg.value);
    }
    receive () external payable {
        emit MoneyReceived(msg.sender, msg.value);
    }
}