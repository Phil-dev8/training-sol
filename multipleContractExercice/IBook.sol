// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface IBook {
    
    function addBook(string memory title, string memory author, string memory description, uint price) external;
    function borrowBook(uint id) external;
    function returnBook(uint _id) external;
    function isAvalaible(uint id) external view returns(bool);
    //function buyBook(uint id) external payable returns(bool);
    function getBookDetails(uint id) external view returns(string memory, string memory, string memory, uint, bool);
    function getAllBooks() external view returns(string[] memory);
    
}