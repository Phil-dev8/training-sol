// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Vote {
    
    address private owner;
    address [] public votersAddress;
    uint public startTime;
    uint immutable DURATION;
    uint public endTime;

    constructor(uint _durationInDays){
        owner = msg.sender;
        startTime = block.timestamp;
        DURATION = _durationInDays * 86400;
        endTime = startTime + DURATION;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "No authorized");
        _;
    }

    modifier hasVoted(){
        require(voters[msg.sender] == false, "Already voted");
        _;
    }

    modifier checkTime(){
        require(block.timestamp < endTime, "Vote closed");
        _;
    }

    struct Candidate {
        string name;
        uint voteCount;
    }

    Candidate[] public candidates;

    mapping(address => bool) public voters;
    mapping(address => uint) public forWho;


    function addCandidate(string memory _name) public onlyOwner {
        candidates.push(Candidate(_name, 0));
    }

    function vote(uint _index) public checkTime hasVoted {
        require(_index < candidates.length, "Index inconnu");
        candidates[_index].voteCount ++;
        voters[msg.sender] = true;
        votersAddress.push(msg.sender);
        forWho[msg.sender] = _index;
    }

    function knowVote(address _address) public view returns(uint){
        require(voters[_address], "Not voted");
        return forWho[_address];
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

    function premiumVote(uint _index, uint _amount) public payable hasVoted {
        require(msg.value == _amount, "montant invlaide");
        if(_amount > 0.01 ether){
            candidates[_index].voteCount + 2;
            voters[msg.sender] = true;
            votersAddress.push(msg.sender);
            forWho[msg.sender] = _index;
        } else if (_amount < 0.05 ether) {
            candidates[_index].voteCount + 5;
            voters[msg.sender] = true;
            votersAddress.push(msg.sender);
            forWho[msg.sender] = _index;
        } else {
            vote(_index);
            return;
        }
    }

}