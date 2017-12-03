pragma solidity ^0.4.4;

import 'zeppelin-solidity/contracts/token/MintableToken.sol';

// Define a contract
contract EtherealizeMint is MintableToken {
    // Set a name for the token
    string public name = "EtherealizeMint";
    // Set a symbol for the token
    string public symbol = "ETR";
    // Specify to what number of decimals the token be divisible to
    uint public decimals = 0;
    // Specify the owner wallet address to have percentage of minted tokens sent to.
    address public wallet;
    // Specify to what number of decimals the token be divisible to
    uint public decimals = 0;

    /**
    * @dev Function to set fundAddress for minted tokens
    * @param _ownerAddress The address that will receive the minted tokens.
    * @return A boolean that indicates if the operation was successful.
    */
    function setFundAddress(address _ownerAddress) onlyOwner public returns (bool){
        wallet = _ownerAddress;
        return true;
    }

    /**
    * @dev Function that overrides MintableToken mint implmentation
    * @param _to The address that will receive the minted tokens.
    * @param _amount The amount of tokens to mint.
    * @return A boolean that indicates if the operation was successful.
    */
    function mintTokensForFund(uint256 _amount) onlyOwner canMint public returns (bool) {
        totalSupply = totalSupply.add(_amount);
        balances[_to] = balances[_to].add(_amount);
        Mint(_to, _amount);
        Transfer(address(0), _to, _amount);
        mintTokensForFund()
        return true;
    }

    /**
    * @dev Function that overrides MintableToken mint implmentation
    * @param _to The address that will receive the minted tokens.
    * @param _amount The amount of tokens to mint.
    * @return A boolean that indicates if the operation was successful.
    */
    function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
        totalSupply = totalSupply.add(_amount);
        balances[_to] = balances[_to].add(_amount);
        Mint(_to, _amount);
        Transfer(address(0), _to, _amount);
        mintTokensForFund(_amount);
        return true;
    }

}