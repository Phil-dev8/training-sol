// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IBook.sol";
import "./LibraryContract.sol";

contract Book is IBook, LibraryContract {

    enum BookType {Digital, Physical}
    enum BookState {New, Excellent, Used, NULL}
    event BookBought(address indexed buyer, string bookTitle);
    event BookBorrowed(address indexed user, string bookTitle);
    event BookReturned(address indexed user, string bookTitle);

 
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

        uint id = booksArray.length;
        BookType bookTypeEnum;
        BookState bookState;

        BookStruct memory newBook = BookStruct(
            id,
            _title,
            _author,
            _description,
            _price,
            _available,
            bookTypeEnum,
            bookState,
            bookTypeEnum == BookType.Physical ? _weight : 0,
            bookTypeEnum == BookType.Physical ? _edition : "",
            bookTypeEnum == BookType.Digital ? _fileSize : 0,
            bookTypeEnum == BookType.Digital ? _fileFormat : ""
        );

        booksArray.push(newBook);
        books[id] = newBook;

    }

    function borrowBook(uint _id) public onlyPhysicalBook(_id) {
        require(isAvailable(_id), "Not available");

        BookStruct storage book = books[_id];
        users[msg.sender].bookBorrowedCounter++;
        users[msg.sender].booksReaded.push(book);
        book.available = false;

        emit BookBorrowed(msg.sender, book.title);
    }

    function returnBook(uint _id) public onlyPhysicalBook(_id) {
        require(!books[_id].available, "Already available");
        books[_id].available = true;
        emit BookReturned(msg.sender, books[_id].title);
    }

    function isAvailable(uint _id) public view returns(bool){
        return books[_id].available;
    }

    function buyBook(uint _id) public payable {
        BookStruct memory book = books[_id];
        require(book.available, "Not available");
        require(msg.value == book.price, "Wrong price");

        users[msg.sender].booksReaded.push(book);
        book.available = false;

        emit BookBought(msg.sender, book.title);
    }

    function getBookDetails(uint _id) public view returns (
        string memory, string memory, string memory, uint, bool, uint, uint, string memory, uint, string memory
    ) {
        BookStruct storage book = books[_id];
        return (
            book.title,
            book.author,
            book.description,
            book.price,
            book.available,
            uint(book.bookType),
            uint(book.bookState),
            book.edition,
            book.fileSize,
            book.fileFormat
        );
    }

    function getAllBooks() public view returns(string[] memory) {
        string [] memory results = new string[](booksArray.length);
        for(uint i = 0; i < booksArray.length; i++) {
            results[i] = booksArray[i].title;
        }
        return results;
    }
}