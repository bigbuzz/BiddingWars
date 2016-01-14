contract BiddingWars {
    
    // Changed 
    // Changes 2

    struct Bidder
    {
        address entity;         // Person or business entity 
        bool isCashBuyer;       // cash buyer may have priority
    }
      
    // variables 
    address public propertyOwner;       // Property owner
    address public highestBidder;       // 
    uint public highestBid;             //
    uint public auctionStart;           // Do not accept bids before this time
    uint public biddingTime;
    bool ended;
    
    mapping (address => Bidder) public Bidders;   // current bids - public

    // Events that will be fired on changes.
    event HighestBidIncreased(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount);

    // Constructor - runs once on contract creation
    function BiddingWars() 
    {
        propertyOwner = msg.sender;
    }
    
    // Create auction
    function CreateAuction(uint _biddingTime, address _propertyOwner) {
        propertyOwner = _propertyOwner;
        auctionStart = now;
        biddingTime = _biddingTime;
    }

    /// Bid on the auction with the value sent
    /// together with this transaction.
    /// The value will only be refunded if the
    /// auction is not won.
    function makeBid() {
        
        // remember the bidder
        Bidders[msg.sender] = Bidder(msg.sender,false);
        
        // No arguments are necessary, all
        // information is already part of
        // the transaction.
        if (now > auctionStart + biddingTime)
            // Revert the call if the bidding
            // period is over.
            throw;
        if (msg.value <= highestBid)
            // If the bid is not higher, send the
            // money back.
            throw;
        if (highestBidder != 0)
            highestBidder.send(highestBid);
        highestBidder = msg.sender;
        highestBid = msg.value;
        HighestBidIncreased(msg.sender, msg.value);
    }

    /// End the auction and send the highest bid
    /// to the beneficiary.
    function auctionEnd() {
        if (now <= auctionStart + biddingTime)
            throw; // auction did not yet end
        if (ended)
            throw; // this function has already been called
        AuctionEnded(highestBidder, highestBid);
        // We send all the money we have, because some
        // of the refunds might have failed.
        propertyOwner.send(this.balance);
        ended = true;
    }


    // publically available after the sale is made
    function getFinalPrice() public returns (uint retVal) {
        if (ended) 
            return highestBid;
        else
            return 0;
    }

    function () {
        // This function gets executed if a
        // transaction with invalid data is sent to
        // the contract or just ether without data.
        // We revert the send so that no-one
        // accidentally loses money when using the
        // contract.
        throw;
    }

}