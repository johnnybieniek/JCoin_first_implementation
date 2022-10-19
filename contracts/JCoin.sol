// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

error JCoin__AlreadyMinted();
error JCoin__MaxSupplyReached();

contract JCoin is ERC20, Ownable {
    uint256 private s_totalSupply;
    uint256 private s_maxSupply = 100 * 10**uint256(decimals());
    uint256 private s_mintingLimit = 5 * 10**uint256(decimals());

    mapping(address => bool) s_minters;

    modifier firstTimeMinting(address minter) {
        if (s_minters[minter]) {
            revert JCoin__AlreadyMinted();
        }
        _;
    }

    modifier SupplyNotReached() {
        if (s_maxSupply - s_totalSupply < s_mintingLimit) {
            revert JCoin__MaxSupplyReached();
        }
        _;
    }

    constructor(uint256 initialSupply) ERC20("JCoin", "JC") {
        _mint(msg.sender, initialSupply * 10**uint256(decimals()));
    }

    function mintCoins() public firstTimeMinting(msg.sender) SupplyNotReached {
        s_minters[msg.sender] = true;
        _mint(msg.sender, s_mintingLimit);
    }

    function setMaxSupply(uint256 newMaxSupply) public onlyOwner {
        s_maxSupply = newMaxSupply * 10**uint256(decimals());
    }

    function getMaxSupply() public view returns (uint256) {
        return (s_maxSupply / (10**uint256(decimals())));
    }

    function getMintingLimit() public view returns (uint256) {
        return (s_mintingLimit / (10**uint256(decimals())));
    }
}
