// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

error JCoin__MaxSupplyReached();
error JCoin__BadMath();

contract JCoin is ERC20, Ownable {
    uint256 private s_totalSupply;
    uint256 private s_maxSupply = 100 * 10**uint256(decimals());
    uint256 private s_mintingLimit = 5 * 10**uint256(decimals());

    mapping(address => bool) s_minters;
    mapping(address => uint256) s_mintedPerWallet;

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

    function mintCoins() public SupplyNotReached {
        s_minters[msg.sender] = true;
        uint256 amount = getMintingLimit();
        s_mintedPerWallet[msg.sender] += amount;
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

    function getMintedPerWallet(address minter) public view returns (uint256) {
        return s_mintedPerWallet[minter];
    }
}
