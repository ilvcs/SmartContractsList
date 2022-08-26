// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract USDCPriceOracle {

    // For owner
    address owner;
    //mapping from jobId => completion status for smart contract interactions to check;
    //default false for all + non-existent
    mapping(uint => bool) public jobStatus;

    //mapping jobId => temp result. Defaultfor no result is 0.
    //A true jobStatus with a 0 job value implies the result is actually 0
    mapping(uint => uint) public jobResults;

    //current jobId available
    uint currentJobId;

    //event to trigger Oracle API
    event NewJob(uint jobId);
    
    constructor(uint _initialId){
        require(msg.sender != address(0));
        owner = msg.sender;
        currentJobId = _initialId;
    } 

    function getUSDCPrice() public {
        //emit event to API with data and JobId
        emit NewJob(currentJobId);
        //increment jobId for next job/function call
        currentJobId++;
    }

    function updatePrice(uint256 _price, uint _jobId)public {
        //when update is called by node.js upon API results, data is updated
        jobResults[_jobId] = _price;
        jobStatus[_jobId] = true;
    }
}