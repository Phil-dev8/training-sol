// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IBook.sol";
import "./LibraryContract.sol";

contract Book is IBook, LibraryContract {

    enum BookType {Digital, Physical}
    enum BookState {New, Excellent, Used, NULL}
    event BookBought(address indexed, string bookTitle);
    event BookBorrowed(address indexed, string bookTitle);
    event BookReturned(address indexed, string bookTitle);

 
    struct BookStruct {
        uint id;
        string title;
        string author;
        string description;
        uint price;
        bool available;
        BookType bookType;
        BookState bookState;
        uint weight;
        string edition;
        uint fileSize;
        string fileFormat;
    }

    mapping(uint => BookStruct) public books;
    BookStruct [] public booksArray;

    modifier onlyPhysicalBook(uint _id) {
        require(books[_id].bookType == BookType.Physical, "Digital book !");
        _;
    }

    modifier onlyDigitalBook(uint _id) {
        require(books[_id].bookType == BookType.Digital, "Physical book !");
        _;
    }

    function addBook(string memory _title, string memory _author, string memory _description, uint _price, bool _available, uint _bookType, uint _bookState, uint _weight, string memory _edition, uint _fileSize, string memory _fileFormat) public onlyAdmin(){
        require(_bookState <= uint(BookState.NULL), "Invalid state");
        require(_bookType <= uint(BookType.Digital), "Invalid type");
        BookType bookTypeEnum;
        BookState bookState;

        if (_bookType == 0) {
            bookTypeEnum = BookType.Digital;
            bookState = BookState.NULL;
            _weight = 0;
            _edition = "";
        } else if (_bookType == 1) {
            bookTypeEnum = BookType.Physical;
            bookState = BookState(_bookState);
            _fileSize = 0;
            _fileFormat = "";
        }

        booksArray.push(BookStruct(booksArray.length, _title, _author, _description, _price, _available, bookTypeEnum, bookState, _weight, _edition, _fileSize, _fileFormat));
        books[booksArray.length] = BookStruct(booksArray.length, _title, _author, _description, _price, _available, bookTypeEnum, bookState, _weight, _edition, _fileSize, _fileFormat);
    }

    function borrowBook(uint _id) public onlyPhysicalBook(_id) {
        require(isAvailable(_id) == true, "Book not available.");
        BookStruct storage bookStruct = books[_id];
        User storage user = users[msg.sender];
        user.bookBorrowedCounter ++;
        user.booksReaded.push(bookStruct);
        books[_id].available = false;
        emit BookBorrowed(msg.sender, books[_id].title);
    }

    function returnBook(uint _id) public onlyPhysicalBook(_id) {
        require(books[_id].available == false, "Already available");
        books[_id].available = true;
        emit BookReturned(msg.sender, books[_id].title);
    }

    function isAvailable(uint _id) public view returns(bool){
        return books[_id].available;
    }

    function buyBook(uint _id) public payable {
        require(isAvailable(_id) == true, "Book not available.");
        require(msg.value == books[_id].price, "Incorrect amount");
        BookStruct storage bookStruct = books[_id];
        User storage user = users[msg.sender];
        user.booksReaded.push(bookStruct);
        books[_id].available = false;
        emit BookBought(msg.sender, books[_id].title);
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