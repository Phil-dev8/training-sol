// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IBook.sol";

contract Book is IBook {

    struct BookStruct {
        uint id;
        string title;
        string author;
        string description;
        uint price;
        bool available;
    }

    mapping(uint => BookStruct) public books;
    BookStruct [] public booksArray;

    function addBook(string memory _title, string memory _author, string memory _description, uint _price) public {
        booksArray.push(BookStruct(booksArray.length ,_title, _author, _description, _price, true));
        books[booksArray.length] = BookStruct(booksArray.length ,_title, _author, _description, _price, true);
    }

    function borrowBook(uint _id) public {
        books[_id].available = false;
    }

    function returnBook(uint _id) public {
        books[_id].available = true;
    }

    function isAvalaible(uint _id) public view returns(bool){
        return books[_id].available;
    }

    function getBookDetails(uint _id) public view returns(string memory, string memory, string memory, uint, bool) {
        return (books[_id].title, books[_id].author, books[_id].description, books[_id].price, books[_id].available);
    }

    function getAllBooks() public view returns(string[] memory) {
        uint length = booksArray.length;
        string [] memory results = new string[](length);
        for(uint i = 0; i < length; i++) {
            results[i] = booksArray[i].title;
        }
        return results;
    }
}