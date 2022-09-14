
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./IERC20.sol";

contract StakingWithMultipleTokenRewards is Ownable{
    mapping (address => uint) public userTotalStaking;
    mapping (address => uint) public userRewardRate;
    mapping (address => mapping(address => uint)) public userStakedForTokens;
    mapping (address => mapping(address => uint)) public  userTokenStakingTime;
    mapping (address => mapping (address => uint)) public rewardsGainedByTheUser;
    IERC20 public immutable stakingToken;
    IERC20 public immutable rewardToken1;
    IERC20 public immutable rewardToken2;
    uint public totalTokensStaked;

    constructor(address _stakingToken, address _rewardToken1, address _rewardToken2){
        stakingToken = IERC20(_stakingToken);
        rewardToken1 = IERC20(_rewardToken1);
        rewardToken2 = IERC20(_rewardToken2);

    }

    function stake(uint _amount, address _rewardToken) public{
        require(_amount > 0, "Ammount should be > 0");
        require(stakingToken.transferFrom(msg.sender, address(this), _amount) == true, "" );
        userTotalStaking[msg.sender] += _amount;
        userStakedForTokens[msg.sender][_rewardToken] += _amount;
        if(userRewardRate[msg.sender] == 0){
            //NOTE: just tempararly
            userRewardRate[msg.sender] = 2;
        }


    }

    function withdrawStakedTokens() public {

    }

    function withdrawRewards(address _rewardToken) public {

    }

    function updateUserRewards() public onlyOwner {

    }
}