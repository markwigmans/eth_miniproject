var Voting = artifacts.require("Voting");

contract('Voting', function (accounts) {
    it("add voters", function () {
        var voting;
        var voter_one = accounts[0];
        var voter_two = accounts[1];
        return Voting.deployed().then(function (instance) {
            voting = instance;
            return voting.giveRightToVote.call(voter_one)
        }).then(function () {
            return voting.giveRightToVote.call(voter_two)
        }).then(function (winners) {
            assert.lengthOf(winners, 3, "initial votes");
        })
    });

    it("vote", function () {
        var voting;
        var voter_one = accounts[0];
        return Voting.deployed().then(function (instance) {
            voting = instance;
            return voting.giveRightToVote(voter_one)
        }).then(function () {
            return voting.vote(1, {from: voter_one});
        }).then(function (winners) {
            console.log(winners);
            assert.lengthOf(winners, 1, "winning vote is 1");
        })
    });
});
