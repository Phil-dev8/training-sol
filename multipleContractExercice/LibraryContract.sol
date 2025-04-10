// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Book.sol";

contract LibraryContract {

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
        BookStruct [] booksReaded;
    }

    mapping(address => User) public users;

    modifier onlyAdmin(){
        require(users[msg.sender].role == UserType.Admin, "Not authorized");
        _;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "Not authorized");
        _;
    }

    function addUser(string memory _name) private onlyAdmin() {
        Book[] memory books = new Book[](0);
        users[msg.sender] = User(_name, UserType.User, 0, 0, books);
    }

    function addAdmin(string memory _name) private onlyOwner(){
        Book[] memory books = new Book[](0);
        users[msg.sender] = User(_name, UserType.Admin, 0, 0, books);
    }

    function whatReaded(address _user) public returns(string[] memory) {
        require(users[_user].bookReaded.length > 0, "You didn't read books.");
        string [] memory results;
        for(uint i = 0; i < users[_user].booksReaded.length; i++) {
            results.push(booksReaded[i].title);
        }
        return results;
    }

    


}