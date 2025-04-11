// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Book.sol";

contract PhysicalBook is Book {

    function getState(uint _id) public view onlyPhysicalBook(_id) returns(string memory){
        if(books[_id].bookState == BookState.New) {
            return "New";
        } else if (books[_id].bookState == BookState.Excellent) {
            return "Excellent";
        } else {
            return "Used";
        }
    }
}