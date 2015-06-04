class Player

  attr_reader :name, :color

  def initialize(name, color)
    @name = name
    @color = color
  end

  def play_turn
    raise NotImplementedError
  end

end
