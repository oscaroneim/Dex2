// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;
pragma experimental ABIEncoderV2;

import "./wallet.sol";

contract Dex is Wallet {

     using SafeMath for uint256;

      enum Side { 
        BUY,
        SELL
     }

     uint nextOrderId = 0;

     struct Order {
        uint id;
        address trader;
        Side side;
        bytes32 ticker;
        uint amount;
        uint price;
     }

     mapping(bytes32 => mapping(uint => Order[]))public orderBook;

     function getOrderBook(bytes32 ticker, Side side)view public returns(Order[] memory){
          return orderBook[ticker][uint(side)];
     }

     function bubbleSort()public pure returns(Order[] memory){

          Order[] memory orders;

          uint length = orders.length;

          for(uint i=0; i<orders.length; i++){
          for(uint j=0; j<orders.length; j++){
              if(side == Side.BUY){
               uint currentValue = orders[j];
               orders[j] = orders[j+1];
               orders[j+1] = currentValue;
              }
             }
          }
         return orders;
              
     }

    function createLimitOrder(Side side, bytes32 ticker, uint price, uint amount)public {
          if(side == Side.BUY){
            require(balances[msg.sender]["ETH"] >= amount.mul(price)); //this makes sure that there is enough ETH in the BUY side account before executing 
          }
          else if(side == Side.SELL){
            require(balances[msg.sender][ticker] >= amount.mul(price)); ////this makes sure that there is enough ETH in the SELL side account before executing
    }
    
     Order[] storage orders = orderBook[ticker][uint(side)]; //created an array to push the limit orders into.

     orders.push(
      Order(nextOrderId, msg.sender, side, ticker, amount, price) //nextOrderId was created to fill the id criteria for the Order struct. This pushes the orders into the array but not in any order.
     );


    

}
}





/* //BUBBLE SORT

     uint length = orders.length;

     if(side == Side.BUY){
      
      

     }
     else if(side == Side.SELL){

     }

     nextOrderId++; //this code moves on to the next order*/