contract BiddingWar {
    
    // variables 
    address public propertyOwner;                   // Property owner
    mapping (address => uint) public currentBids;   // current bids - public
    mapping (address => uint) maximumBids;          // maximum bid - not public
    mapping (address => bool) isCashBuyer;          // cash buyers - not public
    bool sold;    
    uint priceSold;
    address auctionWinner;

    // Constructor - runs once on contract creation
    function BiddingWar() 
    {
        propertyOwner = msg.sender;
    }
    
    // called by a bidder
    function MakeBid (address bidder, uint currentBid, uint maximumBid, bool payingCash) 
    {
        
        // Prevent property owner from shilling 
        if (msg.sender != propertyOwner) {
        
            currentBids[bidder] = currentBid;
            maximumBids[bidder] = maximumBid;
            isCashBuyer[bidder] = payingCash;
        }
    }
    
    // called by the bidder
    function RetractBid (address bidder) {
        
        // Can only retract own bid
        if (msg.sender == bidder) {
            currentBids[bidder] = 0;
            maximumBids[bidder] = 0;
        }
    }
    
    // called by the owner to accept highest bid
    function AcceptHighestBid () constant 
        returns (uint priceSold)
        
        // For now, simply accept maximum bid
    {
        uint maximumPrice = 0;
        
        // Is this the way to iterate over mappings ?
        for (uint i = 0; i < currentBids.length; i++)
        {
            if (currentBids[i] > maximumPrice)
            {
                maximumPrice = currentBids[i];
                auctionWinner = i;
            }
        }
        
        sold = true;
        return maximumPrice;
    }
    
    
    
    // publically available after the sale is made
    function getFinalPrice() public returns (uint retVal) {
        if (sold) 
            return priceSold;
        else
            return 0;
    }

}
