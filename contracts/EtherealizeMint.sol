pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/token/StandardToken.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';


contract EtherealizeMint is StandardToken, Ownable {
    // Set a name for the token
    string public name = "EtherealizeMint";
    // Set a symbol for the token
    string public symbol = "ETR";
    // Specify to what number of decimals the token be divisible to. Make 1:1 with gwei.
    uint public decimals = 3;
        // Holds the funds target wallet address for a percentage of minted tokens to be sent to.
    address public fundWallet;

    event Mint(address indexed to, uint256 amount);
    event MintFinished();

    bool public mintingFinished = false;

    modifier canMint() {
        require(!mintingFinished);
        _;
    }

    /**
    * @dev Function to stop minting new tokens.
    * @return True if the operation was successful.
    */
    function finishMinting() onlyOwner canMint public returns (bool) {
        mintingFinished = true;
        MintFinished();
        return true;
    }

    /**
    * @dev Function to set fundAddress. This address is where fund minted tokens are destined for.
    * @param _targetAddress The address that will receive the minted tokens.
    * @return A boolean that indicates if the operation was successful.
    */
    function setFundWallet(address _targetAddress) onlyOwner public returns (bool) {
        fundWallet = _targetAddress;
        return true;
    }

    /**
    * @dev Function that mints tokens to the fund address based on a multiplier
    * @param _amount The amount of tokens to mint.
    * @return A boolean that indicates if the operation was successful.
    */
    function mintTokensForFund(uint256 _amount) onlyOwner canMint public returns (bool) {
        // Specify the divisble number for percentage calculations
        // uint256 hundred = 100;
        // Specify the factor of minted tokens that go to the fund. Will be divided by 100 to form a precentage
        // uint256 tokenForFundFactor = 3; 
        uint256 tokenAmountToFund = _amount; 
        totalSupply = totalSupply.add(tokenAmountToFund);
        balances[fundWallet] = balances[fundWallet].add(tokenAmountToFund); 
        Mint(fundWallet, tokenAmountToFund);
        Transfer(address(0), fundWallet, tokenAmountToFund);
        return true;
    }

    /**
    * @dev Function that overrides MintableToken mint implmentation
    * @param _to The address that will receive the minted tokens.
    * @param _amount The amount of tokens to mint.
    * @return A boolean that indicates if the operation was successful.
    */
    function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
        // bool isFundMinted = mintTokensForFund(_amount);
        // require(isFundMinted == true);
        mintTokensForFund(_amount);
        totalSupply = totalSupply.add(_amount);
        balances[_to] = balances[_to].add(_amount);
        Mint(_to, _amount);
        Transfer(address(0), _to, _amount);
        return true;
    }

    /**
    * @dev Function to mint tokens
    * @param _to The address that will receive the minted tokens.
    * @param _amount The amount of tokens to mint.
    * @return A boolean that indicates if the operation was successful.
    */
    // function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
    //     totalSupply = totalSupply.add(_amount);
    //     balances[_to] = balances[_to].add(_amount);
    //     Mint(_to, _amount);
    //     Transfer(address(0), _to, _amount);
    //     return true;
    // }
}