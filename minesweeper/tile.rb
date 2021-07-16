require "colorize"

class Tile
  attr_accessor :bomb_proximity_count
  attr_reader :position

  def initialize(position)
    @position = position
    @bomb = false
    @revealed = false
    @flagged = false
    @bomb_proximity_count = nil
  end

  def value
    if flagged?
      "o".colorize(:green)
    # elsif @bomb && !@revealed # Only used to debug!
    #   return :B # Only used to debug!
    elsif !revealed?
      "*".colorize(:light_white)
    else
      @bomb_proximity_count == 0 ? " " : @bomb_proximity_count.to_s.colorize(:light_blue)
    end
  end
  
  def final_value
    if flagged?
      "o".colorize(:green)
    elsif bomb?
      return "X".colorize(:red) if revealed?
      return "B".colorize(:light_yellow) if !revealed?
    elsif !revealed?
      "*".colorize(:light_white)
    else
      @bomb_proximity_count == 0 ? " " : @bomb_proximity_count.to_s.colorize(:light_blue)
    end
  end

  def can_reveal_neighbors?
    @flagged == false &&
      @bomb == false &&
      @bomb_proximity_count == 0
  end

  def flag
    @flagged = !@flagged unless @revealed
  end

  def flagged?
  @flagged
  end

  def reveal
    @revealed = true unless @flagged
  end

  def revealed?
    @revealed
  end
  
  def set_bomb
    @bomb = true
  end

  def bomb?
    @bomb
  end
end