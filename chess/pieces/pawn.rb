require_relative 'piece'
require_relative 'stepable'

class Pawn < Piece
  include Stepable

  def symbol
    # return unicode symbol based on color
    @color == :white ? "\u2659" : "\u265F"
  end

  def moves
    attack_moves + forward_moves
  end

  private
  
  def attack_moves
    x,y = pos
    attack_spaces = [[forward_dir, 1], [forward_dir, -1]]

    moves = attack_spaces.map do |dx, dy|
      [x + dx, y + dy]
    end

    moves.select do |pos|
      on_board?(pos) &&
        enemy_piece?(board[pos])
    end
  end

  def forward_moves
    x, y = pos
    moves = Array.new

    moves << [x + forward_dir, y]
    moves << [x + (forward_dir * 2), y] if at_start_row?

    moves.reject do |pos| 
      !on_board?(pos) ||
        enemy_piece?(board[pos])
    end
  end

  def forward_dir
    self.color == :white ? -1 : 1
  end
  
  def at_start_row?
    [1,6].include?(pos[0])
  end
end