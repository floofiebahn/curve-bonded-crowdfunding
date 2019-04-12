const ERC20BondingToken = artifacts.require("ERC20BondingToken");

module.exports = async (deployer, network, accounts) => {
  await deployer.deploy(ERC20BondingToken);
};
