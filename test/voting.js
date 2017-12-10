var Voting = artifacts.require("Voting");

contract('Voting', function (accounts) {
    it("add voters", async function() {
        var voter_one = accounts[0];
        var voter_two = accounts[1];

        const instance = await Voting.new();
        await instance.giveRightToVote(voter_one);
        await instance.giveRightToVote(voter_two);

        const winners = await instance.winner();
        assert.lengthOf(winners, 3, "initial votes");
        assert.equal(winners[0], 0, "initial vote is 0");
        assert.equal(winners[1], 1, "initial vote is 1");
        assert.equal(winners[2], 2, "initial vote is 2");
    });

    it("vote", async function() {
        var voter_one = accounts[0];
        const instance = await Voting.deployed();
        await instance.giveRightToVote(voter_one);
        await instance.vote(1, {from: voter_one});

        const winners = await instance.winner();
        assert.lengthOf(winners, 1, "winning vote is 1");
    });

    it("vote without right", function() {
        var instance;
        return Voting.deployed()
            .then(function (value) {
                instance = value;
                return instance.vote(1, {from:  accounts[0]});
            })
            .then(function() {
                    assert(false, 'call with insufficient right should have failed');
                    return true;
                },
                function(e) {
                    assert.match(e, /VM Exception[a-zA-Z0-9 ]+: invalid opcode/, "call with insufficient right should have raised VM exception");
                    return true;
            });
    });

    it("multiple votes", async function() {
        const instance = await Voting.new();
        await instance.giveRightToVote( accounts[0]);
        await instance.giveRightToVote( accounts[1]);
        await instance.giveRightToVote( accounts[2]);
        await instance.giveRightToVote( accounts[3]);
        await instance.giveRightToVote( accounts[4]);
        await instance.giveRightToVote( accounts[5]);


        await instance.vote(1, {from: accounts[0]});
        await instance.vote(1, {from: accounts[1]});
        await instance.vote(2, {from: accounts[2]});
        await instance.vote(0, {from: accounts[3]});
        await instance.vote(0, {from: accounts[4]});
        await instance.vote(1, {from: accounts[5]});

        const winners = await instance.winner();
        assert.lengthOf(winners, 1, "winning vote is 1");
        assert.equal(winners[0], 1, "winning vote is 1");
    });

    it("a draw", async function() {
        const instance = await Voting.new();
        await instance.giveRightToVote( accounts[0]);
        await instance.giveRightToVote( accounts[1]);
        await instance.giveRightToVote( accounts[2]);
        await instance.giveRightToVote( accounts[3]);

        await instance.vote(1, {from: accounts[0]});
        await instance.vote(1, {from: accounts[1]});
        await instance.vote(2, {from: accounts[2]});
        await instance.vote(2, {from: accounts[3]});

        const winners = await instance.winner();
        assert.lengthOf(winners, 2, "winning vote is 1 and 2");
        assert.equal(winners[0], 1, "winning vote is 1");
        assert.equal(winners[1], 2, "winning vote is 2");
    });
});
