// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract CustodialContract is Ownable, ReentrancyGuard {
    constructor() public {}
    receive() external payable {}

    function withdrawCoin(address to) external nonReentrant onlyOwner returns (bool) {
        uint amount = address(this).balance;
        require(amount > 0 , "CustodialContract:No balance in contract.");
		(bool success,) = to.call{value : amount}("");
        return success;
    }

    function withdrawERC20Token(address token, address to) external nonReentrant onlyOwner {
        uint256 amount = IERC20(token).balanceOf(address(this));
        require(amount > 0, "CustodialContract:Insufficient ERC20 balance in contract.");
        IERC20(token).transfer(to, amount);
    }
}

contract CasinoBankRoll is Ownable, ReentrancyGuard {
    mapping (bytes32 => address) private addressTracker;
    // CustodialContract public custodialWallet;

    event WithdrawedFromContract(address to, uint256 amount);
    event WithdrawedFromCustodialWallet(address from, address to);
    event WithdrawedERC20FromCustodialWallet(address from, address to, address token);

    constructor() public {}
    
	receive() external payable {}

    function createCustodialWallet(string memory data) external onlyOwner returns (address) {
        CustodialContract custodialWallet = new CustodialContract();

        addressTracker[keccak256(abi.encodePacked(data))] = address(custodialWallet);
        return address(custodialWallet);
    }

    function withdrawFromContract(address to, uint256 amount) external nonReentrant onlyOwner {
        require(amount < address(this).balance, "CasinoBankRoll:Insufficient funds to withdraw.");
		(bool success,) = to.call{value : amount}("");

        if (success) {
            emit WithdrawedFromContract(to, amount);
        }
    }

    function withdrawFromCustodialWallet(string memory data, address payable from, address to) external nonReentrant onlyOwner {
        require(addressTracker[keccak256(abi.encodePacked(data))] == from, "CasinoBankRoll:No matched address");
        CustodialContract(from).withdrawCoin(to);

        emit WithdrawedFromCustodialWallet(from, to);
    }

    function withdrawERC20FromCustodialWallet(string memory data, address payable from, address to, address token) external nonReentrant onlyOwner {
        require(addressTracker[keccak256(abi.encodePacked(data))] == from, "CasinoBankRoll:No matched address");
        CustodialContract(from).withdrawERC20Token(token, to);

        emit WithdrawedERC20FromCustodialWallet(from, to, token);
    }

    function getCustodialWallet(string memory data) external view returns (address) {
        return addressTracker[keccak256(abi.encodePacked(data))];
    }
}
