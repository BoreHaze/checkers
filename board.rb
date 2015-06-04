require_relative 'piece'
require 'colorize'

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

  def deep_dup
    new_board = Board.new
    pieces.each { |piece| Piece.new(new_board, piece.position, piece.color, piece.king?) }
    new_board
  end

  def pieces
    @board.flatten.compact
  end

  def color_pieces(color)
    pieces.select { |piece| piece.color == color }
  end

  def lost?(color)
    remaining = color_pieces(color)
    remaining.empty? || remaining.none? { |piece| piece.has_legal_moves? }
  end

  def [](pos)
    y, x = pos
    @board[y][x]
  end

  def []=(pos, piece)
    y, x = pos
    @board[y][x] = piece
  end

  def valid_destination?(pos)
    in_bounds?(pos) && !occupied?(pos)
  end

  def jumpable_square?(pos, color)
    occupied?(pos) && enemy?(pos, color)
  end

  def in_bounds?(pos)
    pos.all? { |coord| coord.between?(BOARD_TOP, BOARD_BOT) }
  end

  def occupied?(pos)
    !self[pos].nil?
  end

  def enemy?(pos, color)
    self[pos].color != color
  end

  def display
    #horizontal_line = " +-------------------------------+"
    puts "\n  0  1  2  3  4  5  6  7 "
    #puts horizontal_line
    @board.each_with_index do |row, row_idx|
      print "#{row_idx}"
      row.each_with_index  do |square, col_idx|
        (row_idx + col_idx).even? ? (bg = :yellow) : (bg = :red)
        square.nil? ? (print "   ".colorize(:background => bg)) : (print " #{square.render} ".colorize(:background => bg))
      end
      puts "\n"
      #puts "\n" + horizontal_line
    end

    nil
  end
end
