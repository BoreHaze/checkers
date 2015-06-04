require_relative 'board.rb'
require 'byebug'

class Piece

  UP_DELTAS   = [[-1,-1], [-1, 1]]
  DOWN_DELTAS = [[ 1,-1], [ 1, 1]]

  attr_reader :position, :color

  def initialize(board, position, color)
    @color = color
    @position = position
    @board = board
    @king = false

    @board[position] = self
  end

  def perform_slide(pos)
    return false unless move_deltas.any? do |dy, dx|
      [position[0] + dy, position[1] + dx] == pos
    end

    return false unless @board.in_bounds?(pos) && !@board.occupied?(pos)

    @board[position] = nil
    @position        = pos
    @board[position] = self

    @king = true if promote?
  end

  def perform_jump(pos)

    delta = []
    return false unless move_deltas.any? do |dy, dx|
      delta = [dy, dx]
      [position[0] + (dy*2), position[1] + (dx*2)] == pos
    end

    return false unless @board.in_bounds?(pos) && !@board.occupied?(pos)

    jumped_pos = [position[0] + delta[0], position[1] + delta[1]]
    return false unless @board.occupied?(jumped_pos)
                     && @board.enemy?(jumped_pos, color)

     @board[position] = nil
     @position        = pos
     @board[position] = self

     @board[jumped_pos] = nil

     @king = true if promote?
  end

  def promote?

  end

  def move_deltas
    return UP_DELTAS + DOWN_DELTAS if king?

    @color == :black ? UP_DELTAS : DOWN_DELTAS
  end

  def king?
    @king
  end

  def render
    color == :black ? "●" : "○"
  end

end
