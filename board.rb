require 'colorize'
require_relative 'piece'
require 'byebug'

class Board
  GRID_SIZE = 8
  ROWS = 3
  attr_reader :grid

  def initialize
    @grid = Array.new(GRID_SIZE) { Array.new(GRID_SIZE) }
  end

  def setup_board
    grid.each_with_index do |row, i|
      row.each_with_index do |position, j|
        if (i + j).odd? && i < ROWS
          grid[i][j] = Piece.new(:green, [i, j], self)
        elsif (i + j).odd? && i >= GRID_SIZE - ROWS
          grid[i][j] = Piece.new(:yellow, [i, j], self)
        end
      end
    end
  end

  def render
    grid.each_with_index do |row, i|
      print "#{GRID_SIZE - (i + 1)} "
      row.each_with_index do |position, j|
        background = ((i + j).even? ? :white : :black)
        if self[[i, j]].nil?
          print '  '.colorize(:background => background)
        else
          print self[[i, j]].show.colorize(:background => background)
        end
      end
      puts
    end
    puts "   0 1 2 3 4 5 6 7"
    nil
  end

  def make_move_sequence(sequence)
    raise ArgumentError.new('Must start on a valid piece!') if self[sequence[0]].nil?
    self[sequence[0]].perform_moves(sequence)
  end

  def move(start_pos, end_pos)
    place_piece(end_pos, self[start_pos])
    self[start_pos] = nil
  end

  def place_piece(pos, piece)
    self[pos] = piece
    piece.board = self
    piece.position = pos
  end

  def over?
    return false
  end

  def dup
    duped_board = Board.new
    @grid.flatten.compact.each do |piece|
      duped_board[piece.position] = Piece.new(piece.color, piece.position, duped_board, piece.king?)
    end
    duped_board
  end

  def size
    GRID_SIZE
  end

  def [](pos)
    x, y = pos
    grid[x][y]
  end

  def []=(pos, piece)
    x, y = pos
    grid[x][y] = piece
  end
end