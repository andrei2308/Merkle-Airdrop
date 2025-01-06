The Merkle-Airdrop project is a smart contract system designed to efficiently distribute tokens using a Merkle tree structure. This approach allows users to claim tokens by providing proof of eligibility, enhancing scalability and reducing costs, making it ideal for large-scale airdrops.

**Project Structure:**

- **lib/**: Contains external libraries and dependencies.
- **script/**: Includes deployment and interaction scripts for the smart contracts.
- **src/**: Houses the main Solidity contracts:
  - *BitoiuToken.sol*: The ERC20 token contract used in the airdrop.
  - *MerkleAirdrop.sol*: The smart contract that facilitates the Merkle-based airdrop mechanism.
- **test/**: Contains test files to verify the functionality and security of the contracts.
- **foundry.toml**: Configuration file for Foundry, the Ethereum development toolkit used in this project.
- **Makefile**: Contains commands to automate tasks such as building, testing, and deploying contracts.

**Key Features:**

- **Merkle Tree Integration**: Utilizes a Merkle tree to manage and verify eligible recipients efficiently.
- **Scalability**: Designed to handle large-scale airdrops with reduced gas costs.

**Getting Started:**

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/andrei2308/Merkle-Airdrop.git
   cd Merkle-Airdrop
   ```

2. **Install Dependencies**:
   Ensure you have [Foundry](https://book.getfoundry.sh/) installed. Then, run:
   ```bash
   forge install
   ```

3. **Compile Contracts**:
   ```bash
   forge build
   ```

4. **Run Tests**:
   ```bash
   forge test
   ```

5. **Deploy Contracts**:
   Configure your deployment script in the `script/` directory and execute:
   ```bash
   forge script script/DeployMerkleAirdrop.s.sol --broadcast
   ```
   
**Usage Example:**

To claim tokens from the airdrop, users can call the `claim` function in the `MerkleAirdrop` contract:
```solidity
function claim(
    address account,
    uint256 amount,
    bytes32[] calldata merkleProof,
    uint8 v,
    bytes32 r,
    bytes32 s
) external;
```

Users need to provide a valid Merkle proof to verify their eligibility.

**License:**

This project is licensed under the MIT License.
