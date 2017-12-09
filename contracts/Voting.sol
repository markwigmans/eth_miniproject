pragma solidity ^0.4.16;

/*
A minimal voting contract with the following intended vote flow:

1) the chairman creates the contract;
2) the chairman add voters to the contract via function: giveRightToVote(address);
3) the voters votes via the function: vote(uint8): the allowed vote values are: 0, 1 or 2;
4) the chairman determines the voting result via the function winner().

By design of this 'minimal voting contract,' the chairman can add voters to the Voting for a second, etc. time,
when the voter has already voted. Also the Voting has no explicit end, so the winner() function can also be used to
calculate the 'intermediate voting result'.
*/
contract Voting {
    // event send when a voter actual votes
    event Voted(address voter);

    // the owner/manager of this contract
    address chairman;
    // who is allowed to vote
    mapping(address => bool) voters;
    // the vote values for the vote options: 0,1,2
    uint[3] votes;

    // allow a method call only by the owner of the contract
    modifier restricted() {
        require(msg.sender == chairman);
        _;
    }

    // Constructor
    function Voting() public {
        chairman = msg.sender;
    }

    // Give a potential voter the right to vote
    function giveRightToVote(address _voter) public restricted {
        voters[_voter] = true;
    }

    // Perform a vote by the sender
    function vote(uint8 value) public {
        // validate if the vote value is in the correct range
        require(value >= 0 && value <= 2);
        // validate if the voter is allowed to vote
        require(voters[msg.sender]);

        // prevent voting for a second time by the same voter
        voters[msg.sender] = false;
        // update vote counter
        votes[value] += 1;

        // send event to the GUI
        Voted(msg.sender);
    }

    /*
    Determine the winner of the voting. As there can be a draw between different vote results,
    the end result is an array of the vote values that is/are the winner.

    So if the vote result = [10,4,10] then the winning votes are [0,2] and
    if the vote result = [10,40,20] then the winning vote is [1].
    */
    function winner() view public restricted returns (uint[] winners) {
        int winningVote = -1;
        // start with an impossible value for an uint.
        uint counter = 0;
        // the number of vote records found with the 'winningVote' value.

        // find winning vote value
        for (uint8 w = 0; w < votes.length; w++) {
            // check if there is a draw
            if (int(votes[w]) == winningVote) {
                counter++;
            }
            // higher vote value available?
            if (int(votes[w]) > winningVote) {
                winningVote = int(votes[w]);
                counter = 1;
            }
        }

        // create result by creating an array of all vote result with the maximum value.
        winners = new uint[](counter);
        uint resultCounter = 0;
        for (uint8 v = 0; v < votes.length; v++) {
            if (int(votes[v]) == winningVote) {
                winners[resultCounter++] = v;
            }
        }
    }
}