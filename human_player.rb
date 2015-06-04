require_relative 'player'

class BadInputError < StandardError
end

class HumanPlayer < Player

  NUM_STRS = %w(0 1 2 3 4 5 6 7)

  def play_turn
    puts "Please enter a single move in the form of 'yx, yx' (from, to)"
    puts "For move sequences, simply add additional comma separated coordinates"

    move_sequence_str = gets.chomp.split(',').map { |move| move.strip.split('') }
    raise BadInputError unless move_sequence_str.count >= 2

    move_sequence = []
    move_sequence_str.each do |pair|
      raise BadInputError unless pair.all? { |n| NUM_STRS.include?(n) }
      new_pair = []
      pair.each { |n| new_pair << n.to_str }
      move_sequence << pair
    end

    move_sequence
  end
end
