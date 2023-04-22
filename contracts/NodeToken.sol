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


    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// contract
contract NodeToken is ERC20 {
    string public name;
    string public symbol;
    string public decimals;
    uint256 public _totalSupply;

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;
    constructor() {
        symbol = "DTD";
        name = "Node Coin";
        decimals = 18;
        _totalSupply = 1_000_001_000_000_000_000_000_000; // A million + 1 coins, with 18 zeros for decimal points
        balances[0x23e59AFC03C76d2bC96a7d36cDE3003a159f1c6f] =  _totalSupply;
        emit Transfer(address(0), 0x23e59AFC03C76d2bC96a7d36cDE3003a159f1c6f, _totalSupply);
    } 

   
    function totalSupply() external view override returns (uint256) {
        return _totalSupply - balances[address(0)];
    }

    function balanceOf(address account) external view override returns (uint256) {
        return balances[account];
    }

    function allowance(address owner, address spender) external view override returns (uint256) {
        return allowed[owner][spender];
    }

    function transfer(address recipient, uint256 amount) external override returns (bool) {
        require(amount <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender] - amount;
        balances[recipient] = balances[recipient] + amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external override returns (bool) {
        allowed[msg.sender][spender] = amount;
        emit Approval(msg.se, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        require(amount <= balances[sender]);
        require(amount <= allowed[sender][msg.sender]);
        balances[msg.sender] = balances[msg.sender] - amount;
        allowed[sender][msg.sender] = allowed[sender][msg.sender] - amount;
        balances[recipient] = balances[recipient] + amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }
}