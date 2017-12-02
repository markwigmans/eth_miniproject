pragma solidity ^0.4.17;


/// @@title Voting with Ballots
contract Voting {
    event BallotAdded(address creater, uint  ballotId);
    event Voted(address voter, uint ballotId);


    // This will be assigned at the construction phase, where `msg.sender` is the account creating this contract.
    address public chairman = msg.sender;

    Ballot[] ballots;

    struct Ballot {
        mapping (address => bool) voters;
        uint[3] votes;
        uint end;
    }

    modifier restricted() {
        require(msg.sender == chairman);
        _;
    }

    modifier validBallot(uint ballotId) {
        require(ballotId >= 0 && ballotId < ballots.length);
        _;
    }

    modifier validVote(uint ballotId, uint vote) {
        require(vote >= 0 && vote <= 2);
        require(ballots[ballotId].end > now);
        _;
    }

    function addBallot(uint daysAfter) restricted {
        uint id = ballots.push(Ballot({end: now + daysAfter * 1 days}));
        BallotAdded(msg.sender, id);
    }

    function giveRightToVote(uint ballotId, address voter) restricted validBallot(ballotId) {
        ballots[ballotId].voters[voter] = true;
    }

    function vote(uint ballotId, uint vote) validBallot(ballotId) validVote(ballotId, vote) {
        require(ballots[ballotId].voters[msg.sender]);
        // prevent voting for a second time
        ballots[ballotId].voters[msg.sender] = false;
        ballots[ballotId].votes[vote] += 1;
        Voted(msg.sender, ballotId);
    }

    function winner(uint ballotId) constant validBallot(ballotId) returns (uint[] winners) {
        // check if ballot is ended
        require(ballots[ballotId].end <= now);

        uint winningVoteCount = -1; // initialize with impossible value
        for (uint v = 0; v < ballots[ballotId].votes.length; v++) {
            if (ballots[ballotId].votes[v] > winningVoteCount) {
                winningVoteCount = ballots[ballotId].votes[v];
                winners = new uint[](0);
                winners.push(v);
            }
            //  is there a draw?
            if (ballots[ballotId].votes[v] == winningVoteCount) {
                winners.push(v);
            }
        }
    }
}