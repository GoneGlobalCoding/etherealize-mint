var EtherealizeCrowdsale = artifacts.require("./EtherealizeCrowdsale.sol");

module.exports = function(deployer) {
  deployer.deploy(EtherealizeCrowdsale,2192150,221920,1,"0xe47c4befB25055860fd026e96885B30C7a244b30");
};

// uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet
//0xafa43870a02fb0c6dd6392f86579a12b1b931e7b