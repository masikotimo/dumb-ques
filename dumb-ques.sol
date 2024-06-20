// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DumbQuesScore {

    IERC20 public thetaToken;
    address public owner;
    uint age;

    struct Game {
        string teamName; // team address , gameId uuid 
        uint256 score;
        bool isRecorded;
    }

    mapping(uint256 => Game) public games;
    uint256 public gameCounter;

    event GameEnded(uint256 gameId, string teamName, uint256 score);
    event RewardDistributed(address team, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    constructor(address _thetaToken) {
        thetaToken = IERC20(_thetaToken);
        owner = msg.sender;
    }

    function saveGameScores(string memory teamName, uint256 score) public onlyOwner {
        gameCounter++;
        games[gameCounter] = Game(teamName, score, true);
        emit GameEnded(gameCounter, teamName, score);
    }
    function setAge(uint x) public  {
        age =x;
    }
    function getAge() public view returns (uint)  {
        return  age;
    }

    function distributeReward(address team, uint256 amount) public onlyOwner {
        require(thetaToken.transfer(team, amount), "Token transfer failed");
        emit RewardDistributed(team, amount);
    }

    function getGameDetails(uint256 gameId) public view returns (string memory, uint256, bool) {
        Game memory game = games[gameId];
        return (game.teamName, game.score, game.isRecorded);
    }
    
    function getAllGameDetails() public view returns (string[] memory, uint256[] memory, bool[] memory) {
        string[] memory teamNames = new string[](gameCounter);
        uint256[] memory scores = new uint256[](gameCounter);
        bool[] memory isRecordedArr = new bool[](gameCounter);

        for (uint256 i = 1; i <= gameCounter; i++) {
            Game storage game = games[i];
            teamNames[i - 1] = game.teamName;
            scores[i - 1] = game.score;
            isRecordedArr[i - 1] = game.isRecorded;
        }

        return (teamNames, scores, isRecordedArr);
    }
}
