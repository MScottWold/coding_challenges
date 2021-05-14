class Player
  attr_reader :name

  ALPHA = ("a".."z").to_a

  def initialize(name)
    @name = name
    @ai = false
  end

  def ai?
    @ai
  end

  def guess
    other_options = ["help", "quit"]
    valid_char = false
    until valid_char  
      puts "#{@name.capitalize}, please choose a letter"
      puts "(type 'help' for help or 'quit' to end the game)"
      print "-> "
      ch = gets.chomp.downcase
      valid_char = ALPHA.include?(ch) || other_options.include?(ch)
    end
    ch
  end
end