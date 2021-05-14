require_relative 'piece'
require_relative 'slideable'

class Bishop < Piece
  include Slideable

  def symbol
    # return unicode symbol based on color
    @color == :white ? "\u2657" : "\u265D"
  end
  
  protected

  def move_dirs
    [DIAGONAL_DIRS]
  end
end