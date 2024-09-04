// WHAT DOES THIS CONTRACT DO?
//GET FUNDS FROM THE USERS
//ALLOW WITHDRAWALS INTO THE CREATOR'S WALLET
//SET A MINIMUM FUNDING VALUE IN USD


//SPDX-License-Identifier:MIT

pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
//this import interface is for the ABI of the priceFeed Oracle 
import {priceConverter} from "./PriceConverter.sol";


contract fundMe {

    using priceConverter for uint256;

    uint public constant minimumUSD = 5e18;
    address public owner;
    
    constructor(){
        owner = msg.sender;
    }
    address[] public funders;
    mapping(address funder => uint256 amountInUsd) public addressToUSD;
        function fund() public payable {
        // Allow users to send USD
        //Have a minimum USD sent
        //so how do we send ETH to this contract?
        //THE LEAST AMOUNT IS 1 ETH
    
       require(msg.value.getConversionRate() >= minimumUSD , "YOU DIDNT SEND AT LEAST 5 USD!"); 
       //msg.value is now uint256 ethAmount whic is now in USD not wei thanks to getConversionRate()
        //where 1 ETH= 1000000000000000000 = 1 * 10 **18 wei
        //pls note that similarly to wallets , contracts can also hold funds
        //The value of wei is in 18 decimals
    funders.push(msg.sender);
    addressToUSD[msg.sender] = addressToUSD[msg.sender] + msg.value;
    //where msg.value is a global variable is the amount in wei being sent by a contract or EOA

    } 
    function withdraw() public onlyOwner{
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToUSD[funder] = 0;
            //this is for resetting the mapping
        }
        //now we want to reset the array
        funders = new address [] (0) ;
        //how to resend eth from a contract
        //transfer
        //call
        //send
        // 785172 765023
        //using transfer
       // payable(msg.sender).transfer(address(this).balance);

        //using send
        //bool sendSuccess = payable(msg.sender).send(address(this).balance);
        //require(sendSuccess = true , "NOT ENOUGH GAS!");

        //using call
         (bool callSuccess ,) = payable(msg.sender).call{value: address(this).balance}("");
         require(callSuccess = true, "CALL FAILED!");
         }
         modifier onlyOwner() {
            require(msg.sender == owner , "YOU CANNOT WITHDRAW THE FUNDS!");
            _;
         }
         receive() external payable{
            fund();
         }
         fallback() external payable{
            fund;
         }
}
