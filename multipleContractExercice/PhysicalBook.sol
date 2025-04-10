// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Book.sol";

contract PhysicalBook is Book {

    function getState(uint _id) public onlyPhysicalBook(_id){
        books[_id].state
    }
}