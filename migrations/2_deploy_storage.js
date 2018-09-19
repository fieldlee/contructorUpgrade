var TokenStorage = artifacts.require("./TokenStorage.sol");
module.exports = function(deployer) {
  deployer.deploy(TokenStorage);
};
