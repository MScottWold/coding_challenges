class Segment {
  constructor(coord) {
    this.coord = coord;
    this.nextCoords = []
  }

  addCoord(coord) {
    this.nextCoords.push(coord);
  }

  move(coord) {
    this.addCoord(coord); 
    this.coord = this.nextCoord(this.nextCoords.shift());
  }

  nextCoord(deltaPos) {
    return [this.coord[0] + deltaPos[0], this.coord[1] + deltaPos[1]];
  }

  equals(coord) {
    return this.coord[0] === coord[0] && this.coord[1] === coord[1];
  }
}

module.exports = Segment;