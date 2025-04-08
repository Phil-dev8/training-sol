// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract Book {

   string public author;
   string public title;
   bool public available;

    constructor(string memory _title, string memory _author, bool _available) {
        author = _author;
        title = _title;
        available = _available;
    }
}