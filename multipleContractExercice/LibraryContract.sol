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
        Book.BookStruct [] booksReaded;
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
        Book.BookStruct[] memory books = new Book.BookStruct[](0);
        users[msg.sender] = User(_name, UserType.User, 0, 0, books);
    }

    function addAdmin(string memory _name) private onlyOwner(){
        Book.BookStruct[] memory books = new Book.BookStruct[](0);
        users[msg.sender] = User(_name, UserType.Admin, 0, 0, books);
    }

    function whatReaded(address _user) public view returns(string[] memory) {
        require(users[_user].booksReaded.length > 0, "You didn't read books.");
        string [] memory results = new string[](users[_user].booksReaded.length);
        for(uint i = 0; i < users[_user].booksReaded.length; i++) {
            results[i] = users[_user].booksReaded[i].title;
        }
        return results;
    }

    function becomeAdmin() public payable {
        require(bytes(users[msg.sender].name).length != 0, "Account not exist");
        require(users[msg.sender].role == UserType.User , "Account type not valid");
        require(msg.value == 0.01 ether, "Invalid amount");
        users[msg.sender].role = UserType.Admin;
    }

    function getUser(address _user) public view returns(string memory, string memory, string[] memory) {
        require(bytes(users[_user].name).length > 0, "User doesn't exist");
        string memory role = users[_user].role == UserType.User ? "User" : "Admin";
        uint length = users[_user].booksReaded.length;
        string[] memory results = new string[](length);
        if(users[_user].booksReaded.length == 0){
            results = new string[](1);
            results[0] = "You have not read books";
        } else {
            for (uint i = 0; i < users[_user].booksReaded.length; i ++) {
            results[i]= users[_user].booksReaded[i].title;
            }
        }
        return (users[_user].name, role, results);
    }

}