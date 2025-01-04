//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";
import {BitoiuToken} from "../src/BitoiuToken.sol";
/**
 * @title  MerkleAirdropTest
 * @author Chitoiu Andrei
 * @notice This contract tests the MerkleAirdrop contract
 */

contract MerkleAirdropTest is Test {
    MerkleAirdrop public airdrop;
    BitoiuToken public token;
    bytes32 public merkleRoot = 0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;
    address user;
    address gasPayer;
    uint256 userPrivKey;
    uint256 public constant AMOUNT = 25 * 1e18;
    uint256 public constant AMOUNT_TO_MINT = 1000 * 1e18;
    bytes32 proofOne = 0x0fd7c981d39bece61f7499702bf59b3114a90e66b51ba2c53abdf7b62986c00a;
    bytes32 proofTwo = 0xe5ebd1e1b5a5478a944ecab36a9a954ac3b6b8216875f6524caa7a1d87096576;
    bytes32[] public PROOF = [proofOne, proofTwo];

    function setUp() public {
        token = new BitoiuToken();
        airdrop = new MerkleAirdrop(merkleRoot, token);
        token.mint(token.owner(), AMOUNT_TO_MINT);
        token.transfer(address(airdrop), AMOUNT_TO_MINT);
        (user, userPrivKey) = makeAddrAndKey("user");
        gasPayer = makeAddr("gasPayer");
    }

    function testUsersCanClaim() public {
        uint256 startingBalance = token.balanceOf(user);
        bytes32 digest = airdrop.getMessage(user, AMOUNT);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(userPrivKey, digest);

        vm.startPrank(gasPayer);
        airdrop.claim(user, AMOUNT, PROOF, v, r, s);
        vm.stopPrank();
        uint256 endingBalance = token.balanceOf(user);
        assertEq(endingBalance, startingBalance + AMOUNT);
    }
}
