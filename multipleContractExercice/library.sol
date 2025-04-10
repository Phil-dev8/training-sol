// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Book.sol";

contract Library {

    address public owner;

    constructor(){
        owner = msg.sender;
    }

    enum UserType {User, Admin}

    struct User {
        string name;
        UserType role;    
        uint bookBorrowedCounter;
        uint bookDownloadedCounter;
        Book [] booksReaded;
    }

    mapping(address => User) public users;

    modifier onlyAdmin(){
        require(users[msg.sender].role == UserType.Admin, "Not authorized");
        _;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "Not authorized");
    }

    function addUser(string memory _name) private onlyAdmin() {
        Book[] memory books = new Book[](0);
        users[msg.sender] = User(_name, UserType.User, 0, 0, books);
    }

    function addAdmin(string memory _name) private onlyOwner(){
        Book[] memory books = new Book[](0);
        users[msg.sender] = User(_name, UserType.Admin, 0, 0, books);
    }



}