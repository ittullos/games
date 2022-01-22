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
  const cell = event.target
  const cellNumber = cell.dataset.index;
  if (cell.innerText != ""){
    return;
  }
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
};

// Add event listeners
cells.forEach((cell) => cell.addEventListener('click', cellClick));
playAgain.addEventListener('click', startNewGame);
