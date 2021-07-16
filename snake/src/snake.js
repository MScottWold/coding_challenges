const Segment = require('./segment.js');

class Snake {
  constructor() {
    this.tail = [new Segment([10, 10])];
  }

  move(deltaPos) {
    this.tail.forEach((segment) => {
      segment.move(deltaPos);
    });
  }

  addSegment(newSegementCoord, movementCoord) {
    this.tail.forEach((segment) => {
      segment.addCoord(movementCoord);
    });

    this.tail.unshift(new Segment(newSegementCoord));
  }

  nextHeadPos(deltaPos) {
    return this.head().nextCoord(deltaPos);
  }

  head() {
    return this.tail[0];
  }

  ateSelf() {
    const headPos = this.head().coord;
    for (let i = 1; i < this.tail.length; i++) {
      if (this.tail[i].equals(headPos)) {
        return true;
      }
    }
    return false;
  }
}

module.exports = Snake;