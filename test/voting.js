var Voting = artifacts.require("Voting");

contract('Voting', function (accounts) {
    it("create ballot", function () {
        return Voting.deployed().then(function (instance) {
            return instance.addBallot.call(10);
        }).then(function(ballotId) {
            assert.equal(ballotId.valueOf(), 1, "1 wasn't in the first account");
        });
    });

    it("add voter", function () {
        /*
        var voting;
        var ballotId;
        var voter_one = accounts[0];
        var voter_two = accounts[1];
        */
        /*
        return Voting.deployed().then(function (instance) {
            voting = instance;
            return voting.addBallot.call(10);
        })
            .then(function(_ballotId) {
            ballotId = _ballotId;
            return voting.getBallot.call(1);
        })
        */
        return Voting.deployed().then(function (instance) {
            return instance.getBallot();
        }).then(function(ballot) {
            console.log("ballot: " + ballot);
        })
    });
});
