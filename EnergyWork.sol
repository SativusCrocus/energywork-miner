// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/v5.0.2/contracts/token/ERC20/ERC20.sol";

contract EnergyWork is ERC20 {
    string public constant VISION = "THE FUTURE OF CURRENCY WILL BE WORK AND ENERGY - ELON MUSK";

    uint256 public constant INITIAL_REWARD = 50 ether;
    uint256 public constant HALVING_INTERVAL = 210_000;
    uint256 public constant TARGET = 0x00000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff; // ~2^20 difficulty

    uint256 public challenge;
    uint256 public miningCount;

    constructor() ERC20("EnergyWork", "EW") {
        challenge = uint256(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, msg.sender)));
        miningCount = 0;
    }

    function currentReward() public view returns (uint256) {
        uint256 era = miningCount / HALVING_INTERVAL;
        // After era 33–34 reward naturally becomes 0 via bit-shift
        return INITIAL_REWARD >> era;
    }

    function mine(uint256 nonce) external {
        uint256 reward = currentReward();
        require(reward > 0, "No more rewards this era");

        bytes32 hash_ = keccak256(abi.encodePacked(challenge, msg.sender, nonce));
        require(uint256(hash_) < TARGET, "Proof of work insufficient");

        _mint(msg.sender, reward);

        miningCount++;
        challenge = uint256(hash_);
    }

    function getVision() external pure returns (string memory) {
        return VISION;
    }
}