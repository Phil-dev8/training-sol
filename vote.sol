// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Vote {
    
    address private owner;
    address [] public votersAddress;
    uint public startTime;
    uint immutable DURATION;
    uint public endTime = startTime + DURATION;

    constructor(uint _durationInDays){
        owner = msg.sender;
        DURATION = _durationInDays * 86400;
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

    function addCandidate(string memory _name) public onlyOwner {
        candidates.push(Candidate(_name, 0));
    }

    function vote(uint _index) public hasVoted {
        require(_index < candidates.length, "Index inconnu");
        candidates[_index].voteCount ++;
        voters[msg.sender] = true;
        votersAddress.push(msg.sender);
    }

    function getCandidates() public view returns(Candidate[] memory){
        return candidates;
    }

    function getWinner() public view onlyOwner returns(string memory){
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

    function reset() public onlyOwner{
        for(uint i = 0; i < candidates.length; i++){
            delete candidates[i];
        }
        for(uint j = 0; j < votersAddress.length; j++){
           delete voters[votersAddress[j]];
        }
        delete votersAddress;
    }

}