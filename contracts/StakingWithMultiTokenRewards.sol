
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "openzeppelin-solidity/contracts/utils/math/SafeMath.sol";
import "./IERC20.sol";

contract StakingWithMultipleTokenRewards is Ownable{
    using SafeMath for uint256;

    mapping (address => uint) public userTotalStaking;
    mapping (address => uint) public userRewardRate;
    mapping (address => mapping(address => uint)) public userStakedForTokens;
    mapping (address => mapping(address => uint)) public  userTokenStakingTime;
    mapping (address => uint) public  userWithdrawalTime;
    mapping (address=> mapping(address => uint)) public  rewardsPaidToTheUserPerToken;

    // mapping (address => mapping (address => uint)) public rewardsGainedByTheUser;
    IERC20 public immutable stakingToken;
    IERC20 public immutable rewardToken1;
    IERC20 public immutable rewardToken2;
    

    constructor(address _stakingToken, address _rewardToken1, address _rewardToken2){
        stakingToken = IERC20(_stakingToken);
        rewardToken1 = IERC20(_rewardToken1);
        rewardToken2 = IERC20(_rewardToken2);

    }

    function stake(uint _amount, address _rewardToken) public{
        require(_amount > 0, "Ammount should be > 0");
        require(stakingToken.transferFrom(msg.sender, address(this), _amount) == true, "Token transfer failed" );
        userTotalStaking[msg.sender] += _amount;
        uint userExistingTokensForRewardToken = userStakedForTokens[msg.sender][_rewardToken];
        uint newStaking = userExistingTokensForRewardToken.add(_amount);
        userStakedForTokens[msg.sender][_rewardToken] = newStaking;
        if(userRewardRate[msg.sender] == 0){
            //NOTE: just tempararly
            userRewardRate[msg.sender] = 2;
        }
        userTokenStakingTime[msg.sender][_rewardToken] = block.timestamp;

    }

    function withdrawStakedTokens() public returns(bool){
        uint _userStakedBalance = userTotalStaking[msg.sender];
        require( _userStakedBalance > 0, "User has no stake");
        require(stakingToken.transfer(msg.sender, _userStakedBalance) == true, "Token transfer faild" );
        userTotalStaking[msg.sender] = 0;
        uint256 userRewardForToken1 = userRewardsForTheToken(address(rewardToken1));
        uint256 userRewardForToken2 = userRewardsForTheToken(address(rewardToken2));
        userStakedForTokens[msg.sender][address(rewardToken1)] = 0;
        userStakedForTokens[msg.sender][address(rewardToken2)] = 0;
        userWithdrawalTime[msg.sender] = block.timestamp;
        if(userRewardForToken1 > 0){
            require(rewardToken1.approve(msg.sender, userRewardForToken1),"Reward token1 not approved");
            require(rewardToken1.transferFrom(address(this), msg.sender,userRewardForToken1 ), "Reward withdral faild");
            rewardsPaidToTheUserPerToken[msg.sender][address(rewardToken1)].add(userRewardForToken1) ;
        }
        if(userRewardForToken2 > 0){
            require(rewardToken2.approve(msg.sender, userRewardForToken1),"Reward token2 not approved");
            require(rewardToken2.transferFrom(address(this),msg.sender,userRewardForToken2 ), "Reward withdral faild");
            rewardsPaidToTheUserPerToken[msg.sender][address(rewardToken2)].add(userRewardForToken2) ;
        }
        return true;
    }

  
    // This approach is just for testing, not legit approach for production
    function updateUserRewards(address _user, address _rewardToken) public  onlyOwner {
      require(msg.sender != address(0));
      require(_user != address(0));
      require(userStakedForTokens[_user][_rewardToken] > 0, "User needs to stake tokens");
      require(userTokenStakingTime[_user][_rewardToken] < block.timestamp, "User staking time is invalid");
      uint dayInSec = 24 * 60 * 60;
      userTokenStakingTime[_user][_rewardToken].sub(dayInSec);
    }

    function userRewardsForTheToken(address _rewardToken) public view returns(uint){
        // timediffreence in sec + yearly reward rate + 
      uint stakingBalanceForToken =  userStakedForTokens[msg.sender][_rewardToken];
      uint timeDiffrence = block.timestamp - userTokenStakingTime[msg.sender][_rewardToken];
      uint rewardRateForToken = userRewardRate[msg.sender];
      uint yearlyTokenReward = stakingBalanceForToken.mul(rewardRateForToken).div(100);
      uint rewardsForSecond = yearlyTokenReward.div(31536000);
      uint totalUserRewardsForUser =   timeDiffrence  * rewardsForSecond;
     
      return totalUserRewardsForUser -  rewardsPaidToTheUserPerToken[msg.sender][_rewardToken];
    }
}












