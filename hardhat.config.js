require("@nomicfoundation/hardhat-toolbox");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html

let PRIVATE_KEY = 'd27ce747cf4fb436eafaa17eb404e02208cb7e4bb2af61c6cb9a9d39f5b2a127'
let hardhatConfig = {}
let goerliConfig = {
   url: "https://goerli.infura.io/v3/" + "e254d35aa64b4c16816163824d9d5b83",
   chainId: 5,
   accounts: [`0x${PRIVATE_KEY}`]
}

module.exports = {
   defaultNetwork: "goerli",
   networks: {
      hardhat: hardhatConfig,
      goerli: goerliConfig
   },   
   solidity: {
      version: "0.8.7",
      settings: {
         optimizer: {
            enabled: true,
            runs: 200,
         }
      }
   },
   etherscan: {
      // Your API key for Etherscan
      // Obtain one at https://etherscan.io/
      apiKey: "S1VH5HN4RW22314GI9APVKVFIJ36IH5SXV"
      // apiKey: "S1VH5HN4RW22314GI9APVKVFIJ36IH5SXV"
   },
   paths: {
     sources: "./contracts",
     tests: "./test",
     cache: "./cache",
     artifacts: "./artifacts"
   },
   mocha: {
     timeout: 20000
   }
}