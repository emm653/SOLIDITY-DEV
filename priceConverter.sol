//SPDX-License-Identifier:MIT

pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
//this import interface is for the ABI of the priceFeed Oracle 



library priceConverter {

     function getPrice() internal view returns (uint256) {
       // 0x694AA1769357215DE4FAC081bf1f309aDC325306
       AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
      (, int256 answer , ,  , ) =priceFeed.latestRoundData();
      //price of ETH in terms of USD
      //The value of this priceFeed is in 8 decimals
      answer = answer * 1e10;
      //This is to make sure that both price and wei are the same decimal place ie 18 dp
      return uint256(answer);
      //This is called typeCasting..this is used to converts types from one type to another
      //we convert int256 to uint256 so that they can be the same type 
    }
    function getConversionRate(uint256 ethAmount) internal view returns(uint256) {
        uint256 ethPrice = getPrice();
        ethPrice = uint256(ethPrice);
        uint256 ethAmountInUSD;
        ethAmountInUSD = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUSD;
        
    }
    function getVersion() internal view returns (uint256) {
        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }
}
