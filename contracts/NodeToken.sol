// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

/// @author Doan Trung Dung
// ERC Token Standard #20 Interface
interface ERC20 {

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function burn(uint256 _value) external returns (bool);

    event ChangeOwner(address indexed _from, address indexed _to);
    event Burn(address indexed from, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// contract
contract NodeToken is ERC20 {
    address private owner;
    string private name;
    uint256 private money;
    uint256 private _totalSupply;

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;

    constructor(uint256 _money) {
        owner = msg.sender;
        name = "Node Coin";
        balances[msg.sender] = _money;
        _totalSupply = 1_000_001_000_000_000_000_000_000; // A million + 1 coins, with 18 zeros for decimal points
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        // Underscore is a special character only used inside
        // a function modifier and it tells Solidity to
        // execute the rest of the code.
        _;
    }

    modifier validAddress(address _addr) {
        require(_addr != address(0), "Not valid address");
        _;
    }

    function changeOwner(
        address _newOwner
    ) public onlyOwner validAddress(_newOwner) {
        owner = _newOwner;
        emit ChangeOwner(msg.sender, _newOwner);
    }

    function totalSupply() external view returns (uint256) {
        return _totalSupply - balances[address(0)];
    }

    function balanceOf(address _account) external view returns (uint256) {
        return balances[_account];
    }

    function transfer(
        address _recipient,
        uint256 _amount
    ) external returns (bool) {
        require(balances[msg.sender] >= _amount);
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;
        emit Transfer(msg.sender, _recipient, _amount);
        return true;
    }

    function approve(
        address _spender,
        uint256 _amount
    ) external returns (bool) {
        allowed[msg.sender][_spender] = _amount;
        emit Approval(msg.sender, _spender, _amount);
        return true;
    }

    function burn(uint256 _value) external returns (bool) {
        require(balances[msg.sender] >= _value, "Insufficient balance");
        balances[msg.sender] -= _value;
        _totalSupply -= _value;
        emit Burn(msg.sender, _value);
        return true;
    }

    function transferFrom(
        address _sender,
        address _recipient,
        uint256 _amount
    ) external returns (bool) {
        require(balances[_sender] >= _amount, "Not enough money to transfer");
        require(allowed[_sender][msg.sender] > _amount);
        balances[msg.sender] -= _amount;
        allowed[_sender][msg.sender] -= _amount;
        balances[_recipient] += _amount;
        emit Transfer(_sender, _recipient, _amount);
        return true;
    }

    function allowance(
        address _owner,
        address _spender
    ) external view override returns (uint256) {}
}