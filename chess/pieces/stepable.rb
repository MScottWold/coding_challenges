module Stepable
  def moves
    x, y = pos
    
    moves = move_diffs.map do |move|
      dx, dy = move
      [x + dx, y + dy]
    end

    moves.select do |move|
      move.all? { |coord| coord.between?(0, 7)} &&
        board[move].color != self.color
    end
  end

  private

  def move_diffs
    [
      [-1,  0],
      [ 0, -1],
      [ 0,  1],
      [ 1,  0],
    ]
  end
end