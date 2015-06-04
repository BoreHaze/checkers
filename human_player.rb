require_relative 'player'

class BadInputError < StandardError
end

class HumanPlayer < Player

  NUM_STRS = %w(0 1 2 3 4 5 6 7)

  def play_turn
    puts "Please enter a single move in the form of 'yx, yx' (from, to)"
    puts "For move sequences, simply add additional comma separated coordinates"

    begin
      move_str_arr = gets.chomp.split(',').map { |move| move.strip.split('') }
      raise BadInputError unless move_str_arr.count >= 2

      parse_move_seq(move_str_arr)

    rescue BadInputError
      puts "Invalid input, pls retry"
      retry

    end
  end

  def parse_move_seq(move_str_arr)
    move_sequence = []
    move_str_arr.each do |pair|
      raise BadInputError unless pair.all? { |n| NUM_STRS.include?(n) }
      new_pair = []
      pair.each { |n| new_pair << n.to_i }
      move_sequence << new_pair
    end

    move_sequence
  end
end
