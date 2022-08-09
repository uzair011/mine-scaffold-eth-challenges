// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
    event SellTokens(
        address seller,
        uint256 amountOfETH,
        uint256 amountOfTokens
    );
    YourToken public yourToken;
    uint256 public constant tokensPerEth = 100;

    constructor(address tokenAddress) {
        yourToken = YourToken(tokenAddress);
    }

    // ToDo: create a payable buyTokens() function:
    function buyTokens() public payable returns (uint256) {
        //! first
        require(msg.value > 0, "Spend some ethers...");

        uint256 _amountOfTokens = msg.value * tokensPerEth;

        yourToken.transfer(msg.sender, _amountOfTokens);
        emit BuyTokens(msg.sender, msg.value, _amountOfTokens);
        return _amountOfTokens;
    }

    // ToDo: create a withdraw() function that lets the owner withdraw ETH
    function withdraw() public onlyOwner {
        //! second
        uint256 contractOwnerBalance = address(this).balance;
        //require(msg.sender == owner, "Only owner can withdraw the money.");
        (bool callSuccess, ) = payable(msg.sender).call{
            value: contractOwnerBalance
        }("");
        //  (bool callSuccess, ) = payable(msg.sender).call{
        //     value: address(this).balance
        // }("");

        require(callSuccess, "ETH Withdraw failed!");
    }

    // ToDo: create a sellTokens(uint256 _amount) function:
    function sellTokens(uint256 _amount) external {
        //yourToken.approve(msg.sender, _amount);
        uint256 payingAmount = _amount / tokensPerEth;
        bool callSuccess = yourToken.transferFrom(
            msg.sender,
            address(this),
            _amount
        );
        // (bool callSuccess, ) = payable(msg.sender).call{value: payingAmount}(
        //     ""
        // );
        (callSuccess, ) = msg.sender.call{value: payingAmount}("");
        require(callSuccess, "Failed to sell tokens...:(");
        emit SellTokens(msg.sender, _amount, payingAmount);
    }
}
