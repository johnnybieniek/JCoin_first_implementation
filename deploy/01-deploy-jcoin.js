const { network } = require("hardhat")
const { networkConfig, developmentChains } = require("../helper-hardhat-config")
const { verify } = require("../utils/verify")

module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()
    const INITIAL_SUPPLY = 10

    log("----------------------------------------------------")

    args = [INITIAL_SUPPLY]

    const JCoin = await deploy("JCoin", {
        from: deployer,
        args: args,
        log: true,
        waitConfirmations: 1,
    })

    // Verify the deployment
    if (!developmentChains.includes(network.name) && process.env.ETHERSCAN_API_KEY) {
        log("Verifying...")
        await verify(JCoin.address, args)
    }
}

module.exports.tags = ["all", "jcoin", "main"]
