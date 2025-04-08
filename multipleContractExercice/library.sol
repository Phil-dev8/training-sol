// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ILibrary.sol";
import "./book.sol";

contract Library is ILibrary {
    
    mapping(uint => Book) public books;
    uint public bookId = 0;

    function addBook(string memory _title, string memory _author, bool _available) public {
        books[bookId] = new Book(_title, _author, _available);
        bookId ++;
    }

    function borrowBook(uint _bookId) public{
        books[_bookId].available = false;
    }

    function returnBook(uint _bookId) public {
        books[_bookId].available = true;
    }

    function getBookDetails(uint _bookId) public view returns(string memory, string memory, bool){
        return books[_bookId];
    }

}