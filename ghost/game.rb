require_relative "./player.rb"
require_relative "./aiplayer.rb"
require "set"

class Game
	attr_reader :fragment

	@@dictionary = Hash.new { |h, k| h[k] = Set.new }

	def initialize(player_hash, easy = false)
		@easy = easy
		@fragment = ""
		@losses = Hash.new(0)
		@players = Array.new
		
		self.create_players(player_hash)
		self.create_dictionary("./ghost/dictionary.txt")
  end

	def run
		self.print_welcome

		until @players.length == 1
			self.play_round
			
			if @losses[previous_player] == 5
				puts "GHOST, #{previous_player.name} is out!"
				@players.delete_at(-1)
			end
		end
		
		puts "#{@players[0].name} wins!"
	end
	
	def play_round
		@fragment.clear
		
		until Game.dictionary[@fragment[0]].include?(@fragment)
			self.take_turn
			self.next_player!
		end
		
		print_loser
		@losses[previous_player] += 1
	end
	
	def take_turn
		if !current_player.ai?
			self.print_standings
			self.display_options

			guess = self.current_player.guess
			
			until valid_play?(guess)
				if guess == "help"
					system("clear")
					self.display_options
				elsif guess == "quit"
					raise "GAME OVER" if guess == "quit"
				else
					alert_not_valid
				end
				guess = self.current_player.guess
			end
			
			@fragment << guess
			system("clear")
			
		else
			system("clear")
			potential_plays = self.all_valid_plays
			unless @fragment.empty?
				puts "The word was: #{@fragment}"
				puts ""
			end
			
			if @easy
				ai_guess = potential_plays.sample
			else
				ai_guess = self.current_player.ai_guess(@fragment, potential_plays, @players.length)
			end
			
			@fragment << ai_guess
			sleep(1.5)
			puts "->  #{current_player.name} chooses: #{ai_guess}"
			puts ""
			sleep(1.5)
			puts "The word is now: #{@fragment}"
			sleep(2.5)
			system("clear")
		end
	end
	
	def valid_play?(char)
		return false if ["help", "quit"].include?(char)
		
		guess = @fragment + char
		
		Game.dictionary[guess[0]].any? do |word| 
			word.start_with?(guess)
		end
	end
	
	def all_valid_plays
		valid_plays = Array.new
		
		("a".."z").each do |ch|
			valid_plays << ch if valid_play?(ch)
		end
		
		valid_plays
	end
	
	def print_welcome
		system("clear")
		puts "Welcome to ghost!"
		puts ""
	end

	def alert_not_valid
		puts ""
		puts "No word can be made using that letter."
		puts "Please pick another."
		puts ""
		puts "The current word is '#{@fragment}'"
		puts ""
	end
	
	def print_loser
		puts ""
		puts "**  #{previous_player.name} spelled '#{@fragment}'!  **"
		puts "**  #{previous_player.name} loses this round!  **"
		puts ""
		sleep(2)
		system("clear")
	end

	def display_options
		puts "The current word is: #{@fragment}"
		puts ""
		
		puts "#{self.current_player.name}, your ONLY choices are #{self.all_valid_plays}" if @easy
		puts ""
	end
	
	def print_standings
		@players.each do |player|
			puts "#{player.name}: #{self.record(player)}"
		end
		puts ""
	end

	def self.dictionary
		@@dictionary
	end	

	def record(player)
		"GHOST"[0...@losses[player]]
	end
	
	def current_player
		@players.first
	end

	def previous_player
		@players[-1]
	end

	def next_player!
		@players.rotate!
	end

	def create_players(player_hash)
		player_hash.each do |player_name, ai|
			if ai
				@players << Ai_player.new(player_name)
			else
				@players << Player.new(player_name)
			end
		end
	end

	def create_dictionary(dictionary = "dictionary.txt")
		File.open(dictionary, 'r') do |file|
			while !file.eof?
    		word = file.readline.chomp
    		@@dictionary[word[0]] << word
    	end
		end
	end
end

if __FILE__ == $PROGRAM_NAME
	puts "Enter player name\n"
	player_name = gets.chomp
	begin
	puts "Play on easy mode? (y/n)"
	easy_response = gets.chomp.downcase
	unless ["y", "n"].include?(easy_response)
		raise "please enter 'y' or 'n'"
	end
	rescue => e
		puts e.message
	retry
	end
	easy = easy_response === 'y' ? true : false
	g = Game.new({player_name => false, "The computer" => true}, easy)
	# puts player_name
	g.run
end