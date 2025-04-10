// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IBook.sol";

contract Book is IBook {

    enum BookType {Digital, Physical}
 
    struct BookStruct {
        uint id;
        string title;
        string author;
        string description;
        uint price;
        bool available;
        BookType bookType;
        uint weight;
        string edition;
        uint fileSize;
        string fileFormat;
        string [] state; // A VOIR
        address [] // A VOIR
    }

    mapping(uint => BookStruct) public books;
    BookStruct [] public booksArray;

    modifier onlyPhysicalBook(uint _id) {
        require(books[_id].bookType == BookType.Physical, "Digital book !");
        _;
    }

    function addBook(string memory _title, string memory _author, string memory _description, uint _price, bool _available, uint _bookType, uint _weight, string memory _edition, uint _fileSize, string memory _fileFormat) public {
        BookType bookTypeEnum;

        if (_bookType > 1) {
            revert("BookType invalid");
        } else if (_bookType == 0) {
            bookTypeEnum = BookType.Digital;
            _weight = 0;
            _edition = "";
        } else if (_bookType == 1) {
            bookTypeEnum = BookType.Physical;
            _fileSize = 0;
            _fileFormat = "";
        }

        booksArray.push(BookStruct(booksArray.length, _title, _author, _description, _price, _available, bookTypeEnum, _weight, _edition, _fileSize, _fileFormat));
        books[booksArray.length] = BookStruct(booksArray.length, _title, _author, _description, _price, _available, bookTypeEnum, _weight, _edition, _fileSize, _fileFormat);
    }

    function borrowBook(uint _id) public onlyPhysicalBook(_id){
        books[_id].available = false;
    }

    function returnBook(uint _id) public onlyPhysicalBook(_id){
        books[_id].available = true;
    }

    function isAvailable(uint _id) public view  returns(bool){
        return books[_id].available;
    }

    function getBookDetails(uint _id) public view returns(string memory, string memory, string memory, uint, bool, uint, uint, string memory, uint, string memory) {
        uint test;
        if(books[_id].bookType ==  BookType.Digital) {
           test = 0;
        } else if(books[_id].bookType ==  BookType.Physical) {
           test= 1;
        }
        return (books[_id].title, books[_id].author, books[_id].description, books[_id].price, books[_id].available, test, books[_id].weight, books[_id].edition, books[_id].fileSize, books[_id].fileFormat);
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