const GameView = require('./game_view.js');
const Board = require('./board.js');

$(() =>{
  const gameView = new GameView(new Board, $('.game'));
})