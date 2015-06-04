require_relative 'board.rb'
require_relative 'piece.rb'
require_relative 'human_player.rb'

class WrongColorError < StandardError
end

class Game
  def initialize(board, red_player, black_player)
    @board = board
    @red_player = red_player
    @black_player = black_player
    @current_player = @red_player
  end

  def play

    puts "Welcome to checkers"
    @board.setup_game
    @board.display

    until @board.lost?(@current_player.color) do

      begin
        puts "#{@current_player.name}'s turn"
        input_sequence = @current_player.play_turn
        piece_pos = input_sequence.shift
        raise WrongColorError if @board[piece_pos].color != @current_player.color
        @board[piece_pos].perform_moves(input_sequence)
      rescue InvalidMoveError
        puts "Invalid move, please try again"
        retry
      rescue WrongColorError
        puts "Not your piece dawg, try again"
        retry
      end

      @board.display
      toggle_player
    end

    toggle_player
    puts "#{@current_player.name} won!"
    @board.display

  end

  def toggle_player
    if @current_player == @red_player
      @current_player = @black_player
    else
      @current_player = @red_player
    end
  end
end
