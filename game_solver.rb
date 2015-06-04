require_relative 'board.rb'
require_relative 'piece.rb'


class GameSolver

  def initialize(board, color, depth=3)
    @board = board
    @color = color
    @depth = depth
  end

  def solve_n_moves_ahead(gen=0, board=@board)
    return {} if gen > @depth

    move_table = Hash.new { |h,k| h[k] = 0 }

    step_moves, jump_moves = get_legal_moves(board, @color)
    all_moves = step_moves + jump_moves

    all_moves.each do |move|
      next_board = board.deep_dup
      next_board[move.first].perform_move(move.drop(1))

      if (move[0][0] - move[1][0]).abs == 2
        move_table[move] += move.count - 1
      end


      all_opponent_moves = get_legal_moves(next_board, enemy_color)

      all_oponent_moves.each do |e_move|
        next_turn_board = next_board.deep_dup
        next_turn_board[e_move.first].perform_move(e_move.drop(1))
        next_gen_step_vals = solve_n_moves_ahead(gen + 1, next_board)
        move_table[step] += next_gen_step_vals.values.inject(:+)
      end
    end

    
  end

  #returns steps, jumps
  def get_legal_moves(board, color)
    step_moves = []
    jump_moves = []

    board.color_pieces(color).each do |piece|
      piece.legal_steps.each do |step|
        step_moves << [piece.position] + [step]
      end

      piece.legal_jump_sequences.each do |seq|
        jump_moves << [piece.position] + seq
      end
    end

    [step_moves, jump_moves]
  end

  def enemy_color
    @color == :red ? :black : :red
  end

end
