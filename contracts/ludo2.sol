// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

contract Ludogames {

    uint minimum = 1;
    uint maximum = 6;
    uint maximumPlayers = 4;
    uint facesOfDice = 6;

    // Mapping to check if a player is registered
    mapping(string => bool) registeredPlayers;

    // Mapping to store players' dice roll scores
    mapping(string => uint[]) scoreBoard;

    // Array to store player names for easy access
    string[] public playerNames;

    // Constructor to initialize the players
    constructor(uint _maximumPlayers, string[] memory names) {
        require(_maximumPlayers <= 4, "The maximum number exceeds the limit");
        require(_maximumPlayers > 0, "At least one player must play");
     //   require(names.length == _maximumPlayers, "Names array length must match the number of players");

        // Register the players and add to the playerNames array
        for (uint i = 0; i < _maximumPlayers; i++) {
            registeredPlayers[names[i]] = true;
            playerNames.push(names[i]);
        }
    }

    // Function to simulate playing Ludo by rolling the dice
    function playLudo(string memory name) external {
        require(registeredPlayers[name] == true, "You must register first");

        // Simulate dice roll between 1 and 6
        uint diceRoll = randomDiceRoll();

        // Store the dice roll in the player's scoreBoard
        scoreBoard[name].push(diceRoll);
    }

    // Function to get the scores of a player
    function getPlayerScores(string memory name) public view returns (uint[] memory) {
        return scoreBoard[name];
    }

    // Function to calculate the total score of a player
    function calculateTotalScore(string memory name) public view returns (uint) {
        uint[] memory scores = scoreBoard[name];
        uint totalScore = 0;
        for (uint i = 0; i < scores.length; i++) {
            totalScore += scores[i];
        }
        return totalScore;
    }

    // Function to determine the winner (player with the highest total score)
    function determineWinner() public view returns (string memory) {
        string memory winner;
        uint highestScore = 0;

        // Loop through all players to calculate their total scores
        for (uint i = 0; i < playerNames.length; i++) {
            string memory playerName = playerNames[i];
            uint totalScore = calculateTotalScore(playerName);

            // Check if the current player has the highest score
            if (totalScore > highestScore) {
                highestScore = totalScore;
                winner = playerName;
            }
        }

        return winner;
    }

    // Function to generate a pseudo-random dice roll between 1 and 6
    function randomDiceRoll() private view returns (uint) {
        return (uint(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % facesOfDice) + 1;
    }
}
