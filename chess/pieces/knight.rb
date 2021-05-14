require_relative 'piece'
require_relative 'stepable'

class Knight < Piece
  include Stepable

  def symbol
    # return unicode symbol based on color
    @color == :white ? "\u2658" : "\u265E"
  end

  protected

  def move_diffs
    [
    [-2, -1],
    [-2,  1],
    [-1, -2],
    [-1,  2],
    [ 1, -2],
    [ 1,  2],
    [ 2, -1],
    [ 2,  1],
    ]
  end
end