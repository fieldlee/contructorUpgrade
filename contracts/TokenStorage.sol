pragma solidity ^0.4.23;

contract TokenStorage {
    bool private _initedSymbol = false;
    string private _symbol;
    bool private _initedName = false;
    string private _name;
    bool private _initedDecimals = false;
    uint8 private _decimals;
    bool private _initedTotalSupply = false;
    uint256 private _totalSupply;
    mapping (address => uint) private _balanceOf;
    mapping (address => mapping (address => uint)) private _allowances;
    // allownce access
    mapping(address => bool) private accessAllowed;
    
    constructor()public{
        accessAllowed[msg.sender] = true;
    }

    modifier isPlatform() {
        require(accessAllowed[msg.sender] == true,"the address not allowed the storage!");
        _;
    }
    // 
    function allowAccess(address _address)   public isPlatform {
        accessAllowed[_address] = true;
    }
    // 
    function denyAccess(address _address)  public isPlatform {
        accessAllowed[_address] = false;
    }

    // get name 
    function getName() public view returns(string){
        return _name;
    }
    // set name 
    // 
    function setName(string name) public isPlatform returns(bool){
        if (!_initedName) {
            _name = name;
            _initedName = true;
            return true;
        } else {
            return false;
        }
       
    }
    // get symbol
    function getSymbol() public view returns(string){
        return _symbol;
    }
    // set symbol
    // 
    function setSymbol(string symbol) public  isPlatform returns(bool){
        if (!_initedSymbol) {
            _symbol = symbol;
            _initedSymbol = true;
            return true;
        } else {
            return false;
        }
    }
    // get decimals
    function getDecimals() public view returns(uint8){
        return _decimals;
    }
    // set _decimals
    function setDecimals(uint8 decimals) public isPlatform returns(bool){
        if (!_initedDecimals) {
            _decimals = decimals;
            _initedDecimals = true;
            return true;
        } else {
            return false;
        }
    }
    // set total supply
    // isPlatform
    function setTotalSupply(uint256 total) public  returns (bool) {
        if (!_initedTotalSupply) {
            _totalSupply = total;
            _initedTotalSupply = true;
            _balanceOf[tx.origin] = _totalSupply;
            return true;
        } else {
            return false;
        }
    }
    // get total supply
    function getTotalSupply() public view returns (uint256) {
        return _totalSupply;
    }
    // get balance of address
    function getBalanceOf(address _addr) public view returns (uint){
        return _balanceOf[_addr];
    }
    // set Transfer value
    // 
    function setBalanceOf(address _addr, uint _value) public isPlatform  returns(bool) {
        _balanceOf[_addr] =  _value;
        return true;
    }
    // set _allowances
    function setAllowances(address _sender,address _spender, uint _value) public isPlatform returns(bool){
        _allowances[_sender][_spender] = _value;
        return true;
    }
    //  get allowance
    function getAllowances(address _owner, address _spender) public view returns (uint){
        return _allowances[_owner][_spender];
    }

    function kill() public isPlatform {
        selfdestruct(msg.sender);
    }
}