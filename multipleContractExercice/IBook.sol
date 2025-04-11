// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface IBook {
    
    function addBook(string memory title, string memory author, string memory description, uint price, bool available, uint bookType, uint bookState, uint weight, string memory edition, uint fileSize, string memory fileFormat) external;
    function borrowBook(uint id) external;
    function returnBook(uint id) external;
    function isAvailable(uint id) external view returns(bool);
    function buyBook(uint id) external payable;
    function getBookDetails(uint id) external view returns(string memory, string memory, string memory, uint, bool, uint, uint, string memory, uint, string memory);
    function getAllBooks() external view returns(string[] memory);
    
}