pragma solidity ^0.4.17;


contract Voting {
    event BallotAdded(address creater, uint  ballotId);
    event Voted(address voter, uint ballotId);

    uint constant ZERO = 0;


    // This will be assigned at the construction phase, where `msg.sender` is the account creating this contract.
    address public chairman = msg.sender;

    ballot[] ballots;

    struct ballot {
        uint end;
        uint[3] votes;
        mapping (address => bool) voters;
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

    function addBallot(uint daysAfter) public restricted {
        uint timestamp = now + daysAfter * 1 days;
        uint[3] memory empty = [ZERO,ZERO,ZERO];

        uint id = ballots.push(ballot(timestamp, empty));
        BallotAdded(msg.sender, id);
    }

    function giveRightToVote(uint ballotId, address voter) public restricted validBallot(ballotId) {
        ballots[ballotId].voters[voter] = true;
    }

    function vote(uint ballotId, uint value) validBallot(ballotId) public validVote(ballotId, value) {
        require(ballots[ballotId].voters[msg.sender]);
        // prevent voting for a second time
        ballots[ballotId].voters[msg.sender] = false;
        ballots[ballotId].votes[value] += 1;
        Voted(msg.sender, ballotId);
    }

    function voteResult(uint ballotId) view validBallot(ballotId) public returns (uint[3] result) {
        // check if ballot is ended
        require(ballots[ballotId].end <= now);
        result = ballots[ballotId].votes;
    }

    function winner(uint ballotId) view validBallot(ballotId) public returns (uint[3] winners) {
        // check if ballot is ended
        require(ballots[ballotId].end <= now);

        uint winningVoteCount = 0;
        uint winnersCounter = 0;
        for (uint v = 0; v < ballots[ballotId].votes.length; v++) {
            //  is there a draw?
            if (ballots[ballotId].votes[v] == winningVoteCount) {
                winners[winnersCounter] = v;
            }
            if (ballots[ballotId].votes[v] > winningVoteCount) {
                winningVoteCount = ballots[ballotId].votes[v];
                winners = clear(winners);
                winnersCounter = 0;
                winners[winnersCounter] = v;
            }
        }
    }

    function clear (uint[3] votes) internal pure returns (uint[3] result) {
        for (uint i = 0; i < votes.length; i++) {
            result[i] = ZERO;
        }
    }
}