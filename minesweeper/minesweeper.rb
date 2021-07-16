require_relative "board"
require "colorize"
require "yaml"

class Minesweeper
  def initialize(length = 9, width = 9, number_of_bombs = 10)
    @board = Board.new(length, width, number_of_bombs)
    # add new options to Minesweeper#take_turn
    @menu_options = [:save, :load, :quit]
    @turn_options = [:r, :f] + @menu_options
  end

  def run
    take_turn until game_over?
    system("clear")
    render_final_board
    puts "you win!".colorize(:green) if win?
    puts "you lose!".colorize(:red) if lose?
  end

  private

  attr_reader :board

  def take_turn
    system("clear")
    render_board
    action, position = get_user_turn

    case action
    when :f
      flag_tile(position) 
    when :r
      reveal_tiles(position) 
    when :save
      puts "saving..."
      sleep(0.5)
      save_game
    when :load
      puts "loading..."
      sleep(0.5)
      load_game
    when :quit
      puts "exiting game..."
      sleep(0.5)
      exit_game
    else
      raise puts "action wasn't specificied correctly"
      sleep(2)
    end
  end

  def get_user_turn
    action = nil
    position = nil
    
    until valid_action?(action) && valid_position?(position)
      puts "Flag or reveal a position (e.g. 'f 01' or 'r 23')"
      puts "'save' to save game; 'load' to load game; 'quit' to quit game"
      
      begin
        action, position = parse_turn(gets.chomp)
        return [action, nil] if @menu_options.include?(action)
      rescue => exception
        puts "Use the following format: 'f 01' or 'r 23'"
        action, position = nil, nil
      end
    end
    [action, position]
  end

  def valid_action?(action)
      @turn_options.include?(action)
  end

  def save_game
    File.open("minesweeper_save.yml", "w") { |file| file.write(@board.to_yaml) }
    puts "Game saved"
    sleep(0.5)
  end
  
  def load_game
    @board = YAML::load(File.read("minesweeper_save.yml"))
    puts "Game loaded"
    sleep(0.5)
  end

  def exit_game
    begin
      exit!
    rescue SystemExit
      puts "Game successfully quit"
    end
  end

  def valid_position?(position)
    position.is_a?(Array) &&
      position.length == 2 &&
      (0...board.board_length).include?(position[0]) &&
      (0...board.board_width).include?(position[1])
  end

  def parse_turn(turn)
    option = turn.downcase.to_sym
    if @menu_options.include?(option)
      return [option, nil]
    end

    action, position = turn.split(" ")
    action = action.downcase.to_sym
    position = position.split("").map(&:to_i)
    [action, position]
  end

  def flag_tile(position)
    board.flag_tile(position)
  end

  def reveal_tiles(position)
    board.reveal_tiles(position)
  end

  def game_over?
    win? || lose?
  end

  def win?
    board.win?
  end

  def lose?
    board.lose?
  end

  def render_board
    board.render
  end

  def render_final_board
    board.render_final
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Minesweeper.new
  game.run
end