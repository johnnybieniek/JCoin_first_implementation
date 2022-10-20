const { assert, expect } = require("chai")
const { network, deployments, ethers, getNamedAccounts } = require("hardhat")
const { developmentChains } = require("../helper-hardhat-config")

!developmentChains.includes(network.name)
    ? describe.skip
    : describe("JCoin test", function () {
          let deployer, user1, user2
          const initialSupply = "10000000000000000000"
          const mintValue = "5000000000000000000"
          beforeEach(async function () {
              accounts = await ethers.getSigners()
              deployer = accounts[0]
              user1 = accounts[1]
              user2 = accounts[2]
              await deployments.fixture(["jcoin"])
              coinContract = await ethers.getContract("JCoin")
              coin = await coinContract.connect(deployer)
          })
          describe("Constructor", async function () {
              it("Initializes the contract's variables correctly", async function () {
                  const maxSupply = await coin.getMaxSupply()
                  const mintingLimit = await coin.getMintingLimit()
                  const totalSupply = (await coin.totalSupply()).toString()
                  assert.equal(maxSupply, 100)
                  assert.equal(mintingLimit, 5)
                  assert.equal(totalSupply, initialSupply)
              })
              it("Deployer's balance has the initial supply", async function () {
                  const deployerBalance = await coin.balanceOf(deployer.address)
                  assert.equal(deployerBalance, initialSupply)
              })
          })

          describe("setMaxSupply", async function () {
              it("Successfully changes the max supply", async function () {
                  const maxSupplyBefore = await coin.getMaxSupply()
                  assert.equal(maxSupplyBefore, 100)
                  await coin.setMaxSupply(200)
                  const maxSupplyAfter = await coin.getMaxSupply()
                  assert.equal(maxSupplyAfter, 200)
              })
              it("Reverts when new maxSupply is smaller than current supply", async function () {
                  await expect(coin.setMaxSupply(2)).to.be.revertedWithCustomError(
                      coinContract,
                      "JCoin__BadMath"
                  )
              })
          })
          describe("Mint coins", async function () {
              it("Allows first-time minter to successfuly receive coins", async function () {
                  coin = await coinContract.connect(user1)
                  const userBalanceBefore = await coin.balanceOf(user1.address)
                  assert.equal(userBalanceBefore, 0)
                  let userInMinters = await coin.CheckAccountForMint(user1.address)
                  assert.equal(userInMinters, false)
                  await coin.mintCoins()
                  const userBalanceAfter = await coin.balanceOf(user1.address)
                  userInMinters = await coin.CheckAccountForMint(user1.address)
                  assert.equal(userBalanceAfter.toString(), mintValue)
                  assert.equal(userInMinters, true)
              })
              it("Reverts when user tries to mint coins again", async function () {
                  coin = await coinContract.connect(user1)
                  await coin.mintCoins()
                  await expect(coin.mintCoins()).to.be.revertedWithCustomError(
                      coinContract,
                      "JCoin__AlreadyMinted"
                  )
              })
          })
      })
