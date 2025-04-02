// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Vote {

    address public owner;

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "No authorized");
        _;
    }

    modifier hasVoted(){
        require(voters[msg.sender] == false, "Already voted");
        _;
    }

    struct Candidate {
        string name;
        uint voteCount;
    }

    Candidate[] public candidates;

    mapping(address => bool) public voters;

    function addCandidate(string memory _name) private onlyOwner {
        candidates.push(Candidate(_name, 0));
    }

    function voting(uint _index) public hasVoted {
        candidates[_index].voteCount ++;
        voters[msg.sender] = true;
    }

    function getCandidates() public view returns(Candidate[] memory){
        return candidates;
    }

    function getWinner() private view onlyOwner returns(string memory){
        string memory winner;
        uint winnerCount = 0;
        for(uint i = 0; i<candidates.length; i++){
            if(candidates[i].voteCount > winnerCount){
                winner = candidates[i].name;
                winnerCount = candidates[i].voteCount;
            }
        }
        return winner;
    }

    function reset() public {
        for(uint i = 0; i<candidates.length; i++){
            delete candidates[i];
        }
    }

}