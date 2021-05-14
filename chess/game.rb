require_relative 'display'
require_relative 'player'

class Game
  attr_reader :board, :display, :players

  def initialize
    @board = Board.new
    @display = Display.new(@board)
    @players = [Player.new(:white, @display), Player.new(:black, @display)]
  end

  def play
    until board.checkmate?(current_player.color)
      if board.in_check?(current_player.color)
        board.player_messages << "#{current_player.color} is in check!"
      end
      board.player_messages << "It's #{current_player.color}'s turn"

      start_pos, end_pos = current_player.get_move
      binding.pry if start_pos == "troubleshoot"
      board.move_piece(current_player.color, start_pos, end_pos)
      
      board.player_messages.clear
      switch_players
    end
    
    display.render
    puts "Checkmate! #{current_player.color.to_s.capitalize} loses"
    
  rescue => error
    board.player_messages.clear
    board.player_messages << error
    retry
  end

  private

  def switch_players
    @players.rotate!
  end

  def current_player
    @players.first
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.play
end