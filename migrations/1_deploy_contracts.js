var MintingContract = artifacts.require("./MintingContract.sol");
var Marketplace = artifacts.require("./Marketplace.sol");

module.exports = async function (deployer) {
  // deployer.deploy(MintingContract);
  // let newInstance = await MintingContract.deployed();
  // deployer.deploy(Marketplace, newInstance.address);
  deployer.deploy(MintingContract).then(function () {
    return deployer.deploy(Marketplace, MintingContract.address);
  });
};
