require_relative 'player.rb'
require_relative 'board.rb'
require 'byebug'



class ComputerPlayer < Player
  attr_reader :board

  def initialize(color, board, name="Vladimir Putin")
    super(name, color)
    @board = board
  end

  def play_turn
    step_moves = []
    jump_moves = []

    @board.color_pieces(color).each do |piece|
      piece.legal_steps.each do |step|
        step_moves << [piece.position] + [step]
      end

      piece.legal_jump_sequences.each do |seq|
        jump_moves << [piece.position] + seq
      end
    end


    if jump_moves.empty?
      return step_moves.sample
    else
      return jump_moves.max { |jmp| jmp.count }
    end

  end


end
