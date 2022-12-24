//SPDX -License - identifier : UNLICENESED 
pragma solidity >=0.5.0 <0.9.0 ; 




//initally the price is higher then with time if there is no buyer then the price is decreased , and it is done until there is someone intrested in buying 
//can be used in selling some item like a coat 

interface IERC721 
{
    function transferFrom (
        address _from , 
        address _to ,
        uint256 _nftId 
    ) external ;
} 


contract DutchAuction 
{
    uint private constant DURATION = 7  days ;

    IERC721 public immutable nft ;     // the variable cant be altered during the sale  .
    uint public immutable nftId ;
    address payable public immutable seller ;
    uint public immutable startingPrice ;
    uint pubic immutable startAt ;
    uint public immutable expireAt ;
    uint public immutable discountRate ;
   
    constructor(
        uint _startPrice ;
        uint _discountRate;
        address _nft ; 
        uint _nftId ;

    )
    {
     
        seller = payable(msg.sender) ;
        startingPrice= _startingPrice ;
        discountRate = _discountRate ;
        startAt = block.timestamp ;
        expiresAt = block.timestamp +DURATION ;

       require (
           _startingPrice  >= _discountRate*DURATION , "STARTING PRICE IS LESS THAN DISCOUNT  "   ///OTHERWISE the item will be free 
       );

        nft = IERC721 (_nft) ;
        nftId = _nftId ;
    }
     
     function getPrice() public view returns (uint)   // fucntion to calculate the price 
     {
        uint timeElapsed = block.timestamp- startAt ;
         uint discount = discountRate *timeElapsed ;
         return startingPirce- discount ;

     }

     function buy() external payable {                //
         require(block.timestamp < expiresAt);
         uint price = getPrice() ;
         require(msg.value >= price , "eth <price ");
         ntf.transferFrom(seller, msg.sender , nftId) ;
         uint refund = msg.value - price ;   ///if buyer pays more eth than price
         if (refund > 0)
         {
             payable(msg.sender).transfer(refund) ;

         }
         selfdestruct(seller) ; //send all the eth to seller and close the contract  


     }

}
