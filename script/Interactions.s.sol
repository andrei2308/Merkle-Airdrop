//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";
/**
 * @title ClaimAirdrop
 * @author Chitoiu Andrei
 * @notice This script is used to claim the airdrop from the MerkleAirdrop contract
 * The signature is a hardcoded value, and the proof is also hardcoded
 * They should be replaced with the actual values from the airdrop depending on the deployment
 */

contract ClaimAirdrop is Script {
    error __ClaimAirdrop__InvalidSignature();

    address CLAIMING_ADDRESS = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    uint256 CLAIMING_AMMOUNT = 25 * 1e18;
    bytes32 proofOne = 0xd1445c931158119b00449ffcac3c947d028c0c359c34a6646d95962b3b55c6ad;
    bytes32 proofTwo = 0xe5ebd1e1b5a5478a944ecab36a9a954ac3b6b8216875f6524caa7a1d87096576;
    bytes32[] PROOF = [proofOne, proofTwo];
    bytes private SIGNATURE =
        hex"a8621870ce4f683842d005a9b8c27e9d5c2e993624270acb8d54cd04176a9a054aa2a6329cce4d708e7ce8a2cbe2aa71693f3b2e65cf9f54b7f01fce535687681c";

    function claimAirdrop(address airdrop) public {
        vm.startBroadcast();
        (uint8 v, bytes32 r, bytes32 s) = splitSignature(SIGNATURE);
        MerkleAirdrop(airdrop).claim(CLAIMING_ADDRESS, CLAIMING_AMMOUNT, PROOF, v, r, s);
        vm.stopBroadcast();
    }

    function splitSignature(bytes memory sig) public pure returns (uint8 v, bytes32 r, bytes32 s) {
        if (sig.length != 65) {
            revert __ClaimAirdrop__InvalidSignature();
        }
        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }
    }

    function run() external {
        address mostRcentlyDeployed = DevOpsTools.get_most_recent_deployment("MerkleAirdrop", block.chainid); //function will work only on UNIX based systems due to path differences
        claimAirdrop(mostRcentlyDeployed);
    }
}
