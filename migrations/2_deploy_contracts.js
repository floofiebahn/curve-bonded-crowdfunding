const TestERC20BondingToken = artifacts.require("TestERC20BondingToken");
const ERC20BondingToken = artifacts.require("ERC20BondingToken");

module.exports = async (deployer, network, accounts) => {
  await deployer.deploy(TestERC20BondingToken)
  await deployer.deploy(ERC20BondingToken, TestERC20BondingToken.address);
};
