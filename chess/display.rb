require_relative 'cursor'
require_relative 'board'
require 'colorize'
require 'pry'

class Display
  attr_reader :board, :cursor
  def initialize(board)
    @cursor = Cursor.new([0,0], board)
    @board = board
  end

  def render
    system("clear")

    puts "  A  B  C  D  E  F  G  H"

    board.rows.each_with_index do |row, i|
      print "#{8 - i} "
      row.each_with_index do |ele, j|
        if @cursor.cursor_pos == [i, j] && @cursor.selected
          print " #{ele.symbol} ".colorize(:color => ele.color, 
            :background => :light_magenta)
        elsif @cursor.cursor_pos == [i, j] && !@cursor.selected
          print " #{ele.symbol} ".colorize(:color => ele.color, 
            :background => :cyan)
        elsif (i + j).even?
          print " #{ele.symbol} ".colorize(:color => ele.color, 
            :background => :light_blue)
        else
          print " #{ele.symbol} ".colorize(:color => ele.color,
            :background => :light_black)
        end
      end
      puts
    end

    puts board.player_messages
    nil
  end
end

if __FILE__ == $PROGRAM_NAME
  display = Display.new(Board.new)
  while true
    system("clear")
    display.render
    display.cursor.get_input
  end
end