pragma solidity ^0.8.0;

contract BountyBoard {
    struct Bounty {
        string description;
        uint256 reward;
        address payable creator;
        bool claimed;
    }

    mapping(uint256 => Bounty) public bounties;
    uint256 public bountyCount;

    event BountyCreated(uint256 bountyId, string description, uint256 reward, address creator);
    event BountyClaimed(uint256 bountyId, address claimant);

    function createBounty(string memory _description) external payable {
        require(msg.value > 0, "Reward must be greater than zero");
        
        bounties[bountyCount] = Bounty({
            description: _description,
            reward: msg.value,
            creator: payable(msg.sender),
            claimed: false
        });
        
        emit BountyCreated(bountyCount, _description, msg.value, msg.sender);
        bountyCount++;
    }

    function claimBounty(uint256 _bountyId) external {
        Bounty storage bounty = bounties[_bountyId];
        require(!bounty.claimed, "Bounty already claimed");
        require(bounty.reward > 0, "Invalid bounty");
        
        bounty.claimed = true;
        payable(msg.sender).transfer(bounty.reward);
        
        emit BountyClaimed(_bountyId, msg.sender);
    }
}
