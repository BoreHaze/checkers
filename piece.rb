class Piece

  UP_DELTAS   = [[-1,-1], [-1, 1]]
  DOWN_DELTAS = [[ 1,-1], [ 1, 1]]

  def initialize(board, position, color)
    @color = color
    @position = position
    @board = board
    @king = false
  end

  def perform_slide

  end

  def perform_jump

  end

  def promote?

  end

  def move_deltas


  end

end
