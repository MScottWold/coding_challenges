require_relative 'piece'
require_relative 'slideable'

class Queen < Piece
  include Slideable

  def symbol
    # return unicode symbol based on color
    @color == :white ? "\u2655" : "\u265B"
  end
  
  protected

  def move_dirs
    [HORIZONTAL_DIRS, DIAGONAL_DIRS]
  end
end