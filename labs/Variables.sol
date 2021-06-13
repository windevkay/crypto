// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Learning{
    // integers
    uint256 public myUnit;
    function setMyUnit(uint _myUnit) public {
        myUnit = _myUnit;
    }
    
    // booleans
    bool public myBool;
    function setMyBool(bool _myBool) public {
        myBool = _myBool;
    }
    
    // integer 0 - 255
    uint8 public myUint8;
    function inc() public {
        myUint8++;
    }
    
    function dec() public {
        myUint8--;
    }
    
    // addresses
    address public myAddress;
    function setAddr(address _address) public {
        myAddress = _address;
    }
    // get address balance
    function getBalance() public view returns (uint) {
        return myAddress.balance;
    }
    
    // strings
    string public myString;
    function setString(string memory _mystring) public {
        myString = _mystring;
    }
}