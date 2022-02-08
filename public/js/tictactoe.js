if (document.title != "Tic Tac Toe") {
    document.title = "Tic Tac Toe";
}
// Get elements & define variables
const cells = document.querySelectorAll('.cell');
const strike = document.querySelector('#strike');
const gameSize = cells.length;
const gameBoard = new Array(gameSize);

gameBoard.fill('null');

const gameOverArea = document.querySelector('#game-over-area');
const gameOverText = document.querySelector('#game-over-text');
const playAgain = document.querySelector('#play-again');;

const PLAYER_X = 'X';
const PLAYER_O = 'O';

let turn= PLAYER_X;

// Audio variables
const gameOverSound1 = new Audio("./sounds/game_over_1.wav");
const gameOverSound2 = new Audio("./sounds/game_over_2.wav");
const clickSoundX = new Audio ("./sounds/click_2.wav");
const clickSoundO = new Audio ("./sounds/click_3.wav");

// Variables to control state
const boardView = document.querySelector('.board');
const playerRole = getQueryVariable("role");

const generateToken = role => {
  if (role == "host") {
    return "X";
  }
  else {
    return "O";
  }
}
const playerToken = generateToken(playerRole);
var playCount = 0;
var gameStarted = false;

console.log(playerRole);

const rivalRefresh = setInterval(function() {
  const request = new XMLHttpRequest();
  request.open('GET', '/rival_refresh', true);
  request.onload = function() {
    if (this.status >= 200 && this.status < 400) {
      let rivalJoined = this.response;
      if (rivalJoined == "true") {
        boardView.id = "visible"
        clearInterval(rivalRefresh);
      }
    }
  };
  request.onerror = function() {
  };
  request.send();



}, 1000);

const gameStartRefresh = setInterval(function() {
  // console.log("game_start");
  if (boardView.id == "visible") {
    const lobbyId = getQueryVariable("lobby_id");
    gameStarted = true;
    const gameData = {
      game_started: "true",
      lobby_id: lobbyId
    };
    if (playerRole == "rival") {
      postJson(gameData, "/game_start");
    }
    clearInterval(gameStartRefresh);
    return;
  }
}, 1000);

const playRefresh = setInterval(function() {
  console.log("play refresh start ^");
  if (gameStarted === true) {
    const request = new XMLHttpRequest();
    request.open('GET', '/play_refresh', true);
    request.onload = function() {
      if (this.status >= 200 && this.status < 400) {
        let play_info = JSON.parse(this.response);
        console.log(`playCount: ${playCount}`);
        if (play_info.play_number > playCount) {
          console.log("playCount is off =>");

          cellNumber = play_info.cell_id;
          cells[cellNumber - 1].innerText = play_info.token;
          gameBoard[cellNumber - 1] = play_info.token;
          if (playerToken != turn) {
            if (play_info.token === PLAYER_X) {
              clickSoundX.play();
              turn = PLAYER_O;
            }else {
              clickSoundO.play();
              turn = PLAYER_X;
            }

          }
          setCellHover();
          winnerCheck();
          playCount = play_info.play_number;
        }
      }
    };
    request.onerror = function() {
    };
    request.send();
  }
}, 1000);

function getQueryVariable(variable) {
  const query = window.location.search.substring(1);
  const vars = query.split("&");
  for (var i = 0; i < vars.length; i++) {
    const pair = vars[i].split("=");
    if (pair[0] == variable) {return pair[1];}
  }
  return false;
}

//Data Structure to store winning combos
const winningCombos = [
  //rows
  { combo: [1, 2, 3], strikeClass: "strike-row-1" },
  { combo: [4, 5, 6], strikeClass: "strike-row-2" },
  { combo: [7, 8, 9], strikeClass: "strike-row-3" },
  //columns
  { combo: [1, 4, 7], strikeClass: "strike-column-1" },
  { combo: [2, 5, 8], strikeClass: "strike-column-2" },
  { combo: [3, 6, 9], strikeClass: "strike-column-3" },
  //diagonals
  { combo: [1, 5, 9], strikeClass: "strike-diagonal-1" },
  { combo: [3, 5, 7], strikeClass: "strike-diagonal-2" }
];

// Define functions
const winnerCheck = () => {
  // Check for winner
  for (let i = 0; i < winningCombos.length; i++) {
    let winningCombo = winningCombos[i].combo;
    let boardCombo = [];

    winningCombo.forEach((cell) => boardCombo.push(`${gameBoard[cell - 1]}`));

    if (boardCombo.every((val, ind, arr) => val === arr[0]) &&
        boardCombo[0] != 'null') {
      strike.classList.add(winningCombos[i].strikeClass);
      gameOverDisplay(boardCombo[0]);
      return;
    }
  }
  //Check for tie
  const catScratch = gameBoard.every((cell) => cell !== 'null')
  if (catScratch) {
    gameOverDisplay('null');
  }
};

const gameOverDisplay = winner => {
  let message = 'Tie!';
  if (winner != 'null') {
    message = `${winner} is the Winner!`;
    if (playerToken == winner) {
      winner_info = {
        winner_flag: true
      }
      postJson(winner_info, '/winner_log');
    }
  }
  gameOverArea.className = 'visible';
  gameOverText.innerText = message;
  gameOverSound1.play();
  gameOverSound2.play();
};

const cellClick = event => {
  if (gameOverArea.classList.contains('visible')) {
    return;
  }
  const cell = event.target;
  const cellNumber = cell.dataset.index;
  if (cell.innerText != "") {
    return;
  }
  if (playerToken != turn) {
    return;
  }

  let playInfo = {
    play_number: playCount,
    cell_id: cellNumber,
    token: playerToken
  }

  postJson(playInfo, "/play_maker");

  cell.innerText = turn;
  gameBoard[cellNumber - 1] = turn;
  if (turn === PLAYER_X) {
    clickSoundX.play();
    turn = PLAYER_O;
  }else {
    clickSoundO.play();
    turn = PLAYER_X;
  }

  setCellHover();
  winnerCheck();
  playCount += 1;
};

const setCellHover = () => {
  cells.forEach((cell) => {
    cell.classList.remove("x-hover");
    cell.classList.remove("o-hover");
  });

  const newHoverClass = `${turn.toLowerCase()}-hover`;
  cells.forEach(cell => {
    if (cell.innerText == "") {
      cell.classList.add(newHoverClass)
    }
  });
};

const startNewGame = () => {
  strike.className = "strike";
  gameOverArea.className = "hidden";
  gameBoard.fill('null');
  cells.forEach((cell) => cell.innerText = "");
  turn = PLAYER_X;
  setCellHover();
  playCount = 0;
  if (playerToken == 'X') {
    playerToken = 'O'
  }
  else {
    playerToken = 'X'
  }
  if (playerRole == "rival") {
    const lobbyId = getQueryVariable("lobby_id");
    const gameData = {
      game_started: "true",
      lobby_id: lobbyId
    };
    postJson(gameData, "/game_start");
  }
}

const postJson = (obj, url) => {
  const jsonString = JSON.stringify(obj);
  let request = new XMLHttpRequest();

  request.open("POST", url, true);
  request.setRequestHeader("Content-Type", "application/json");

  request.send(jsonString);
}

// Add event listeners
cells.forEach((cell) => cell.addEventListener('click', cellClick));
playAgain.addEventListener('click', startNewGame);
