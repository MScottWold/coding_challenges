module Slideable
  HORIZONTAL_DIRS = [
    [-1,  0],
    [ 0, -1],
    [ 0,  1],
    [ 1,  0]
  ]

  DIAGONAL_DIRS = [
    [-1, -1],
    [-1,  1],
    [ 1, -1],
    [ 1,  1],
  ]

  def moves
    moves = Array.new

    move_dirs.each do |dir|
      dir.each do |dx, dy|
        moves += grow_unblocked_path_in_dir(dx, dy)
      end
    end

    moves
  end

  private

  def move_dirs
    [HORIZONTAL_DIRS, DIAGONAL_DIRS]
  end

  def grow_unblocked_path_in_dir(dx, dy)
    x, y = pos
    positions = Array.new
    
    while true
      next_pos = [x + dx, y + dy]
      break unless open_position?(next_pos)
      positions << next_pos
      break unless board[next_pos].is_a? NullPiece
      x, y = next_pos
    end

    positions
  end

  def open_position?(position)
    position.all? { |coord| coord.between?(0,7) } &&
      board[position].color != self.color
  end
end