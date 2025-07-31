// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {PriceConverter} from "./PriceConverter.sol";

// Objects:
// Get funds from users
// Withdraw funds
// Set minimum funding valve in USD

error FundMe_UnOwner();
error FundMe_FailSend();
error FundMe_FailCall();

contract FundMe {
    uint256 public constant MINIMUMDOLLARS = 5e18;
    address public immutable i_owner;
    mapping(address => uint256) public s_addressToFund;
    address[] public s_funders;
    address public s_pricefeed;

    // Use ChainLink Oracle
    using PriceConverter for uint256;

    constructor(address s_pricefeedAddress) {
        i_owner = msg.sender;
        s_pricefeed = s_pricefeedAddress;
    }

    function fund() public payable {
        // false will cause revert
        require(msg.value.getUSD(s_pricefeed) > MINIMUMDOLLARS, "didn't send enough ETH");
        s_funders.push(msg.sender);
        s_addressToFund[msg.sender] += msg.value;
    }


    function cheaperWithdraw() public owner{
        uint256 numsOfs_funders = s_funders.length;
        for (uint256 i = 0; i < numsOfs_funders; i++){
            address funder = s_funders[i];
            s_addressToFund[funder] = 0;
        }
        s_funders = new address[](0);

        (bool success,) = payable(i_owner).call{value: address(this).balance}("");
        if (!success) {
            revert FundMe_FailCall();
        }
    }

    function withdraw() public owner {
        for (uint256 funderIndex = 0; funderIndex < s_funders.length; funderIndex++) {
            address funder = s_funders[funderIndex];
            s_addressToFund[funder] = 0;
        }
        s_funders = new address[](0);

        // 1. transfer() throw error
        // payable(i_owner).transfer(address(this).balance);

        // 2. send() return boolean but not throw the error
        // bool sendSuccess = payable(i_owner).send(address(this).balance);
        // if(sendSuccess != true){
        //     revert FailSend();
        // }

        // 3. call return boolean but not throw the error same to send()
        (bool callSuccess,) = payable(i_owner).call{value: address(this).balance}("");
        if (callSuccess != true) {
            revert FundMe_FailCall();
        }
    }

    //    is msg.data empty?
    //         /       \
    //        yes      no
    //        /          \
    //      receive()?   fallback()
    //        /    \
    //       yes   no
    //       /      \
    //   receive()  fallback()

    // Only msg.data is empty and dont assign the function will call receive() automatically
    receive() external payable {
        fund();
    }

    // receive() isn't exist or mas.data isn't empty and can't find the right function
    fallback() external payable {
        fund();
    }

    function getVersion() public view returns (uint256) {
        return PriceConverter.getVersion(s_pricefeed);
    }

    function getPrice() public view returns (uint256) {
        return PriceConverter.getPrice(s_pricefeed);
    }

    function getUSD(uint256 _amount) public view returns (uint256) {
        return PriceConverter.getUSD(_amount, s_pricefeed);
    }

    modifier owner() {
        if (msg.sender != i_owner) {
            revert FundMe_UnOwner();
        }
        _;
    }
}
