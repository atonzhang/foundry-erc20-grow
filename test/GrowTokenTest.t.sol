// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {DeployGrowToken} from "../script/DeployGrowToken.s.sol";
import {GrowToken} from "../src/GrowToken.sol";
import {Test} from "forge-std/Test.sol";

interface MintableToken {
    function mint(address, uint256) external;
}

contract OurTokenTest is Test {
    uint256 BOB_STARTING_AMOUNT = 100 ether;
    uint256 public constant INITIAL_SUPPLY = 1_000_000 ether; // 1 million tokens with 18 decimal places

    GrowToken public growToken;
    DeployGrowToken public deployer;
    address public deployerAddress;
    address bob;
    address alice;

    function setUp() public {
        deployer = new DeployGrowToken();
        growToken = deployer.run();
        
        bob = makeAddr("bob");
        alice = makeAddr("alice");

        vm.prank(msg.sender);
        growToken.transfer(bob, BOB_STARTING_AMOUNT);
    }

    function testInitialSupply() public view {
        assertEq(growToken.totalSupply(), deployer.INITIAL_SUPPLY());
    }

    function testUsersCantMint() public {
        vm.expectRevert();
        MintableToken(address(growToken)).mint(address(this), 1);
    }

    function testAllowances() public {
        uint256 initialAllowance = 1000;

        // Bob approves Alice to spend tokens on his behalf

        vm.prank(bob);
        growToken.approve(alice, initialAllowance);
        uint256 transferAmount = 500;

        vm.prank(alice);
        growToken.transferFrom(bob, alice, transferAmount);
        assertEq(growToken.balanceOf(alice), transferAmount);
        assertEq(growToken.balanceOf(bob), BOB_STARTING_AMOUNT - transferAmount);
    }
}