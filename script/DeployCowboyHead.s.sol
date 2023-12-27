// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {CowboyHead} from "../src/CowboyHead.sol";

contract DeployCowboyHead is Script {
    function run() external returns(CowboyHead) {
        vm.startBroadcast();
        CowboyHead cowboyHead = new CowboyHead(msg.sender);
        vm.stopBroadcast();
        return cowboyHead;
    }
}