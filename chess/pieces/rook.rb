require_relative 'piece'
require_relative 'slideable'

class Rook < Piece
  include Slideable

  def symbol
    # return unicode symbol based on color
    @color == :white ? "\u2656" : "\u265C"
  end

  protected

  def move_dirs
    [HORIZONTAL_DIRS]
  end
end