require_relative "tile.rb"
require "colorize"

class Board
  def initialize(length, width, number_of_bombs)
    @grid = (0...length).map do |row|
      (0...width).map do |col|
        Tile.new([row,col])
      end
    end
    set_bombs(number_of_bombs)
    set_bomb_proximity_count
  end

  def flag_tile(position)
    tile = self[position]
    tile.flag
  end

  def reveal_tiles(position)
    tile = self[position]
    tile.reveal
    reveal_neighbors(position)
  end

  def render
    puts "  #{(0...board_length).to_a.join(' ')}".colorize(:light_magenta)
    @grid.each_with_index do |row, i|
      puts "#{i.to_s.colorize(:light_magenta)} #{row.map{ |tile| tile.value }.join(" ")}"
    end
    puts "Bombs left: #{bomb_count - flag_count}".colorize(:cyan)
  end

  def render_final
    puts "  #{(0...board_length).to_a.join(' ')}".colorize(:light_magenta)
    @grid.each_with_index do |row, i|
      puts "#{i.to_s.colorize(:light_magenta)} #{row.map{ |tile| tile.final_value }.join(" ")}"
    end
  end

  def board_length
    @grid.length
  end

  def board_width
    @grid[0].length
  end

  def lose?
    @grid.flatten.any? do |tile|
      tile.revealed? && tile.bomb?
    end
  end

  def win?
    @grid.flatten.all? do |tile|
      tile.revealed? ^ tile.bomb?
    end
  end

  private
  
  def set_bombs(number_of_bombs)
    bomb_positions = []

    until bomb_positions.length == number_of_bombs
      x = (0...board_length).to_a.sample
      y = (0...board_width).to_a.sample
      bomb_positions << [x,y] unless bomb_positions.include?([x,y])
    end

    bomb_positions.each do |pos|
      tile = self[pos]
      tile.set_bomb
    end
  end

  def set_bomb_proximity_count
    @grid.each_with_index do |row, i|
      row.each_with_index do |tile, j|
        pos = [i, j] 
        neighbors = get_neighbors(pos)
        tile.bomb_proximity_count = neighbors.count { |neighbor| neighbor.bomb? }
      end
    end
  end

  def reveal_neighbors(position)
    tile = self[position]
    neighbors = get_neighbors(position)
    neighbors.delete_if { |neighbor_tile| neighbor_tile.revealed?}
    return true if neighbors.empty?

    if tile.can_reveal_neighbors?
      neighbors.each do |neighbor_tile|
        neighbor_tile.reveal
        reveal_neighbors(neighbor_tile.position)
      end
    end

  end

  def get_neighbors(position)
    neighbors = []
    row, col = position
    (row - 1..row + 1).each do |i|
      (col - 1..col + 1).each do |j|
        if (0...board_length).include?(i) && (0...board_width).include?(j)
          next if [i, j] == position
          neighbors << self[[i,j]]
        end
      end
    end
    neighbors
  end

  def [](position)
    row,col = position
    @grid[row][col]
  end

  def bomb_count
    @grid.flatten.count { |tile| tile.bomb?}
  end

  def flag_count
    @grid.flatten.count { |tile| tile.flagged?}
  end

  # for dev purposes
  def reveal_all_tiles
    @grid.each do |row|
      row.each do |tile|
        tile.reveal unless tile.bomb?
      end
    end
    nil
  end

  # for dev purposes
  # def inspect
  #   @grid.map do |row|
  #     row.map do |tile|
  #       tile.value
  #     end
  #   end
  # end
end