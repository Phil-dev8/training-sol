// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ILibrary {
    function addBook(string memory title, string memory author, bool available) external;
    function borrowBook(uint id) external;
    function returnBook(uint id) external;
    function getBookDetails(uint id) external returns(string memory, string memory, bool);
}