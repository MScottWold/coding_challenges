require_relative 'pieces'
require_relative 'display'
require 'colorize'
require 'pry'

class Board
  attr_reader :rows
  attr_accessor :player_messages

  def initialize
    @rows = Array.new(8) {Array.new(8)}
    @sentinel = NullPiece.instance
    @player_messages = Array.new
    fill_board
  end

  def in_check?(color)
    king_pos = find_king(color)
    oppos_color = color == :white ? :black : :white
    @rows.each do |row|
      row.each do |piece|
        return true if piece.moves.include?(king_pos) &&
          piece.color == oppos_color
      end
    end
    false 
  end

  def checkmate?(color)
    all_valid_moves = Array.new

    rows.each do |row|
      row.each do |piece|
        all_valid_moves += piece.valid_moves if piece.color == color
      end
    end

    all_valid_moves.empty?
  end

  def [](pos)
    x,y = pos
    @rows[x][y]
  end
  
  def []=(pos, piece)
    x,y = pos
    @rows[x][y] = piece
  end
  
  # Board#show_moves is only for troubleshooting purposes
  def show_moves(piece)
    puts "  0 1 2 3 4 5 6 7"

    (0..7).map do |i|
      print i
      (0..7).map do |j|
        if piece.moves.include?([i, j])
          print " *"
        else
          print " #{self[[i, j]].symbol}"
        end
      end
      puts
    end
    nil
  end
  
  def move_piece(color, start_pos, end_pos)
    piece = self[start_pos] 
    raise "There is no piece there" if piece.is_a? NullPiece
    raise "You can only move your owne pieces" unless piece.color == color
    raise "You cannot move the piece to that location" unless piece.moves.include?(end_pos)
    raise "You cannot put yourself in check" if piece.move_into_check?(end_pos)

    self[start_pos] = sentinel
    self[end_pos] = piece
    piece.pos = end_pos
    piece
  end

  def deep_dup
    board_dup = Board.new
    
    self.rows.each_with_index do |row, i|
      row.each_with_index do |orig_piece, j|
        if orig_piece.is_a? NullPiece
          board_dup[[i, j]] = NullPiece.instance
        else
          board_dup[[i, j]] = orig_piece.class.new(orig_piece.color, [i, j], board_dup)
        end
      end
    end

    board_dup
  end
  
  private 
  
  attr_reader :sentinel
  
  def find_king(piece_color)
    @rows.each do |row|
      row.each do |piece|
        return piece.pos if piece.is_a?(King) && piece.color == piece_color
      end
    end
  end
  
  def fill_board
    # fill back rows
    pieces = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
    
    (0..7).each do |j|
      self[[0, j]] = pieces[j].new(:black, [0, j], self)
      self[[7, j]] = pieces[j].new(:white, [7, j], self)
    end
    
    # fill pawns
    (0..7).each do |col| 
      self[[6, col]] = Pawn.new(:white, [6, col], self)
      self[[1, col]] = Pawn.new(:black, [1, col], self)
    end
    
    # fill NullPiece
    (2..5).each do |i|
      (0..7).each do |j|
        self[[i, j]] = @sentinel
      end
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  board_1 = Board.new
  board_2 = board_1.deep_dup

  board_1.move_piece(:black, [0, 1], [2, 2])

  board_3 = board_1.deep_dup

  d1 = Display.new(board_1)
  d2 = Display.new(board_2)
  d3 = Display.new(board_3)
  binding.pry
end