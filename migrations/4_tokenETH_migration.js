const Ether = artifacts.require("Ether");
const Dex = artifacts.require("Dex");

module.exports = async function(deployer, network, accounts) {
  await deployer.deploy(Ether);
  };