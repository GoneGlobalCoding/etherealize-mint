var HDWalletProvider = require("truffle-hdwallet-provider");

var infura_apikey = "ocegHdFkHJ8Bk3zCKR2w";
var mnemonic = "dog tourist rival mad when hand drift citizen safe reward order ill";

module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*"
    },
    ropsten: {
      provider: new HDWalletProvider(mnemonic, "https://ropsten.infura.io/"+infura_apikey),
      network_id: 3,
      gas: 4612388,
      gasPrice: 2776297000
    }
  }
}