class GameView {
  constructor(board, $el) {
    this.board = board;
    this.$el = $el;

    this.setupBoard();
    this.render();
    $(window).on('keydown', this.handleKeyPress.bind(this));

    this.interval = setInterval(() => {
      this.board.move();
      if (this.board.isOver()) {
        clearInterval(this.interval);
        $(window).off('keydown');
        alert(`game over - score: ${this.board.score}`);
      } else {
        this.render();
        this.board.canTurn = true;
      }
    }, 100);
  }

  setupBoard() {
    for (let i = 0; i < 20; i++) {
      const $row = $('<div class="row"></div>');
      for (let j = 0; j < 20; j++) {
        const $square = $('<div></div>');
        $row.append($square);
      }
      this.$el.append($row);
    }
  }

  render() {
    $('.row > div').removeClass();
    const $rows = this.$el.find('.row');

    this.board.snake.tail.forEach((segment) => {
      const pos = segment.coord;
      const $square = $rows.eq(pos[1]).children().eq(pos[0]);

      $square.addClass('snake');
    });

    const $appleSquare = $rows.eq(this.board.apple[1]).children().eq(this.board.apple[0]);
    $appleSquare.addClass('apple');
    $('.score').text(`Score: ${this.board.score}`)
  }

  handleKeyPress(event) {
    const key = event.keyCode
    if (key === 37) {
      this.board.turn('W');
    } else if (key === 38) {
      this.board.turn('N');
    } else if (key === 39) {
      this.board.turn('E');
    } else if (key === 40) {
      this.board.turn('S');
    } else if (key === 32) {
      clearInterval(this.interval);
    }
  }
}

module.exports = GameView;