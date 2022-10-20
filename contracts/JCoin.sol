// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

error JCoin__AlreadyMinted();
error JCoin__MaxSupplyReached();
error JCoin__BadMath();

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
        uint256 currentSupply = getTotalSupply();
        uint256 currentMax = getMaxSupply();
        uint256 currentMintVal = getMintingLimit();
        if (currentMax < (currentMintVal + currentSupply)) {
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
        uint256 currentSupply = totalSupply();
        if ((newMaxSupply * 10**uint256(decimals())) < currentSupply) {
            revert JCoin__BadMath();
        }
        s_maxSupply = newMaxSupply * 10**uint256(decimals());
    }

    function getMaxSupply() public view returns (uint256) {
        return (s_maxSupply / (10**uint256(decimals())));
    }

    function getMintingLimit() public view returns (uint256) {
        return (s_mintingLimit / (10**uint256(decimals())));
    }

    function getTotalSupply() public view returns (uint256) {
        uint256 totalSupply = totalSupply();
        return (totalSupply / (10**uint256(decimals())));
    }

    function CheckAccountForMint(address minter) public view returns (bool) {
        return s_minters[minter];
    }
}
