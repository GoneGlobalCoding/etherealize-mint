pragma solidity ^0.4.18;
 
 
/*
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20Basic {
  uint256 public totalSupply;
  function balanceOf(address who) public view returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}
 
 
 
/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;
 
 
  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
 
 
  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function Ownable() public {
    owner = msg.sender;
  }
 
 
  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }
 
 
  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) onlyOwner public {
    require(newOwner != address(0));
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }
 
}
 
 
/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }
 
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }
 
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }
 
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}
 
 
/**
 * @title Basic token
 * @dev Basic version of StandardToken, with no allowances.
 */
contract BasicToken is ERC20Basic {
  using SafeMath for uint256;
 
  mapping(address => uint256) balances;
 
  /**
  * @dev transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[msg.sender]);
 
    // SafeMath.sub will throw if there is not enough balance.
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    Transfer(msg.sender, _to, _value);
    return true;
  }
 
  /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address _owner) public view returns (uint256 balance) {
    return balances[_owner];
  }
 
}
 
 
/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender) public view returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}
 
 
 
/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * @dev https://github.com/ethereum/EIPs/issues/20
 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract StandardToken is ERC20, BasicToken {
 
  mapping (address => mapping (address => uint256)) internal allowed;
 
 
  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);
 
    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    Transfer(_from, _to, _value);
    return true;
  }
 
  /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   *
   * Beware that changing an allowance with this method brings the risk that someone may use both the old
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param _spender The address which will spend the funds.
   * @param _value The amount of tokens to be spent.
   */
  function approve(address _spender, uint256 _value) public returns (bool) {
    allowed[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);
    return true;
  }
 
  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param _owner address The address which owns the funds.
   * @param _spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  function allowance(address _owner, address _spender) public view returns (uint256) {
    return allowed[_owner][_spender];
  }
 
  /**
   * approve should be called when allowed[_spender] == 0. To increment
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   */
  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }
 
  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
    uint oldValue = allowed[msg.sender][_spender];
    if (_subtractedValue > oldValue) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
    }
    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }
 
}
 
 
 
// Define a contract
contract LoveCoinMint is StandardToken, Ownable {
  // Set a name for the token
  string public name = "LoveCoin";
  // Set a symbol for the token
  string public symbol = "LOVE";
  // Specify to what number of decimals the token be divisible to. Make 1:1 with gwei.
  uint public decimals = 18;
  // Holds the funds target wallet address for a percentage of minted tokens to be sent to.
  address public fundWallet;
  // Set canTransfer to false by default to avoid ability for individuals to wash trade during ICO
  bool public isTransferEnabled = false;

  event Mint(address indexed to, uint256 amount);
  event MintFinished();
  event TransferFlag(string message);

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
      require(_targetAddress != address(0));
      fundWallet = _targetAddress;
      return true;
  }

  /**
  * @dev Function that mints tokens to the fund address based on a multiplier
  * @param _amount The amount of tokens to mint.
  * @return A boolean that indicates if the operation was successful.
  */
  function mintTokensForFund(uint256 _amount) onlyOwner canMint public returns (bool) {
      totalSupply = totalSupply.add(_amount);
      balances[fundWallet] = balances[fundWallet].add(_amount);
      Mint(fundWallet, _amount);
      Transfer(address(0), fundWallet, _amount);
      return true;
  }

  /**
  * @dev Function that overrides MintableToken mint implmentation
  * @param _to The address that will receive the minted tokens.
  * @param _amount The amount of tokens to mint.
  * @return A boolean that indicates if the operation was successful.
  */
  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
      mintTokensForFund(_amount);
      totalSupply = totalSupply.add(_amount);
      balances[_to] = balances[_to].add(_amount);
      Mint(_to, _amount);
      Transfer(address(0), _to, _amount);
      return true;
  }
  
  modifier transferEnabled() {
      if (isTransferEnabled) {
          TransferFlag("Transferring of tokens is enabled. Proceeding.");
      } else {
          TransferFlag("Transferring of tokens is disabled. Cannot proceed until contract enables transfer capability.");
      }
      require(isTransferEnabled);
      _;
  }
  /**
   * OVERRIDE INHERITED CLASS TO CONTAIN MODIFIER
   * @dev transfer token for a specified address
   * @param _to The address to transfer to.
   * @param _value The amount to be transferred.
   */
  function transfer(address _to, uint256 _value) transferEnabled public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[msg.sender]);
 
    // SafeMath.sub will throw if there is not enough balance.
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    Transfer(msg.sender, _to, _value);
    return true;
  }
  
  function setTransferStatus(bool _status) onlyOwner public {
      require(_status == true || _status == false);
      isTransferEnabled = _status;
  }
 
}
 
/**
 * @title LoveCoinPresale
 * @dev LoveCoinPresale is a base contract for managing a token crowdsale.
 * Crowdsales have a start and end timestamps, where investors can make
 * token purchases and the crowdsale will assign them tokens based
 * on a token per ETH rate. Funds collected are forwarded to a wallet
 * as they arrive.
 */
contract LoveCoinPresale is Ownable {
  using SafeMath for uint256;
  /* The token being sold */
  LoveCoinMint public token;
  /* Start and end timestamps where investments are allowed (both inclusive) */
  uint256 public startTime;
  uint256 public endTime;
  /* Address where funds are collected */
  address public wallet;
  /* How many token units a buyer gets per wei */
  uint256 public rate;
  /* Amount of raised money in wei */
  uint256 public weiRaised;
  /* Amount of wei that results in no further funds being able to produce more tokens */
  uint256 public weiHardcap;
  /* Flag to inform the contract that bonuses have been defined and that crowdsale may not begin until they are set. Default false. */
  bool public contributionBonusesSet = false;
  /* Set up bonus thresholds in Wei for contributions*/
  uint256 public maxTierWei;
  uint256 public secondTierWei;
  uint256 public thirdTierWei;
  uint256 public fourthTierWei;
  uint256 public fifthTierWei;
  /* Set up bonus multipliers based off above tiers for contributions */
  uint256 public maxTierBonus;
  uint256 public secondTierBonus;
  uint256 public thirdTierBonus;
  uint256 public fourthTierBonus;
  uint256 public fifthTierBonus;
  uint256 public hundredPercent = 100;
  /* Flag to inform the contract that time bonuses have not been defined and that crowdsale may not begin until they are set. Default false. */
  bool public timeBonusesSet = false;
  /* Set up bonus threshold durations for time */
  uint256 public firstTimeBonusDuration;
  uint256 public secondTimeBonusDuration;
  uint256 public thirdTimeBonusDuration;
  uint256 public fourthTimeBonusDuration;
  /* Set up bonus multipliers based off above times*/
  uint256 public firstTimeBonus;
  uint256 public secondTimeBonus;
  uint256 public thirdTimeBonus;
  uint256 public fourthTimeBonus;
  /* Set up consts for crowdsale status*/
  string public constant LIVE = "LIVE";
  string public constant UPCOMING = "UPCOMING";
  string public constant ENDED = "ENDED";
  /* Set up minimum wei contribution */
  uint256 public minimumWei;
  /**
  * event for token purchase logging
  * @param purchaser who paid for the tokens
  * @param beneficiary who got the tokens
  * @param value weis paid for purchase
  * @param amount amount of tokens purchased
  */
  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
  event TotalRateDecision(uint256 value);
  event ContributionBonusDecision(uint256 value);
  event TimeBonusDecision(uint256 value);

  function LoveCoinPresale() public {
  }

  function setupCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _weiHardcap, address _wallet, address _tokenAddress) onlyOwner public {
    require(_startTime >= now);
    require(_endTime >= _startTime);
    require(_weiHardcap > 0);
    require(_rate > 0);
    require(_wallet != address(0));
    require(_tokenAddress != address(0));
    require(contributionBonusesSet != false);
    require(timeBonusesSet != false);
    token = LoveCoinMint(_tokenAddress);
    token.setFundWallet(_wallet);
    startTime = _startTime;
    endTime = _endTime;
    rate = _rate;
    weiHardcap = _weiHardcap;
    wallet = _wallet;
  }

  function setStartTime(uint256 _startTime) onlyOwner public {
    require(_startTime >= now);
    startTime = _startTime;
  }

  function setToken(address _tokenAddress) onlyOwner public {
    require(_tokenAddress != address(0));
    token = LoveCoinMint(_tokenAddress);
  }
  
  function setMinimumWei(uint256 _minimumWei) onlyOwner public {
    require(_minimumWei >= 0);
    minimumWei = _minimumWei;
  }

  function setEndTime(uint256 _endTime) onlyOwner public {
    require(startTime > 0);
    require(_endTime >= startTime);
    endTime = _endTime;
  }
  
  function setFundWallet(address _wallet) onlyOwner public {
    require(_wallet != address(0));
    token.setFundWallet(_wallet);
    wallet = _wallet;
  }

  /** External call to token **/
  function setTokenOwner(address _targetAddress) onlyOwner public {
    require(_targetAddress != address(0));
    require(token != address(0));
    token.transferOwnership(_targetAddress);
  }
  
  /** External call to token **/
  function setTransferStatus(bool _status) onlyOwner public{
      require(_status == true || _status == false);
      require(token != address(0));
      token.setTransferStatus(_status);
  }

  function setContributionBonuses(uint256 _maxTierWei, uint256 _secondTierWei, uint256 _thirdTierWei, uint256 _fourthTierWei, uint256 _fifthTierWei, uint256 _maxTierBonus, uint256 _secondTierBonus, uint256 _thirdTierBonus, uint256 _fourthTierBonus, uint256 _fifthTierBonus)  onlyOwner public {
    require(_maxTierWei > 0);
    require(_secondTierWei > 0);
    require(_thirdTierWei > 0);
    require(_fourthTierWei > 0);
    require(_fifthTierWei > 0);
    require(_maxTierBonus > 0);
    require(_secondTierBonus > 0);
    require(_thirdTierBonus > 0);
    require(_fourthTierBonus > 0);
    require(_fifthTierBonus > 0);
    maxTierWei = _maxTierWei;
    secondTierWei = _secondTierWei;
    thirdTierWei = _thirdTierWei;
    fourthTierWei = _fourthTierWei;
    fifthTierWei = _fifthTierWei;
    maxTierBonus = _maxTierBonus;
    secondTierBonus = _secondTierBonus;
    thirdTierBonus = _thirdTierBonus;
    fourthTierBonus = _fourthTierBonus;
    fifthTierBonus = _fifthTierBonus;
    contributionBonusesSet = true;
  }
  
  function setTimeBonuses(uint256 _firstTimeBonusDuration, uint256 _secondTimeBonusDuration, uint256 _thirdTimeBonusDuration, uint256 _fourthTimeBonusDuration, uint256 _firstTimeBonus, uint256 _secondTimeBonus, uint256 _thirdTimeBonus, uint256 _fourthTimeBonus)  onlyOwner public {
    require(_firstTimeBonusDuration > 0);
    require(_secondTimeBonusDuration > 0);
    require(_thirdTimeBonusDuration > 0);
    require(_fourthTimeBonusDuration > 0);
    require(_firstTimeBonus > 0);
    require(_secondTimeBonus > 0);
    require(_thirdTimeBonus > 0);
    require(_fourthTimeBonus > 0);
    firstTimeBonusDuration = _firstTimeBonusDuration;
    secondTimeBonusDuration = _secondTimeBonusDuration;
    thirdTimeBonusDuration = _thirdTimeBonusDuration;
    fourthTimeBonusDuration = _fourthTimeBonusDuration;
    firstTimeBonus = _firstTimeBonus;
    secondTimeBonus = _secondTimeBonus;
    thirdTimeBonus = _thirdTimeBonus;
    fourthTimeBonus = _fourthTimeBonus;
    timeBonusesSet = true;
  }
  
  /* Fallback function can be used to buy tokens */
  function () external payable {
    buyTokens(msg.sender);
  }

  function getBonusRate(uint256 _weiAmount) public returns (uint256) {
    if (_weiAmount >= maxTierWei) {
      ContributionBonusDecision(maxTierBonus);
      return maxTierBonus;
    }
    if (_weiAmount >= secondTierWei) {
      ContributionBonusDecision(secondTierBonus);
      return secondTierBonus;
    }
    if (_weiAmount >= thirdTierWei) {
      ContributionBonusDecision(thirdTierBonus);
      return thirdTierBonus;
    }
    if (_weiAmount >= fourthTierWei) {
      ContributionBonusDecision(fourthTierBonus);
      return fourthTierBonus;
    }
    if (_weiAmount >= fifthTierWei) {
      ContributionBonusDecision(fifthTierBonus);
      return fifthTierBonus;
    }
    ContributionBonusDecision(0);
    return 0;
  }
  
  function getCurrentTimeBonus() public view returns (uint256) {
      uint256 firstThreshold = startTime + firstTimeBonusDuration;
      uint256 secondThreshold = firstThreshold + secondTimeBonusDuration;
      uint256 thirdThreshold = secondThreshold + thirdTimeBonusDuration;
      uint256 fourthThreshold = thirdThreshold + fourthTimeBonusDuration;
      if (now >= startTime && now <= firstThreshold) {
          TimeBonusDecision(firstTimeBonus);
          return firstTimeBonus;
      }
      if (now > firstThreshold && now <= secondThreshold) {
          TimeBonusDecision(secondTimeBonus);
          return secondTimeBonus;
      }
      if (now > secondThreshold && now <= thirdThreshold) {
          TimeBonusDecision(thirdTimeBonus);
          return thirdTimeBonus;
      }
      if ((now > thirdThreshold && now <= fourthThreshold) || (now > thirdThreshold && now <= endTime)) {
          TimeBonusDecision(fourthTimeBonus);
          return fourthTimeBonus;
      }
      return 0;
  }

  function buyTokens(address beneficiary) public payable {
    require(beneficiary != address(0));
    require(validPurchase());
    /* Obtain the value of wei being sent into the contract */
    uint256 weiAmount = msg.value;
    /* Return the bonus rate based off the inserted wei*/
    uint256 bonusRate = getBonusRate(weiAmount);
    /* Return the bonus rate based off time */
    uint256 timeBonus = getCurrentTimeBonus();
    /* Calculate total bonus */
    uint256 totalBonus = bonusRate.add(timeBonus);
    /* Total percentage anchor */
    uint256 totalAnchor = totalBonus.add(100);
    /* Calculate token amount to be created */
    uint256 bonusMultiplier = totalAnchor.mul(rate).div(hundredPercent);
    TotalRateDecision(bonusMultiplier);
    /* Define the final number of tokens needing to be minted */
    uint256 tokens = weiAmount.mul(bonusMultiplier);
    /* Update state */
    weiRaised = weiRaised.add(weiAmount);
    /* Mint tokens from the token contract towards target beneficiaries */
    token.mint(beneficiary, tokens);
    /* Create an event to be logged */
    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
    /* Forward / transfer the received ether towards the target wallet */
    forwardFunds();
  }
 
  /* Send ether to the fund collection wallet */
  function forwardFunds() internal {
    wallet.transfer(msg.value);
  }
 
  /* @return true if the transaction can buy tokens */
  function validPurchase() internal view returns (bool) {
    bool withinPeriod = now >= startTime && now <= endTime;
    bool aboveMinimumPurchase = msg.value > minimumWei;
    bool belowWeiCap = weiRaised < weiHardcap;
    return withinPeriod && aboveMinimumPurchase && belowWeiCap;
  }
 
  /* @return true if crowdsale event has ended */
  function hasEnded() public view returns (bool) {
    if (startTime == 0) {
        return false;
    }
    return now > endTime;
  }
  
  /* @return true if crowdsale is running */
  function isLive() public view returns (bool) {
    if (startTime == 0) {
        return false;
    }
    return now >= startTime && now <= endTime;
  }
  
  /* @return true if crowdsale is upcoming */
  function isUpcoming() public view returns (bool) {
    if (startTime == 0) {
        return false;
    }
    return now < startTime;
  }
  
  function getTimeFromStart() public view returns(uint256) {
      if (now < startTime && startTime != 0) {
          return startTime.sub(now);
      } 
      return 0;
  }
  
  function getTimeFromEnd() public view returns(uint256) { 
      if (now < endTime && endTime != 0) {
          return endTime.sub(now);
      }
  }

  
  function crowdsaleStatus() public view returns(string) {
    if (hasEnded()) {
        return ENDED;
    }
    if (isLive()) {
        return LIVE;
    }
    if (isUpcoming()) {
        return UPCOMING;
    }
    return UPCOMING;
  }
  
}

