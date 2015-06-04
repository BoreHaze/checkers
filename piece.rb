class Piece

  UP_DELTAS   = [[-1,-1], [-1, 1]]
  DOWN_DELTAS = [[ 1,-1], [ 1, 1]]

  attr_reader :position, :color

  def initialize(board, position, color)
    @color = color
    @position = position
    @board = board
    @king = false
  end

  def perform_slide(pos)

    return false unless move_deltas.any? do |dy, dx|
      [position[0] + dy, position[1] + dx] == pos
    end

    return false if @board.out_of_bounds?(pos) || @board.occupied?(pos)

    @board[position] = nil
    @position        = pos
    @board[position] = self

    @king = true if promote?

  end

  def perform_jump(pos)



  end

  def promote?

  end

  def move_deltas
    return UP_DELTAS + DOWN_DELTAS if king?

    @color == :red ? UP_DELTAS : DOWN_DELTAS
  end

  def king?
    @king
  end

  def render
    "●"
  end

end
