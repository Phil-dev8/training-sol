// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract crowFunding {

    address public owner;
    
    constructor(){
        owner = msg.sender;
    }

    event Participated(address indexed particpant, uint amount);
    event Refund(address indexed participant, uint amount);
    event Creation(address indexed creator, uint date);

    modifier onlyOwner(){
        require(msg.sender == owner, "Not authorized");
        _;
    }

    struct Project {
        string name;
        string description;
        uint objective;
        uint pool;
        uint duration;
        uint startTime;
        address payable balance;
        address payable owner;
        address[] contributors;
        bool isActive;
    }

    mapping(uint => Project) public projects;

    function calculDuration(uint _num) private pure returns(uint) {
        require(_num > 0, "Minimum 1 day");
        return _num * 86400;
    }

    function createProject(string memory _name, string memory _description, uint _objective, uint _duration, address _balance) public {
        uint id = uint(keccak256(abi.encodePacked(_name, block.timestamp)));
        address[]memory contributors;
        _duration = calculDuration(_duration);
        projects[id] = Project(_name, _description, _objective, 0, _duration, block.timestamp, payable(_balance), payable(msg.sender), contributors, true); 
        emit Creation(msg.sender, block.timestamp);
    }

    function contribute(uint _id, uint _amount) public payable {
        require(_amount > 0, "Invalid amount");
        projects[_id].balance.transfer(_amount);
        projects[_id].pool += _amount;
        projects[_id].contributors.push(msg.sender);
        emit Participated(msg.sender, _amount);
    }

    function manageFunds(uint _id) public payable onlyOwner {
        if(block.timestamp > projects[_id].startTime + projects[_id].duration && projects[_id].pool < projects[_id].objective){
            // logique a coder pour rembourser les contributeurs si l'objectif de collecte n'est pas réalisé


        } else if(projects[_id].pool >= projects[_id].objective && block.timestamp >= projects[_id].duration && projects[_id].isActive == true) {
            projects[_id].isActive = false;
            projects[_id].owner.transfer(projects[_id].pool);
        } else {
            return;
        }

    }

    function addExtraTime(uint _id, uint _day) public {
        require(msg.sender == projects[_id].owner, "Not authorized");
        uint extraTime = _day * 86400;
        projects[_id].duration += extraTime;
    }

    function checkProjectStatus(uint _id) public view returns(bool){
        return projects[_id].isActive;
    }



    //if(block.timestamp > projects[_id].startTime + projects[_id].duration && projects[_id].pool < projects[_id].objective){}

    






















}