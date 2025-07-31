// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {PriceConverter} from "../../src/PriceConverter.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    uint256 number = 1;
    FundMe fundMe;
    DeployFundMe deployFundMe;

    address USER = makeAddr("user");

    function setUp() external {
        deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, 10 ether);
    }

    function testMinimumDollarsIsFive() public view {
        assertEq(fundMe.MINIMUMDOLLARS(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.i_owner(), address(msg.sender));
    }

    function testPriceFeedVersionIsAccurate() public view {
        uint256 versin = fundMe.getVersion();
        assertEq(versin, 4);
    }

    function testGetPrice() public view {
        uint256 price = fundMe.getPrice();
        assertEq(PriceConverter.getPrice(fundMe.s_pricefeed()), price);
    }

    function testFunderIsAccurate() funded public {
        address funder = fundMe.s_funders(0);
        assertEq(funder, USER);
    }

    function testFundWithoutEnoughETH() public{
        vm.prank(USER); // Simulate a call from USER
        vm.expectRevert("didn't send enough ETH"); // next line should revert
        fundMe.fund{value: 1}();
    }

    function testFundUpdateFunders() funded public{
        address funder = fundMe.s_funders(0);
        assertEq(funder, USER);
    }

    function testAddressToFund() funded public{
        uint256 amount = fundMe.s_addressToFund(USER);
        assertEq(amount, 0.1 ether);
    }

    function testUnOwnerCannotWithdraw() funded public{
        vm.expectRevert("FundMe_UnOwner()"); // next line should revert
        fundMe.withdraw();
    }

    function testSingerUserCanWithdraw() public funded {
        uint256 startingOwnerBalance = fundMe.i_owner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        vm.prank(fundMe.i_owner()); // Simulate a call from the owner
        fundMe.withdraw();

        uint256 endingOwnerBalance = fundMe.i_owner().balance;
        assertEq(endingOwnerBalance, startingOwnerBalance + startingFundMeBalance);
    }

    function testSingerUserCanCheaperWithdraw() public funded {
        uint256 startingOwnerBalance = fundMe.i_owner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        vm.prank(fundMe.i_owner()); // Simulate a call from the owner
        fundMe.cheaperWithdraw();

        uint256 endingOwnerBalance = fundMe.i_owner().balance;
        assertEq(endingOwnerBalance, startingOwnerBalance + startingFundMeBalance);
    }

    function testMultiUserCanWithdraw() public{
        uint160 numberOfFunders = 10;
        for (uint160 i = 2; i < numberOfFunders; i++){
            hoax(address(i), 0.1 ether); // Simulate a call from a new user with 0.1 ether
            fundMe.fund{value: 0.1 ether}();
        }

        uint256 staringOwnerBalance = fundMe.i_owner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        vm.prank(fundMe.i_owner()); // Simulate a call from the owner
        fundMe.withdraw();
        uint256 endingOwnerBalance = fundMe.i_owner().balance;
        assertEq(endingOwnerBalance, staringOwnerBalance + startingFundMeBalance);
    }

    function testMultiUserCanCheaperWithdraw() public{
        uint160 numberOfFunders = 10;
        for (uint160 i = 2; i < numberOfFunders; i++){
            hoax(address(i), 0.1 ether); // Simulate a call from a new user with 0.1 ether
            fundMe.fund{value: 0.1 ether}();
        }

        uint256 staringOwnerBalance = fundMe.i_owner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        vm.prank(fundMe.i_owner()); // Simulate a call from the owner
        fundMe.cheaperWithdraw();
        uint256 endingOwnerBalance = fundMe.i_owner().balance;
        assertEq(endingOwnerBalance, staringOwnerBalance + startingFundMeBalance);
    }


    modifier funded() {
        vm.prank(USER); // Simulate a call from USER
        fundMe.fund{value: 0.1 ether}();
        _;
    }
}
