// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {Helperconfig} from "../script/HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        Helperconfig helperConfig = new Helperconfig();
        vm.startBroadcast();
        FundMe fundMe = new FundMe(helperConfig.getConfig().priceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}
