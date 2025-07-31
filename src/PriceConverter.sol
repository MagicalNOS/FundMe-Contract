// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice(address pricefeed) public view returns (uint256) {
        // address : 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // ABI
        (, int256 answer,,,) = AggregatorV3Interface(pricefeed).latestRoundData();
        return uint256(answer * 1e10);
    }

    function getVersion(address pricefeed) public view returns (uint256) {
        return AggregatorV3Interface(pricefeed).version();
    }

    function getUSD(uint256 _amount, address pricefeed) public view returns (uint256) {
        return (_amount * getPrice(pricefeed)) / 1e18;
    }
}
