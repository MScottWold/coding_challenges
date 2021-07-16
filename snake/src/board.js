const Snake = require('./snake');

class Board {
  constructor() {
    this.snake = new Snake;
    this.currentDir = 'N';
    this.generateApple();
    this.canTurn = true;
    this.score = 0;
  }

  generateApple() {
    this.apple = [
      Math.floor(Math.random() * 20),
      Math.floor(Math.random() * 20)
    ];
  }

  move() {
    const deltaPos = Board.DIRECTIONS[this.currentDir];
    const nextPos = this.snake.nextHeadPos(deltaPos);

    if (nextPos[0] === this.apple[0] && nextPos[1] === this.apple[1]) {
      this.snake.addSegment(nextPos, deltaPos);
      this.score += 1;
      this.generateApple();
    } else {
      this.snake.move(deltaPos);
    }
    this.snake.canTurn = true;
  }

  turn(dir) {
    if (!this.isOpposite(dir) && this.canTurn) {
      this.currentDir = dir;
      this.canTurn = false;
    }
  }

  isOpposite(dir) {
    if ((this.currentDir === 'N' && dir === 'S') ||
      (this.currentDir === 'S' && dir === 'N') ||
      (this.currentDir === 'E' && dir === 'W') ||
      (this.currentDir === 'W' && dir === 'E')) {
      return true;
    }
    return false;
  }

  isOver() {
    if (this.outOfBounds() || this.snake.ateSelf()) {
      return true;
    }

    return false;
  }

  outOfBounds() {
    const headCoord = this.snake.head().coord;

    return headCoord[0] < 0 ||
      headCoord[0] > 19 ||
      headCoord[1] < 0 ||
      headCoord[1] > 19;
  }
}

Board.DIRECTIONS = {
  'N': [-1, 0],
  'S': [1, 0],
  'E': [0, 1],
  'W': [0, -1]
}

module.exports = Board;