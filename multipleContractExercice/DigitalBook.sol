// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./Book.sol";

contract DigitalBook is Book {

    function giveAccess(uint _id) public view onlyDigitalBook(_id) returns(string memory) {
        return books[_id].fileFormat;
    }

}