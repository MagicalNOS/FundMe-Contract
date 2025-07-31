// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract Helperconfig {

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 3800e8;
    NetworkConfig public activeConfig;

    struct NetworkConfig {
        address priceFeed;
    }

    function getConfig() public returns (NetworkConfig memory) {
        if (block.chainid == 11155111) {
            activeConfig =  getSepoliaConfig();
        } 
        else if (block.chainid == 1) {
            activeConfig =  getMainnetConfig();
        } 
        else{
            activeConfig =  getOrCreateAnvilConfig();
        }
        return activeConfig;
    }

    function getSepoliaConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306 // Sepolia ETH/USD price feed address
        });
        return sepoliaConfig;
    }

    function getMainnetConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory mainnetConfig = NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419 // Mainnet ETH/USD price feed address
        });
        return mainnetConfig;
    }

    function getOrCreateAnvilConfig() public returns (NetworkConfig memory){
        if (activeConfig.priceFeed != address(0)) {
            return activeConfig;
        }
        MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockV3Aggregator)
        });
        return anvilConfig;
    }
}
