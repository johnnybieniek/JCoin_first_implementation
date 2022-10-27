require("@nomicfoundation/hardhat-toolbox")
require("@nomiclabs/hardhat-waffle")
require("hardhat-gas-reporter")
require("@nomiclabs/hardhat-etherscan")
require("dotenv").config()
require("solidity-coverage")
require("hardhat-deploy")

const COINMARKETCAP_API_KEY = process.env.COINMARKETCAP_API_KEY || ""
const PRIVATE_KEY = process.env.PRIVATE_KEY || ""
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY || ""
const GOERLI_RPC_URL = process.env.GOERLI_RPC_URL
const MATIC_RPC_URL = process.env.MATIC_RPC_URL || ""
const MATIC_ETHERSCAN_KEY = process.env.MATIC_ETHERSCAN_KEY || ""

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
    defaultNetwork: "hardhat",
    networks: {
        hardhat: {
            chainId: 31337,
            // gasPrice: 130000000000,
        },
        goerli: {
            url: GOERLI_RPC_URL,
            accounts: [PRIVATE_KEY],
            chainId: 5,
            blockConfirmations: 6,
        },
        matic: {
            url: MATIC_RPC_URL,
            accounts: [PRIVATE_KEY],
            chainId: 137,
            gas: 20000000,
            blockConfirmations: 6,
        },
    },
    etherscan: {
        apiKey: {
            goerli: ETHERSCAN_API_KEY,
            polygon: MATIC_ETHERSCAN_KEY,
        },
    },
    solidity: "0.8.17",
    gasReporter: {
        enabled: true,
        currency: "USD",
        token: "ETH",
        outputFile: "gas-report.txt",
        noColors: true,
        coinmarketcap: COINMARKETCAP_API_KEY,
    },
    namedAccounts: {
        deployer: {
            default: 0,
            1: 0,
        },
    },
    mocha: {
        timeout: 200000, // 200 seconds max for running tests
    },
}
