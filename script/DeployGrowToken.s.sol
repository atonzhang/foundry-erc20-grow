// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {GrowToken} from "../src/GrowToken.sol";

contract DeployGrowToken is Script {
    uint256 public constant INITIAL_SUPPLY = 1e6 ether; // 1 million tokens with 18 decimal places

    function run() external returns (GrowToken) {
        vm.startBroadcast();
        GrowToken growToken = new GrowToken(INITIAL_SUPPLY);
        vm.stopBroadcast();
        return growToken;
    }
}