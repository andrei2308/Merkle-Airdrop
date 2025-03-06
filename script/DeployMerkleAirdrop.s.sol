//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {BitoiuToken} from "../src/BitoiuToken.sol";
import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";
import {IERC20, SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/**
 * @title  DeployMerkleAirdrop
 * @author Chitoiu Andrei
 * @notice This script deploys a MerkleAirdrop contract and a BitoiuToken contract
 * The s_merkleRoot is the root of the merkle tree that will be used to verify the claims
 * The Merkle Root should be replaced with the root of the merkle tree that will be used depending on the accounts and values that will be used
 */
contract DeployMerkleAirdrop is Script {
    bytes32 private s_merkleRoot = 0x23632c16d1c587b6c6f9825552415323da2a1a19bf853c4809ba4bb22cbd36dd;
    uint256 private s_amountToTransfer = 4 * 25 * 1e18;

    function run() public returns (BitoiuToken, MerkleAirdrop) {
        return deployMerkleAirdrop();
    }

    function deployMerkleAirdrop() public returns (BitoiuToken, MerkleAirdrop) {
        vm.startBroadcast();
        BitoiuToken token = new BitoiuToken();
        MerkleAirdrop airdrop = new MerkleAirdrop(s_merkleRoot, IERC20(token));
        token.mint(token.owner(), s_amountToTransfer);
        IERC20(token).transfer(address(airdrop), s_amountToTransfer);
        vm.stopBroadcast();
        return (token, airdrop);
    }
}
