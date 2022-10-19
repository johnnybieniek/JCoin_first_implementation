const networkConfig = {
    31337: {
        name: "localhost",
        waitConfirmations: 5,
    },
    5: {
        name: "goerli",
    },
}

const developmentChains = ["hardhat", "localhost"]

module.exports = {
    networkConfig,
    developmentChains,
}
