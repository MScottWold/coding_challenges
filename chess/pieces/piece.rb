class Piece
  attr_reader :board, :pos, :color

  def initialize(color, pos, board)
    @color = color
    @pos = pos
    @board = board
  end

  def valid_moves
    self.moves.delete_if do |pos|
      move_into_check?(pos)
    end
  end

  def enemy_piece?(piece)
    self.color != piece.color &&
      !(piece.is_a? NullPiece)
  end

  def on_board?(pos)
    pos.all? { |coord| coord.between?(0,7) }
  end

  def pos=(new_pos)
    @pos = new_pos
  end

  def inspect
    symbol
  end

  # private

  def move_into_check?(end_pos)
    board_dup = board.deep_dup

    piece = board_dup[pos]
    board_dup[end_pos] = piece
    piece.pos = end_pos
    board_dup[pos] = NullPiece.instance

    board_dup.in_check?(color)
  end
end