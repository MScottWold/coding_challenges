class Ai_player
  attr_reader :name

  ALPHA = ("a".."z").to_a

  def initialize(name)
    @name = name
    @ai = true
  end

  def ai?
    @ai
  end

  def ai_guess(fragment, potential_plays, number_of_players)
    return ALPHA.sample if fragment.empty?

    losing_moves = []
    other_moves = []

    potential_plays.each do |letter|
      guess = fragment + letter

      if winning_move?(guess, number_of_players)
        puts ""
        puts "-----  #{self.name} could have chosen #{potential_plays}"
        puts "-----  #{self.name.capitalize} says, 'I WILL CRUSH YOU WITH THE LETTER '#{letter}''"
        return letter 
      end

      if losing_move?(guess)
        losing_moves << letter 
      else
        other_moves << letter
      end
    end
    
    if other_moves.empty?
      losing_moves.sample 
    else
      self.best_possible_move(fragment, other_moves, number_of_players)
    end
  end

  def win?(word, guess, number_of_players)
    (word.length - guess.length) % number_of_players != 0
  end

  def winning_move?(guess, number_of_players)
    Game.dictionary[guess[0]].all? do |word|
      if word.start_with?(guess)
        win?(word, guess, number_of_players)
      else
        true
      end
    end
  end

  def losing_move?(guess)
    Game.dictionary[guess[0]].include?(guess)
  end

  def best_possible_move(fragment, potential_moves, number_of_players)
    max_wins = 0
    best_moves = []

    potential_moves.each do |letter|
      guess = fragment + letter

      wins = Game.dictionary[guess[0]].count do |word| 
        word.start_with?(guess) && win?(word, guess, number_of_players)
      end

      # troubleshooting
      # puts "___"
      # puts "#{letter} has #{wins} wins"
      # puts "___"
      
      if wins > max_wins
        best_moves.clear
        best_moves << letter
        max_wins = wins
      elsif wins == max_wins
        best_moves << letter
      end
    end

    puts "-----  #{self.name} could have chosen #{potential_moves}"
    puts "-----  #{best_moves} was the best"
    
    best_moves.sample
  end
end