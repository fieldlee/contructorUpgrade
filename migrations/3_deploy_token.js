var TokenStorage = artifacts.require("./TokenStorage.sol");
var LToken = artifacts.require("./LToken.sol");

module.exports = function(deployer) {
    // ,"LMTTOKEN","LMT",18,1000000
  var initedToken;
  deployer.deploy(LToken, TokenStorage.address).
  then(() => {
    TokenStorage.deployed().then(inst => {
        initedToken = inst;
        return inst.allowAccess(MCCToken.address);
    });
    // .then((result)=>{
    //     console.log(result);
    //     return initedToken.setInit("LMTTOKEN","LMT",18,1000000);
    // }).then((result)=>{
    //     console.log(result);
    // });
  });
};