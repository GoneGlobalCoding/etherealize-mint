var EtherealizeCrowdsale = artifacts.require("./EtherealizeCrowdsale.sol");
var Web3 = require("web3");


module.exports = function(deployer) {
  const web3 = new Web3(new Web3.providers.HttpProvider("https://ropsten.infura.io"))
  const startTime = web3.eth.getBlock(web3.eth.blockNumber).timestamp + 300;
  const endTime = startTime + (86400 * 30); // 30 days
  const ethRate = new web3.BigNumber(1000);
  console.log(startTime);
  console.log(endTime);
  console.log(ethRate);
  deployer.deploy(EtherealizeCrowdsale,startTime,endTime,ethRate,"0xe47c4befB25055860fd026e96885B30C7a244b30");
};

// uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet
//0xafa43870a02fb0c6dd6392f86579a12b1b931e7b