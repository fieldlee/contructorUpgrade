pragma solidity ^0.4.23;

import "./TokenStorage.sol";

contract SafeMath {
    // function safeMul(uint a, uint b) internal pure returns (uint) {
    //     uint c = a * b;
    //     assertfun(a == 0 || c / a == b);
    //     return c;
    // }

    // function safeDiv(uint a, uint b) internal pure returns (uint) {
    //     assertfun(b > 0);
    //     uint c = a / b;
    //     assertfun(a == b * c + a % b);
    //     return c;
    // }

    function safeSub(uint a, uint b) internal pure returns (uint) {
        require(b <= a);
        return a - b;
    }

    function safeAdd(uint a, uint b) internal pure returns (uint) {
        uint c = a + b;
        require(c>=a && c>=b);
        return c;
    }

    // function max64(uint64 a, uint64 b) internal pure returns (uint64) {
    //     return a >= b ? a : b;
    // }

    // function min64(uint64 a, uint64 b) internal pure returns (uint64) {
    //     return a < b ? a : b;
    // }

    // function max256(uint256 a, uint256 b) internal pure returns (uint256) {
    //     return a >= b ? a : b;
    // }

    // function min256(uint256 a, uint256 b) internal pure returns (uint256) {
    //     return a < b ? a : b;
    // }
    // function assertfun(bool assertion) internal pure {
    //     assert(!assertion);
    //     // if (!assertion) {throw;}
    // }
}

contract LToken  is  SafeMath {
    TokenStorage tokenStorage;

    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
    // ,string name,string symbol,uint8 decimals,uint256 total
    constructor(address tokenStorageAddress) public{
        tokenStorage = TokenStorage(tokenStorageAddress);
    }

    function setInitName(string name) public returns(bool){
        tokenStorage.setName(name);
        return true;
    }

    function setInitSymbol(string symbol) public returns(bool){
        tokenStorage.setSymbol(symbol);
        return true;
    }

    function setInitDecimals(uint8 decimals) public returns(bool){
        tokenStorage.setDecimals(decimals);
        return true;
    }

    function setInitTotalSupply(uint256 total) public returns(bool){
        tokenStorage.setTotalSupply(total);
        return true;
    }

    function totalSupply() public view returns (uint256) {
        return tokenStorage.getTotalSupply();
    }

    function balanceOf(address _addr) public view returns (uint) {
        return tokenStorage.getBalanceOf(_addr);
    }

    function transfer(address _to, uint _value) public returns (bool) {
        if(_value > 0 && _value <=  tokenStorage.getBalanceOf(msg.sender)){
            tokenStorage.setBalanceOf(msg.sender,safeSub(tokenStorage.getBalanceOf(msg.sender),_value));
            tokenStorage.setBalanceOf(_to,safeAdd(tokenStorage.getBalanceOf(_to),_value));
            emit Transfer(msg.sender, _to, _value);
            return true;
        }else{
            return false;
        }
    }

    function transferFrom(address _from, address _to, uint _value) public returns (bool) {
        if(tokenStorage.getAllowances(_from,msg.sender) > 0 &&
            _value > 0 &&
            tokenStorage.getAllowances(_from,msg.sender) >= _value &&
            tokenStorage.getBalanceOf(_from) >= _value) {
            tokenStorage.setBalanceOf(_from,safeSub(tokenStorage.getBalanceOf(_from), _value));
            tokenStorage.setBalanceOf(_to,safeAdd(tokenStorage.getBalanceOf(_to), _value));
            tokenStorage.setAllowances(_from,msg.sender,safeSub(tokenStorage.getAllowances(_from,msg.sender),_value));
            // _allowances[_from][msg.sender] =  _allowances[_from][msg.sender] - _value ;
            emit Transfer(_from, _to, _value);
            return true;
        }
        return false;
    }

    function approve(address _spender, uint _value) public returns (bool) {
        tokenStorage.setAllowances(msg.sender,_spender,_value);
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint) {
        return tokenStorage.getAllowances(_owner,_spender);
    }

    function kill() public {
        selfdestruct(msg.sender);
    }
}
