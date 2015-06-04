require_relative 'piece'

class Board

  COLORS        = [:black, :red]
  BOARD_TOP     = 0
  BOARD_BOT     = 7
  PIECE_PER_ROW = 4
  START_ROWS    = 3

  def initialize
    @board = Array.new(8) { Array.new(8) }
  end

  def setup_game
    COLORS.each { |color| setup_side(color) }
  end

  def setup_side(color)
    start_row, direction = ((color == :red) ? [BOARD_TOP, 1] : [BOARD_BOT, -1])
    row = start_row

    START_ROWS.times do
      start_col = (row.even? ? 0 : 1)
      col = start_col
      PIECE_PER_ROW.times do
        Piece.new(self, [row, col], color)
        col += 2
      end

      row += direction
    end
  end

  def [](pos)
    y, x = pos
    @board[y][x]
  end

  def []=(pos, piece)
    y, x = pos
    @board[y][x] = piece
  end

  def display
    horizontal_line = "+-------------------------------+"
    puts horizontal_line
    @board.each do |row|
      print "|"
      row.each  do |square|
        square.nil? ? (print "   |") : (print " #{square.render} |")
      end

      puts "\n" + horizontal_line
    end

    nil
  end
end
