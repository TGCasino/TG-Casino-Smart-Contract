require("@nomiclabs/hardhat-ethers");

const hre = require("hardhat");

async function main() {
  // Grab the contract factory 

  const CasinoBank = await ethers.getContractFactory("CustodialContract");
  const casinoBank = await CasinoBank.deploy();
  await casinoBank.deployed();

  console.log("CasinoBankRoll deployed to address::", casinoBank.address);
}

main()
 .then(() => process.exit(0))
 .catch(error => {
   console.error(error);
   process.exit(1);
 });