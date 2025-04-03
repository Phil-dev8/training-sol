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

    modifier onlyAdmin(uint _id) {
        require(msg.sender == projects[_id].owner, "Not auhtorized");
        _;
    }

    struct Project {
        string name;
        string description;
        uint objective;
        uint pool;
        uint duration;
        uint startTime;
        uint endTime;
        address payable balance;
        address payable owner;
        Contributor[] contributors;
        bool isActive;
    }

    struct Contributor {
        address payable addressOfContributor;
        uint amount;
    }

    mapping(uint => Project) public projects;

    function calculDuration(uint _num) private view returns(uint[3] memory) {
        require(_num > 0, "Minimum 1 day");
        uint startTime = block.timestamp;
        uint duration = _num * 86400;
        uint endTime = startTime + duration;
        uint[3] memory result = [startTime, duration, endTime];
        return result;
    }

    function createProject(string memory _name, string memory _description, uint _objective, uint _duration, address _balance) public {
        uint id = uint(keccak256(abi.encodePacked(_name, block.timestamp)));
        Contributor[]memory contributors;
        uint[3] memory time = calculDuration(_duration);       
        projects[id] = Project(_name, _description, _objective, 0, time[1], time[0], time[2], payable(_balance), payable(msg.sender), contributors, true); 
        emit Creation(msg.sender, block.timestamp);
    }

    function contribute(uint _id) public payable {
        require(msg.value > 0, "Invalid amount");
        projects[_id].balance.transfer(msg.value);
        projects[_id].pool += msg.value;
        projects[_id].contributors.push(Contributor(payable(msg.sender), msg.value));
        emit Participated(msg.sender, msg.value);
    }

    function manageFunds(uint _id) public payable onlyOwner {
        if(block.timestamp > projects[_id].endTime && projects[_id].pool < projects[_id].objective){
            for(uint i = 0; i < projects[_id].contributors.length; i++) {
                projects[_id].contributors[i].addressOfContributor.transfer(projects[_id].contributors[i].amount);
                emit Refund(projects[_id].contributors[i].addressOfContributor, projects[_id].contributors[i].amount);
            }
        } else if(projects[_id].pool >= projects[_id].objective && block.timestamp >= projects[_id].endTime && projects[_id].isActive == true) {
            projects[_id].isActive = false;
            projects[_id].owner.transfer(projects[_id].pool);
        } else {
            return;
        }

    }

    function addExtraTime(uint _id, uint _day) public onlyAdmin(_id){
        uint extraTime = _day * 86400;
        projects[_id].duration += extraTime;
    }

    function closeCollect(uint _id) public onlyAdmin(_id){
        projects[_id].isActive = false;
    }

    function checkProjectStatus(uint _id) public view returns(string memory){
        string memory result;
        if(projects[_id].isActive){
            result = "Project is loading";
        } else {
            result = "Project finished";
        }
        return result;
    }

}