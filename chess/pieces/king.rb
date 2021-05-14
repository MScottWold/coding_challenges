require_relative 'piece'
require_relative 'stepable'

class King < Piece
  include Stepable

  def symbol
    # return unicode symbol based on color
    @color == :white ? "\u2654" : "\u265A"
  end

  protected

  def move_diffs
    [
    [-1, -1],
    [-1,  0],
    [-1,  1],
    [ 0, -1],
    [ 0,  1],
    [ 1, -1],
    [ 1,  0],
    [ 1,  1],
    ]
  end
end