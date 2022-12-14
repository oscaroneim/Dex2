// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Wallet is Ownable{
using SafeMath for uint256;

struct Token{
    bytes32 ticker;
    address tokenAddress;
}

mapping(bytes32 => Token)public tokenMapping;
mapping(address => mapping(bytes32 => uint256))public balances;

bytes32[]public tokenList;

function addToken(bytes32 ticker, address tokenAddress) external onlyOwner {
    tokenMapping[ticker] = Token(ticker, tokenAddress);
    tokenList.push(ticker);
}

function deposit(uint256 amount, bytes32 ticker )external {
    IERC20(tokenMapping[ticker].tokenAddress).transferFrom(msg.sender, address(this), amount);
    balances[msg.sender][ticker] = balances[msg.sender][ticker].add(amount);

}

function withdraw(uint amount, bytes32 ticker) tokenExist(ticker) external {
        require(balances[msg.sender][ticker] >= amount,'Insuffient balance'); 
        balances[msg.sender][ticker] = balances[msg.sender][ticker].sub(amount);
        IERC20(tokenMapping[ticker].tokenAddress).transfer(msg.sender, amount);
}

    function depositEth() payable external {
        balances[msg.sender][bytes32("ETH")] = balances[msg.sender][bytes32("ETH")].add(msg.value);
    }
    
    function withdrawEth(uint amount) external {
        require(balances[msg.sender][bytes32("ETH")] >= amount,'Insuffient balance'); 
        balances[msg.sender][bytes32("ETH")] = balances[msg.sender][bytes32("ETH")].sub(amount);
        msg.sender.call{value:amount};
    }

    modifier tokenExist(bytes32 ticker){
    require(tokenMapping[ticker].tokenAddress != address(0));
    _;
}


}