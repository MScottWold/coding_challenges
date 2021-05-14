class Player
  attr_reader :color, :display

  def initialize(color, display)
    @color = color
    @display = display
  end

  def get_move
    start_pos = nil
    end_pos = nil
    
    until start_pos
      display.render
      start_pos = display.cursor.get_input
    end
    
    until end_pos
      display.render
      end_pos = display.cursor.get_input
    end

    [start_pos, end_pos]
  end
end