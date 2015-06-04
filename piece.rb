# encoding: utf-8

require_relative 'board.rb'
require 'byebug'

class InvalidMoveError < StandardError
end

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

  def has_legal_moves?
    move_deltas.any? do |dy, dx|
      move = [position[0] + dy, position[1] + dx]
      next true if @board.valid_destination?(move)
      j_move = [move[0] + dy, move[1] + dx]
      next true if @board.valid_destination?(j_move) && @board.jumpable_square?(move, color)
    end
  end

  def legal_steps
    steps = []
    move_deltas.each do |dy, dx|
      step = [position[0] + dy, position[1] + dx]
      steps << step if @board.valid_destination?(move)
    end

    steps
  end

  def legal_jump_sequences
    jump_sequences = []
    move_deltas.each do |delta|
      debugger
      dy, dx          = delta
      jump_to         = [position[0] + (2*dy), position[1] + (2*dx)]
      jump_over       = [position[0] + dy, position[1] + dx]
      child_sequences = []

      if @board.valid_destination?(jump_to) && @board.jumpable_square?(jump_over, color)
        next_board = @board.deep_dup
        next_board[position].make_move(jump_to, jump_over)
        child_sequences = next_board[jump_to].legal_jump_sequences
        jump_sequences << [jump_to]
        child_sequences.each { |seq| jump_sequences << [jump_to] + seq }
      end
    end

    jump_sequences
  end

  def perform_moves(sequence)
    if valid_move_seq?(sequence)
      perform_moves!(sequence)
    else
      raise InvalidMoveError
    end
  end

  def perform_moves!(sequence)
    if sequence.count == 1
      if !perform_slide(sequence[0])
        raise InvalidMoveError unless perform_jump(sequence.first)
      end
    else
      sequence.each do |move|
        raise InvalidMoveError unless perform_jump(move)
      end
    end
  end

  def valid_move_seq?(sequence)
    copy_board = @board.deep_dup

    begin
      copy_board[position].perform_moves!(sequence)
    rescue InvalidMoveError
      return false
    else
      return true
    end
  end

  def perform_slide(pos)
    return false unless move_deltas.any? do |dy, dx|
      [position[0] + dy, position[1] + dx] == pos
    end

    return false unless @board.valid_destination?(pos)
    make_move(pos)
  end

  def perform_jump(pos)
    delta = []
    return false unless move_deltas.any? do |dy, dx|
      delta = [dy, dx]
      [position[0] + (dy*2), position[1] + (dx*2)] == pos
    end

    return false unless @board.valid_destination?(pos)
    jumped_pos = [position[0] + delta[0], position[1] + delta[1]]
    return false unless @board.jumpable_square?(jumped_pos, color)

    make_move(pos, jumped_pos)
  end

  def make_move(pos, jumped_pos=nil)
    @board[position]   = nil
    @position          = pos
    @board[position]   = self
    @board[jumped_pos] = nil unless jumped_pos.nil?

    @king = true if promote?
    true
  end

  def promote?
    position[0] == ((color == :black) ? Board::BOARD_TOP : Board::BOARD_BOT)
  end

  def move_deltas
    return UP_DELTAS + DOWN_DELTAS if king?
    @color == :black ? UP_DELTAS : DOWN_DELTAS
  end

  def king?
    @king
  end

  def render
    return (color == :black ? "♚" : "♔") if king?
    color == :black ? "●" : "○"
  end

end
